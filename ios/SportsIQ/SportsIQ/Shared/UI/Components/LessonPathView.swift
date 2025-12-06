//
//  LessonPathView.swift
//  Ola Ball
//
//  A Duolingo-style winding path of lesson nodes
//

import SwiftUI

struct LessonPathView: View {
    let lessons: [Lesson]
    let completions: [UUID: Int]  // lessonId -> completionCount
    let sport: Sport
    let onLessonStart: (Lesson) -> Void  // Called when user taps "Start" in popup
    let onVisibleSectionChange: ((LessonSection) -> Void)?  // Called when visible section changes

    // Binding for popup state - allows parent to dismiss popup on background tap
    @Binding var selectedLessonIndex: Int?

    // Scroll progress for yard line animation (0.0 = top, 1.0 = bottom)
    let scrollProgress: CGFloat

    // Path configuration
    private let nodeSize: CGFloat = 64
    private let verticalSpacing: CGFloat = 24
    private let horizontalOffset: CGFloat = 80  // How far nodes swing left/right

    // Track visible lessons for section detection
    @State private var visibleLessonIndices: Set<Int> = []
    @State private var currentSection: LessonSection?

    init(
        lessons: [Lesson],
        completions: [UUID: Int],
        sport: Sport,
        onLessonStart: @escaping (Lesson) -> Void,
        selectedLessonIndex: Binding<Int?>,
        onVisibleSectionChange: ((LessonSection) -> Void)? = nil,
        scrollProgress: CGFloat = 0.0
    ) {
        self.lessons = lessons
        self.completions = completions
        self.sport = sport
        self.onLessonStart = onLessonStart
        self._selectedLessonIndex = selectedLessonIndex
        self.onVisibleSectionChange = onVisibleSectionChange
        self.scrollProgress = scrollProgress
    }

    /// Determines if a lesson at a given index should be effectively locked
    /// A lesson is locked if the previous lesson hasn't been fully completed
    private func isLessonLocked(at index: Int) -> Bool {
        let lesson = lessons[index]

        // First lesson is never locked (unless explicitly marked as locked in DB, which shouldn't happen)
        if index == 0 {
            return lesson.isLocked
        }

        // For subsequent lessons, check if previous lesson is completed
        let previousLesson = lessons[index - 1]
        let previousCompletions = completions[previousLesson.id] ?? 0
        let previousCompleted = previousCompletions >= previousLesson.requiredCompletions

        // Lesson is locked if previous lesson isn't completed
        return !previousCompleted
    }

    /// The index of the current lesson (first unlocked, incomplete lesson)
    private var currentLessonIndex: Int? {
        lessons.indices.first { index in
            let lesson = lessons[index]
            let isLocked = isLessonLocked(at: index)
            let completionCount = completions[lesson.id] ?? 0
            return !isLocked && completionCount < lesson.requiredCompletions
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let totalHeight = calculateTotalHeight()

            ZStack(alignment: .top) {
                // Football field background (bottommost layer) - only for football
                if sport.slug == "football" {
                    FootballFieldBackground(
                        totalHeight: totalHeight,
                        scrollOffset: -scrollProgress * totalHeight * 0.5,
                        sportColor: sport.accentColor
                    )
                }

                // Yard line path (middle layer)
                YardLinePath(
                    nodePositions: calculateNodePositions(containerWidth: containerWidth),
                    lessonOrderIndices: lessons.map { $0.orderIndex },
                    scrollProgress: scrollProgress,
                    totalLessons: lessons.count
                )

                // Lesson nodes (foreground layer)
                VStack(spacing: verticalSpacing) {
                    ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                        lessonRow(lesson: lesson, index: index)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(
                                            key: VisibleLessonPreferenceKey.self,
                                            value: [VisibleLesson(index: index, orderIndex: lesson.orderIndex, frame: geo.frame(in: .global))]
                                        )
                                }
                            )
                    }
                }
                .padding(.vertical, .spacingM)
            }
        }
        .frame(height: calculateTotalHeight())
        .onPreferenceChange(VisibleLessonPreferenceKey.self) { visibleLessons in
            updateVisibleSection(from: visibleLessons)
        }
    }

    // MARK: - Node Position Calculations

    /// Calculates edge positions for the dashed path connecting lesson nodes
    /// Returns alternating bottom-edge and top-edge points so the path connects
    /// from the bottom of one node to the top of the next
    private func calculateNodePositions(containerWidth: CGFloat) -> [CGPoint] {
        guard lessons.count >= 2 else { return [] }

        let centerX = containerWidth / 2
        let nodeRadius = nodeSize / 2
        var pathPoints: [CGPoint] = []

        for index in 0..<(lessons.count - 1) {
            let currentPosition = pathPosition(for: index)
            let nextPosition = pathPosition(for: index + 1)

            let currentXOffset = horizontalOffset(for: currentPosition)
            let nextXOffset = horizontalOffset(for: nextPosition)

            // Row height is nodeSize + 30 (from lessonRow frame)
            let rowHeight = nodeSize + 30

            // Current node center Y
            let currentCenterY = CGFloat.spacingM + CGFloat(index) * (rowHeight + verticalSpacing) + (rowHeight / 2)
            // Next node center Y
            let nextCenterY = CGFloat.spacingM + CGFloat(index + 1) * (rowHeight + verticalSpacing) + (rowHeight / 2)

            // Bottom edge of current node
            let bottomEdgeY = currentCenterY + nodeRadius
            // Top edge of next node
            let topEdgeY = nextCenterY - nodeRadius

            // Add bottom edge of current node
            pathPoints.append(CGPoint(x: centerX + currentXOffset, y: bottomEdgeY))
            // Add top edge of next node
            pathPoints.append(CGPoint(x: centerX + nextXOffset, y: topEdgeY))
        }

        return pathPoints
    }

    /// Calculates the total height needed for the view
    private func calculateTotalHeight() -> CGFloat {
        guard !lessons.isEmpty else { return 100 }

        let rowHeight = nodeSize + 30
        let totalRows = CGFloat(lessons.count)
        let totalSpacing = CGFloat(lessons.count - 1) * verticalSpacing

        return (totalRows * rowHeight) + totalSpacing + (.spacingM * 2)
    }

    /// Determine which section should be displayed based on visible lessons
    private func updateVisibleSection(from visibleLessons: [VisibleLesson]) {
        // Filter to lessons that are actually visible on screen (in upper portion)
        let screenHeight = UIScreen.main.bounds.height
        let visibleThreshold = screenHeight * 0.4 // Top 40% of screen determines section

        let topVisibleLessons = visibleLessons.filter { lesson in
            lesson.frame.midY < visibleThreshold && lesson.frame.maxY > 0
        }

        // Get the topmost visible lesson's order index
        guard let topmostLesson = topVisibleLessons.min(by: { $0.frame.minY < $1.frame.minY }) else {
            // If no lessons in top portion, use the first visible lesson overall
            if let firstVisible = visibleLessons.min(by: { $0.frame.minY < $1.frame.minY }) {
                if let section = LessonSection.section(for: firstVisible.orderIndex, sportSlug: sport.slug) {
                    notifySectionChange(section)
                }
            }
            return
        }

        // Find the section for this lesson
        if let section = LessonSection.section(for: topmostLesson.orderIndex, sportSlug: sport.slug) {
            notifySectionChange(section)
        }
    }

    /// Notify parent of section change (with deduplication)
    private func notifySectionChange(_ section: LessonSection) {
        if currentSection?.id != section.id {
            currentSection = section
            onVisibleSectionChange?(section)
        }
    }

    // MARK: - Lesson Row
    @ViewBuilder
    private func lessonRow(lesson: Lesson, index: Int) -> some View {
        let position = pathPosition(for: index)
        let completionCount = completions[lesson.id] ?? 0
        let isSelected = selectedLessonIndex == index
        let nodeOffset = horizontalOffset(for: position)
        let isLocked = isLessonLocked(at: index)

        // Full-width row container - popup overlay is attached here for correct positioning
        GeometryReader { geometry in
            let screenHeight = UIScreen.main.bounds.height
            let nodePositionY = geometry.frame(in: .global).midY
            let popupHeight: CGFloat = 180 // Approximate popup height
            let bottomSafeArea: CGFloat = 100 // Account for tab bar and safe area
            let showAbove = nodePositionY + popupHeight + bottomSafeArea > screenHeight

            ZStack {
                // Node content positioned within the full-width row
                VStack(spacing: 8) {
                    // Lesson node button - tappable even when locked to show locked popup
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            if selectedLessonIndex == index {
                                selectedLessonIndex = nil
                            } else {
                                selectedLessonIndex = index
                            }
                        }
                    } label: {
                        LessonProgressRing(
                            completedSegments: completionCount,
                            totalSegments: lesson.requiredCompletions,
                            isLocked: isLocked,
                            icon: lessonIcon(for: index),
                            accentColor: sport.accentColor,
                            size: nodeSize,
                            isCurrentLesson: index == currentLessonIndex,
                            isSelected: isSelected
                        )
                    }
                    .buttonStyle(LessonButtonStyle())

                    // Lesson code badge (optional)
                    if let code = lesson.code {
                        Text(code)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(isLocked ? Color.textTertiary : sport.accentColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(isLocked ? Color.backgroundTertiary : sport.accentColor.opacity(0.15))
                            )
                    }
                }
                .offset(x: nodeOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Popup appears as overlay on the full-width row
            .overlay(alignment: showAbove ? .bottom : .top) {
                if isSelected {
                    // The row is full-width and centered on screen
                    // The node is offset by nodeOffset from the row center
                    // The popup should be centered on screen (at row center)
                    // The triangle should point at the node (at row center + nodeOffset)
                    LessonStartPopup(
                        lesson: lesson,
                        completionCount: completionCount,
                        sport: sport,
                        triangleOffsetX: nodeOffset, // Triangle offset from popup center to point at node
                        isLocked: isLocked,
                        showAbove: showAbove,
                        onStart: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                selectedLessonIndex = nil
                            }
                            onLessonStart(lesson)
                        },
                        onDismiss: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                selectedLessonIndex = nil
                            }
                        }
                    )
                    .padding(.horizontal, 20) // 20pt padding on each side
                    // Position popup below or above the node
                    .offset(y: showAbove ? -(nodeSize + 24) : (nodeSize + 24))
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8, anchor: showAbove ? .bottom : .top).combined(with: .opacity),
                        removal: .scale(scale: 0.9, anchor: showAbove ? .bottom : .top).combined(with: .opacity)
                    ))
                }
            }
        }
        .frame(height: nodeSize + 30) // Fixed height for the row
        .zIndex(isSelected ? 1 : 0) // Bring selected row to front so popup overlaps other rows
    }

    // MARK: - Path Position Logic
    private enum PathPosition {
        case center
        case left
        case farLeft
        case right
        case farRight
    }

    private func pathPosition(for index: Int) -> PathPosition {
        // Create a winding snake pattern
        // Pattern: center, right, center, left, center, right, center, left...
        let patternIndex = index % 8

        switch patternIndex {
        case 0: return .center
        case 1: return .right
        case 2: return .farRight
        case 3: return .right
        case 4: return .center
        case 5: return .left
        case 6: return .farLeft
        case 7: return .left
        default: return .center
        }
    }

    private func horizontalOffset(for position: PathPosition) -> CGFloat {
        switch position {
        case .center: return 0
        case .left: return -horizontalOffset * 0.6
        case .farLeft: return -horizontalOffset
        case .right: return horizontalOffset * 0.6
        case .farRight: return horizontalOffset
        }
    }

    // MARK: - Lesson Icons (Sport-specific)
    private static let footballIcons = [
        "football.fill",              // American football
        "figure.american.football",   // Football player in action
        "trophy.fill",                // Championships/winning
        "star.fill",                  // Star plays / standout moments
        "shield.lefthalf.filled",     // Defense
        "arrow.up.forward",           // Gaining yards / progression
        "clock.fill",                 // Game clock / timing
        "flag.fill",                  // Penalties / flags
        "rectangle.split.3x3.fill",   // The field / grid
        "hand.raised.fill",           // Catching / fair catch
        "arrow.triangle.branch",      // Play routes / strategy
        "bolt.fill"                   // Speed / explosive plays
    ]

    private static let baseballIcons = [
        "baseball.fill",              // Baseball
        "figure.baseball",            // Batter in action
        "trophy.fill",                // Championships/winning
        "star.fill",                  // Star plays / standout moments
        "hand.raised.fill",           // Catching
        "arrow.up.forward",           // Running bases / progression
        "clock.fill",                 // Game timing / innings
        "diamond.fill",               // Diamond / field shape
        "target",                     // Strike zone / accuracy
        "bolt.fill",                  // Speed / fastball
        "flag.fill",                  // Home run / foul poles
        "sportscourt.fill"            // The field / stadium
    ]

    private static let defaultIcons = [
        "star.fill",
        "trophy.fill",
        "bolt.fill",
        "flag.fill",
        "target",
        "clock.fill"
    ]

    private func lessonIcon(for index: Int) -> String {
        let icons: [String]
        switch sport.slug {
        case "football":
            icons = Self.footballIcons
        case "baseball":
            icons = Self.baseballIcons
        default:
            icons = Self.defaultIcons
        }
        return icons[index % icons.count]
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let subtitle: String?
    let color: Color

    /// Initialize with explicit title, subtitle, and color
    init(title: String, subtitle: String? = nil, color: Color) {
        self.title = title
        self.subtitle = subtitle
        self.color = color
    }

    /// Convenience initializer using Sport (legacy support)
    init(title: String, subtitle: String? = nil, sport: Sport) {
        self.title = title
        self.subtitle = subtitle
        self.color = sport.accentColor
    }

    /// Convenience initializer using LessonSection
    init(section: LessonSection) {
        self.title = section.title
        self.subtitle = section.subtitle
        self.color = section.color
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let subtitle = subtitle {
                Text(subtitle.uppercased())
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.9))
                    .tracking(1.5)
            }

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.spacingM)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .shadow(color: color.opacity(0.3), radius: 4, y: 2)
        )
        .padding(.horizontal, .spacingM)
    }
}

// MARK: - Unit Divider (like treasure chest in Duolingo)
struct UnitDivider: View {
    let unitNumber: Int
    let sport: Sport

    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.backgroundTertiary)
                .frame(height: 2)

            ZStack {
                Circle()
                    .fill(sport.accentColor.opacity(0.15))
                    .frame(width: 44, height: 44)

                Text("\(unitNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(sport.accentColor)
            }

            Rectangle()
                .fill(Color.backgroundTertiary)
                .frame(height: 2)
        }
        .padding(.horizontal, .spacingL)
        .padding(.vertical, .spacingM)
    }
}

// MARK: - Visible Lesson Tracking
private struct VisibleLesson: Equatable {
    let index: Int
    let orderIndex: Int
    let frame: CGRect
}

private struct VisibleLessonPreferenceKey: PreferenceKey {
    static var defaultValue: [VisibleLesson] = []

    static func reduce(value: inout [VisibleLesson], nextValue: () -> [VisibleLesson]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - Preview
#Preview("Lesson Path with Yard Line") {
    @Previewable @State var selectedIndex: Int? = nil
    @Previewable @State var scrollProgress: CGFloat = 0.5

    VStack {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    SectionHeader(
                        title: "The Field",
                        subtitle: "Section 1, Unit 1",
                        sport: .football
                    )

                    LessonPathView(
                        lessons: Lesson.mockLessons,
                        completions: [
                            Lesson.footballBasicsLesson1.id: 2,
                            Lesson.footballBasicsLesson2.id: 1,
                            Lesson.footballBasicsLesson3.id: 0
                        ],
                        sport: .football,
                        onLessonStart: { lesson in
                            print("Tapped lesson: \(lesson.title)")
                        },
                        selectedLessonIndex: $selectedIndex,
                        scrollProgress: scrollProgress
                    )

                    UnitDivider(unitNumber: 2, sport: .football)

                    SectionHeader(
                        title: "Scoring",
                        subtitle: "Section 1, Unit 2",
                        sport: .football
                    )
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }

        // Scroll progress slider for testing
        VStack {
            Slider(value: $scrollProgress, in: 0...1)
            Text("Progress: \(Int(scrollProgress * 100))%")
                .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

#Preview("Different States") {
    @Previewable @State var selectedIndex: Int? = nil

    ScrollView {
        VStack(spacing: 40) {
            Text("Lesson Path States")
                .font(.headline)

            LessonPathView(
                lessons: [
                    Lesson.footballBasicsLesson1,
                    Lesson.footballBasicsLesson2,
                    Lesson(
                        id: UUID(),
                        moduleId: Module.footballBasics.id,
                        title: "Locked Lesson",
                        description: "This is locked",
                        orderIndex: 3,
                        estimatedMinutes: 5,
                        xpAward: 50,
                        isLocked: true
                    ),
                    Lesson(
                        id: UUID(),
                        moduleId: Module.footballBasics.id,
                        title: "Another Locked",
                        description: "Also locked",
                        orderIndex: 4,
                        estimatedMinutes: 5,
                        xpAward: 50,
                        isLocked: true
                    )
                ],
                completions: [
                    Lesson.footballBasicsLesson1.id: 3,  // Complete
                    Lesson.footballBasicsLesson2.id: 1   // In progress
                ],
                sport: .football,
                onLessonStart: { _ in },
                selectedLessonIndex: $selectedIndex,
                scrollProgress: 1.0  // Show full path for states preview
            )
        }
        .padding()
    }
}
