//
//  LessonStartPopup.swift
//  Ola Ball
//
//  Duolingo-style popup that appears when tapping a lesson node
//

import SwiftUI

struct LessonStartPopup: View {
    let lesson: Lesson
    let completionCount: Int        // How many times user has completed this lesson
    let sport: Sport
    let triangleOffsetX: CGFloat    // How far the triangle should be offset from center (to point at node)
    var isLocked: Bool = false      // Whether the lesson is locked/unavailable
    var showAbove: Bool = false     // If true, popup appears above node with triangle pointing down
    let onStart: () -> Void
    let onDismiss: () -> Void

    // Animation state
    @State private var isAppearing = false

    /// Whether the lesson has been fully completed (all required completions done)
    private var isFullyCompleted: Bool {
        completionCount >= lesson.requiredCompletions
    }

    /// The next attempt number (1-based). If completed 0 times, next is attempt 1.
    /// If completed 1 time, next is attempt 2, etc.
    private var nextAttemptNumber: Int {
        completionCount + 1
    }

    /// Background color for the popup
    private var backgroundColor: Color {
        isLocked ? Color.backgroundTertiary : sport.accentColor
    }

    var body: some View {
        // Main popup content with triangle overlay
        VStack(spacing: 12) {
            // Lesson title
            Text(lesson.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(isLocked ? .white : .white)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            // Show locked message, "Review" if fully completed, otherwise show progress
            if isLocked {
                Text("Complete the previous lesson to unlock!")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            } else if isFullyCompleted {
                Text("Review")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            } else {
                // Completion progress indicator (e.g., "Lesson 2 of 5" means this is attempt 2 of 5 required)
                Text("Lesson \(nextAttemptNumber) of \(lesson.requiredCompletions)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
            }

            // Button - locked state or start button
            if isLocked {
                // Locked button (non-interactive)
                Text("LOCKED")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.backgroundSecondary)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.backgroundTertiary, lineWidth: 1)
                    )
            } else {
                // Start button
                Button(action: onStart) {
                    Text("START +\(lesson.xpAward) XP")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(sport.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(sport.accentColor.opacity(0.2), lineWidth: 1)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .shadow(color: backgroundColor.opacity(0.4), radius: 8, y: showAbove ? -4 : 4)
        )
        // Triangle positioned at top or bottom depending on showAbove
        .overlay(alignment: showAbove ? .bottom : .top) {
            Triangle()
                .fill(backgroundColor)
                .frame(width: 24, height: 12)
                .rotationEffect(showAbove ? .degrees(180) : .degrees(0))
                .offset(x: triangleOffsetX, y: showAbove ? 11 : -11)
        }
        .scaleEffect(isAppearing ? 1 : 0.8)
        .opacity(isAppearing ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                isAppearing = true
            }
        }
        .onTapGesture {
            // Dismiss when tapping outside the button area
        }
    }
}

// MARK: - Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Popup Overlay Modifier
struct LessonStartPopupOverlay: ViewModifier {
    let lesson: Lesson?
    let completionCount: Int
    let sport: Sport
    let triangleOffsetX: CGFloat
    let onStart: () -> Void
    let onDismiss: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let lesson = lesson {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            onDismiss()
                        }
                        .transition(.opacity)

                    LessonStartPopup(
                        lesson: lesson,
                        completionCount: completionCount,
                        sport: sport,
                        triangleOffsetX: triangleOffsetX,
                        onStart: onStart,
                        onDismiss: onDismiss
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: lesson != nil)
    }
}

extension View {
    func lessonStartPopup(
        lesson: Lesson?,
        completionCount: Int,
        sport: Sport,
        triangleOffsetX: CGFloat = 0,
        onStart: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) -> some View {
        modifier(LessonStartPopupOverlay(
            lesson: lesson,
            completionCount: completionCount,
            sport: sport,
            triangleOffsetX: triangleOffsetX,
            onStart: onStart,
            onDismiss: onDismiss
        ))
    }
}

// MARK: - Preview
#Preview("Lesson Start Popup") {
    ZStack {
        Color.backgroundSecondary
            .ignoresSafeArea()

        VStack {
            Spacer()

            // Mock lesson node (1 completion out of 5)
            LessonProgressRing(
                completedSegments: 1,
                totalSegments: 5,
                isLocked: false,
                icon: "star.fill",
                accentColor: .footballAccent
            )

            // Popup below the node - shows "Lesson 2 of 5" (next attempt is #2)
            LessonStartPopup(
                lesson: Lesson.theField1,
                completionCount: 1,  // User has completed 1 time, so next is attempt 2
                sport: .football,
                triangleOffsetX: 0,  // Centered
                onStart: { print("Start tapped") },
                onDismiss: { print("Dismissed") }
            )

            Spacer()
            Spacer()
        }
    }
}

#Preview("Different Completion States") {
    ScrollView {
        VStack(spacing: 40) {
            // Never completed - shows "Lesson 1 of 5"
            VStack {
                Text("0 completions → Lesson 1 of 5")
                    .font(.caption)
                LessonStartPopup(
                    lesson: Lesson.theField1,
                    completionCount: 0,
                    sport: .football,
                    triangleOffsetX: 0,
                    onStart: {},
                    onDismiss: {}
                )
            }

            // Completed twice - shows "Lesson 3 of 5"
            VStack {
                Text("2 completions → Lesson 3 of 5")
                    .font(.caption)
                LessonStartPopup(
                    lesson: Lesson.theField1,
                    completionCount: 2,
                    sport: .football,
                    triangleOffsetX: 60, // Offset to the right
                    onStart: {},
                    onDismiss: {}
                )
            }

            // Almost done - shows "Lesson 5 of 5"
            VStack {
                Text("4 completions → Lesson 5 of 5")
                    .font(.caption)
                LessonStartPopup(
                    lesson: Lesson.theField1,
                    completionCount: 4,
                    sport: .football,
                    triangleOffsetX: -60, // Offset to the left
                    onStart: {},
                    onDismiss: {}
                )
            }

            // Fully completed - shows "Review"
            VStack {
                Text("5+ completions → Review")
                    .font(.caption)
                LessonStartPopup(
                    lesson: Lesson.theField1,
                    completionCount: 5,
                    sport: .football,
                    triangleOffsetX: 0,
                    onStart: {},
                    onDismiss: {}
                )
            }

            // Locked state
            VStack {
                Text("Locked lesson")
                    .font(.caption)
                LessonStartPopup(
                    lesson: Lesson.theField1,
                    completionCount: 0,
                    sport: .football,
                    triangleOffsetX: 0,
                    isLocked: true,
                    onStart: {},
                    onDismiss: {}
                )
            }
        }
        .padding()
    }
}
