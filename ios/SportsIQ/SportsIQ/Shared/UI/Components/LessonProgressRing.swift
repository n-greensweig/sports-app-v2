//
//  LessonProgressRing.swift
//  Ola Ball
//
//  A circular progress indicator showing lesson completion progress
//  with segmented rings (⅓, ⅔, full based on completions)
//

import SwiftUI

struct LessonProgressRing: View {
    let completedSegments: Int       // How many segments are filled (0 to totalSegments)
    let totalSegments: Int           // Total segments needed (typically 3)
    let isLocked: Bool               // Whether the lesson is locked
    let icon: String                 // SF Symbol name for the center icon
    var accentColor: Color = .footballAccent
    var size: CGFloat = 56           // Total size of the ring

    // Ring configuration
    private let ringWidth: CGFloat = 5
    private let gapAngle: Double = 8 // Gap between segments in degrees

    var body: some View {
        ZStack {
            // Background circle (unfilled ring)
            Circle()
                .stroke(
                    isLocked ? Color.backgroundTertiary : Color.backgroundTertiary,
                    lineWidth: ringWidth
                )
                .frame(width: size, height: size)

            // Completed segments
            if !isLocked {
                ForEach(0..<totalSegments, id: \.self) { index in
                    SegmentArc(
                        segmentIndex: index,
                        totalSegments: totalSegments,
                        gapAngle: gapAngle,
                        isFilled: index < completedSegments
                    )
                    .stroke(
                        index < completedSegments ? accentColor : Color.clear,
                        style: StrokeStyle(
                            lineWidth: ringWidth,
                            lineCap: .round
                        )
                    )
                    .frame(width: size, height: size)
                }
            }

            // Center icon
            Image(systemName: centerIcon)
                .font(.system(size: size * 0.35, weight: .semibold))
                .foregroundStyle(iconColor)
        }
        .animation(.easeInOut(duration: 0.3), value: completedSegments)
    }

    private var centerIcon: String {
        if isLocked {
            return "lock.fill"
        } else if completedSegments >= totalSegments {
            return "checkmark"
        } else {
            return icon
        }
    }

    private var iconColor: Color {
        if isLocked {
            return .textTertiary
        } else if completedSegments >= totalSegments {
            return accentColor
        } else if completedSegments > 0 {
            return accentColor.opacity(0.8)
        } else {
            return .textSecondary
        }
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

// MARK: - Preview
#Preview("Progress Ring States") {
    VStack(spacing: 32) {
        Text("Lesson Progress Ring States")
            .font(.headline)

        HStack(spacing: 24) {
            VStack {
                LessonProgressRing(
                    completedSegments: 0,
                    totalSegments: 3,
                    isLocked: true,
                    icon: "football.fill"
                )
                Text("Locked")
                    .font(.caption)
            }

            VStack {
                LessonProgressRing(
                    completedSegments: 0,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "football.fill"
                )
                Text("0/3")
                    .font(.caption)
            }

            VStack {
                LessonProgressRing(
                    completedSegments: 1,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "football.fill"
                )
                Text("1/3")
                    .font(.caption)
            }

            VStack {
                LessonProgressRing(
                    completedSegments: 2,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "football.fill"
                )
                Text("2/3")
                    .font(.caption)
            }

            VStack {
                LessonProgressRing(
                    completedSegments: 3,
                    totalSegments: 3,
                    isLocked: false,
                    icon: "football.fill"
                )
                Text("Mastered")
                    .font(.caption)
            }
        }

        Divider()

        Text("Different Icons")
            .font(.headline)

        HStack(spacing: 24) {
            LessonProgressRing(
                completedSegments: 2,
                totalSegments: 3,
                isLocked: false,
                icon: "star.fill",
                accentColor: .footballAccent
            )

            LessonProgressRing(
                completedSegments: 1,
                totalSegments: 3,
                isLocked: false,
                icon: "scalemass.fill",
                accentColor: .basketballAccent
            )

            LessonProgressRing(
                completedSegments: 3,
                totalSegments: 3,
                isLocked: false,
                icon: "figure.american.football",
                accentColor: .baseballAccent
            )

            LessonProgressRing(
                completedSegments: 0,
                totalSegments: 3,
                isLocked: false,
                icon: "helmet.fill",
                accentColor: .soccerAccent,
                size: 72
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
                icon: "football.fill",
                size: 44
            )

            LessonProgressRing(
                completedSegments: 2,
                totalSegments: 3,
                isLocked: false,
                icon: "football.fill",
                size: 56
            )

            LessonProgressRing(
                completedSegments: 2,
                totalSegments: 3,
                isLocked: false,
                icon: "football.fill",
                size: 72
            )
        }
    }
    .padding()
}
