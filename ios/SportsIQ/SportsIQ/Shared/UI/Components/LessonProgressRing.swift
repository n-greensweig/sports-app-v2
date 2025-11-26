//
//  LessonProgressRing.swift
//  Ola Ball
//
//  A Duolingo-style circular lesson button with progress ring segments
//

import SwiftUI

struct LessonProgressRing: View {
    let completedSegments: Int       // How many segments are filled (0 to totalSegments)
    let totalSegments: Int           // Total segments needed (typically 3)
    let isLocked: Bool               // Whether the lesson is locked
    let icon: String                 // SF Symbol name for the center icon
    var accentColor: Color = .footballAccent
    var size: CGFloat = 64           // Total size of the ring

    // Ring configuration
    private let ringWidth: CGFloat = 6
    private let ringPadding: CGFloat = 4 // Space between inner circle and ring segments
    private let gapAngle: Double = 12 // Gap between segments in degrees

    // Computed properties for visual states
    private var isCompleted: Bool { completedSegments >= totalSegments }
    private var isInProgress: Bool { completedSegments > 0 && !isCompleted }
    private var isAvailable: Bool { !isLocked && completedSegments == 0 }

    var body: some View {
        ZStack {
            // Outer progress ring segments
            progressRing

            // Main circle button
            mainCircle

            // Center icon
            centerIconView
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: completedSegments)
        .animation(.easeInOut(duration: 0.2), value: isLocked)
    }

    // MARK: - Progress Ring
    private var progressRing: some View {
        ZStack {
            // Show all segments - unfilled ones are grayed out, filled ones are colored
            ForEach(0..<totalSegments, id: \.self) { index in
                SegmentArc(
                    segmentIndex: index,
                    totalSegments: totalSegments,
                    gapAngle: gapAngle,
                    isFilled: index < completedSegments
                )
                .stroke(
                    index < completedSegments ? segmentColor : unfilledSegmentColor,
                    style: StrokeStyle(
                        lineWidth: ringWidth,
                        lineCap: .round
                    )
                )
                .frame(width: size + ringPadding * 2 + ringWidth * 2, height: size + ringPadding * 2 + ringWidth * 2)
            }
        }
    }

    // MARK: - Main Circle
    private var mainCircle: some View {
        Circle()
            .fill(circleGradient)
            .frame(width: size, height: size)
            .shadow(color: shadowColor, radius: isLocked ? 0 : 4, y: isLocked ? 0 : 3)
            .overlay(
                Circle()
                    .stroke(circleBorderColor, lineWidth: 2)
            )
    }

    // MARK: - Center Icon
    private var centerIconView: some View {
        Group {
            if isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: size * 0.35, weight: .bold))
                    .foregroundStyle(Color.textTertiary)
            } else if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundStyle(.white)
            } else {
                Image(systemName: icon)
                    .font(.system(size: size * 0.35, weight: .semibold))
                    .foregroundStyle(iconColor)
            }
        }
    }

    // MARK: - Colors
    private var segmentColor: Color {
        if isCompleted {
            return accentColor.opacity(0.8)
        }
        return accentColor
    }

    private var unfilledSegmentColor: Color {
        if isLocked {
            return Color.backgroundTertiary.opacity(0.3)
        }
        return Color.backgroundTertiary.opacity(0.5)
    }

    private var circleGradient: LinearGradient {
        if isLocked {
            // Locked - dark gray
            return LinearGradient(
                colors: [Color.backgroundTertiary, Color.backgroundTertiary.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else if isCompleted {
            // Fully completed - bright accent color
            return LinearGradient(
                colors: [accentColor, accentColor.opacity(0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else if isInProgress {
            // In progress (1+ completions but not done) - accent color
            return LinearGradient(
                colors: [accentColor.opacity(0.9), accentColor.opacity(0.75)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            // Available but NOT started (0 completions) - GRAY like Duolingo
            return LinearGradient(
                colors: [Color.backgroundTertiary.opacity(0.9), Color.backgroundTertiary.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private var circleBorderColor: Color {
        if isLocked || isAvailable {
            return Color.backgroundTertiary.opacity(0.5)
        } else if isCompleted {
            return accentColor.opacity(0.5)
        }
        return accentColor.opacity(0.3)
    }

    private var shadowColor: Color {
        if isLocked || isAvailable {
            return Color.black.opacity(0.1)
        }
        return accentColor.opacity(0.4)
    }

    private var iconColor: Color {
        if isLocked {
            return .textTertiary
        } else if isAvailable {
            // Available but not started - gray icon
            return .textSecondary
        }
        return .white
    }
}

// MARK: - Segment Arc Shape
struct SegmentArc: Shape {
    let segmentIndex: Int
    let totalSegments: Int
    let gapAngle: Double
    let isFilled: Bool

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        // Calculate arc angles
        let totalGaps = Double(totalSegments) * gapAngle
        let availableAngle = 360.0 - totalGaps
        let segmentAngle = availableAngle / Double(totalSegments)

        // Start from top (-90 degrees) and go clockwise
        let startOffset = -90.0
        let segmentStart = startOffset + Double(segmentIndex) * (segmentAngle + gapAngle) + (gapAngle / 2)
        let segmentEnd = segmentStart + segmentAngle

        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: Angle(degrees: segmentStart),
            endAngle: Angle(degrees: segmentEnd),
            clockwise: false
        )

        return path
    }
}

// MARK: - Lesson Node (Tappable button wrapper)
struct LessonNode: View {
    let lesson: Lesson
    let completionCount: Int
    let sport: Sport
    let lessonIndex: Int
    let action: () -> Void

    // Icons to cycle through for different lessons
    private static let lessonIcons = [
        "star.fill",
        "book.fill",
        "lightbulb.fill",
        "graduationcap.fill",
        "trophy.fill",
        "flag.fill",
        "target",
        "bolt.fill"
    ]

    private var lessonIcon: String {
        LessonNode.lessonIcons[lessonIndex % LessonNode.lessonIcons.count]
    }

    var body: some View {
        Button(action: action) {
            LessonProgressRing(
                completedSegments: completionCount,
                totalSegments: lesson.requiredCompletions,
                isLocked: lesson.isLocked,
                icon: lessonIcon,
                accentColor: sport.accentColor,
                size: 64
            )
        }
        .buttonStyle(LessonButtonStyle())
        .disabled(lesson.isLocked)
    }
}

// MARK: - Lesson Button Style
struct LessonButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview("Lesson Progress Ring States") {
    ScrollView {
        VStack(spacing: 40) {
            Text("Duolingo-Style Lesson Nodes")
                .font(.headline)

            // Row 1: Progress states
            HStack(spacing: 32) {
                VStack(spacing: 8) {
                    LessonProgressRing(
                        completedSegments: 0,
                        totalSegments: 3,
                        isLocked: true,
                        icon: "lock.fill",
                        accentColor: .footballAccent
                    )
                    Text("Locked")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    LessonProgressRing(
                        completedSegments: 0,
                        totalSegments: 3,
                        isLocked: false,
                        icon: "star.fill",
                        accentColor: .footballAccent
                    )
                    Text("Available")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    LessonProgressRing(
                        completedSegments: 1,
                        totalSegments: 3,
                        isLocked: false,
                        icon: "book.fill",
                        accentColor: .footballAccent
                    )
                    Text("1/3")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Row 2: More progress
            HStack(spacing: 32) {
                VStack(spacing: 8) {
                    LessonProgressRing(
                        completedSegments: 2,
                        totalSegments: 3,
                        isLocked: false,
                        icon: "lightbulb.fill",
                        accentColor: .footballAccent
                    )
                    Text("2/3")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 8) {
                    LessonProgressRing(
                        completedSegments: 3,
                        totalSegments: 3,
                        isLocked: false,
                        icon: "trophy.fill",
                        accentColor: .footballAccent
                    )
                    Text("Complete!")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            Text("Different Sports")
                .font(.headline)

            HStack(spacing: 24) {
                LessonProgressRing(
                    completedSegments: 2,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "football.fill",
                    accentColor: .footballAccent
                )

                LessonProgressRing(
                    completedSegments: 1,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "basketball.fill",
                    accentColor: .basketballAccent
                )

                LessonProgressRing(
                    completedSegments: 3,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "baseball.fill",
                    accentColor: .baseballAccent
                )
            }

            Divider()

            Text("Sizes")
                .font(.headline)

            HStack(spacing: 24) {
                LessonProgressRing(
                    completedSegments: 2,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "star.fill",
                    size: 48
                )

                LessonProgressRing(
                    completedSegments: 2,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "star.fill",
                    size: 64
                )

                LessonProgressRing(
                    completedSegments: 2,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "star.fill",
                    size: 80
                )
            }
        }
        .padding()
    }
}
