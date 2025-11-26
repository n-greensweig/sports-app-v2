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

    // State for popup
    @State private var selectedLessonIndex: Int? = nil

    // Path configuration
    private let nodeSize: CGFloat = 64
    private let verticalSpacing: CGFloat = 24
    private let horizontalOffset: CGFloat = 80  // How far nodes swing left/right

    /// The index of the current lesson (first unlocked, incomplete lesson)
    private var currentLessonIndex: Int? {
        lessons.firstIndex { lesson in
            !lesson.isLocked && (completions[lesson.id] ?? 0) < lesson.requiredCompletions
        }
    }

    var body: some View {
        VStack(spacing: verticalSpacing) {
            ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                lessonRow(lesson: lesson, index: index)
            }
        }
        .padding(.vertical, .spacingM)
    }

    // MARK: - Lesson Row
    @ViewBuilder
    private func lessonRow(lesson: Lesson, index: Int) -> some View {
        let position = pathPosition(for: index)
        let completionCount = completions[lesson.id] ?? 0
        let isSelected = selectedLessonIndex == index
        let nodeOffset = horizontalOffset(for: position)

        // Full-width row container - popup overlay is attached here for correct positioning
        ZStack {
            // Node content positioned within the full-width row
            VStack(spacing: 8) {
                // Lesson node button
                Button {
                    if !lesson.isLocked {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            if selectedLessonIndex == index {
                                selectedLessonIndex = nil
                            } else {
                                selectedLessonIndex = index
                            }
                        }
                    }
                } label: {
                    LessonProgressRing(
                        completedSegments: completionCount,
                        totalSegments: lesson.requiredCompletions,
                        isLocked: lesson.isLocked,
                        icon: lessonIcon(for: index),
                        accentColor: sport.accentColor,
                        size: nodeSize,
                        isCurrentLesson: index == currentLessonIndex
                    )
                }
                .buttonStyle(LessonButtonStyle())
                .disabled(lesson.isLocked)

                // Lesson code badge (optional)
                if let code = lesson.code {
                    Text(code)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(lesson.isLocked ? Color.textTertiary : sport.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(lesson.isLocked ? Color.backgroundTertiary : sport.accentColor.opacity(0.15))
                        )
                }
            }
            .offset(x: nodeOffset)
        }
        .frame(maxWidth: .infinity)
        // Popup appears as overlay on the full-width row
        .overlay(alignment: .top) {
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
                // Position popup below the node
                // nodeOffset positions the node from center, so add that to vertical offset calculation
                .offset(y: nodeSize + 24)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8, anchor: .top).combined(with: .opacity),
                    removal: .scale(scale: 0.9, anchor: .top).combined(with: .opacity)
                ))
            }
        }
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

    // MARK: - Lesson Icons
    private static let lessonIcons = [
        "star.fill",
        "book.fill",
        "lightbulb.fill",
        "graduationcap.fill",
        "trophy.fill",
        "flag.fill",
        "target",
        "bolt.fill",
        "flame.fill",
        "sparkles"
    ]

    private func lessonIcon(for index: Int) -> String {
        Self.lessonIcons[index % Self.lessonIcons.count]
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let subtitle: String?
    let sport: Sport

    init(title: String, subtitle: String? = nil, sport: Sport) {
        self.title = title
        self.subtitle = subtitle
        self.sport = sport
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
                .fill(sport.accentColor)
                .shadow(color: sport.accentColor.opacity(0.3), radius: 4, y: 2)
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

// MARK: - Preview
#Preview("Lesson Path") {
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
                    sport: .football
                ) { lesson in
                    print("Tapped lesson: \(lesson.title)")
                }

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
}

#Preview("Different States") {
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
                sport: .football
            ) { _ in }
        }
        .padding()
    }
}
