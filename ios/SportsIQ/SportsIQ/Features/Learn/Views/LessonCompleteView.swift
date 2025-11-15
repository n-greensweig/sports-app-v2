//
//  LessonCompleteView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct LessonCompleteView: View {
    let lesson: Lesson
    let sport: Sport
    let correctAnswers: Int
    let totalQuestions: Int
    let xpEarned: Int
    let onContinue: () -> Void

    @State private var showConfetti = false
    @State private var xpAnimationValue: Double = 0
    @State private var scaleEffect: CGFloat = 0.5

    private var accuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalQuestions)
    }

    private var isPerfectScore: Bool {
        correctAnswers == totalQuestions
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .spacingXL) {
                Spacer()
                    .frame(height: .spacingL)

                // Trophy/Success Icon
                ZStack {
                    Circle()
                        .fill(sport.accentColor.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Image(systemName: isPerfectScore ? "trophy.fill" : "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(sport.accentColor)
                        .scaleEffect(scaleEffect)
                }

                // Title
                VStack(spacing: .spacingS) {
                    Text(isPerfectScore ? "Perfect!" : "Lesson Complete!")
                        .font(.heading1)
                        .foregroundStyle(Color.textPrimary)

                    Text(lesson.title)
                        .font(.heading3)
                        .foregroundStyle(Color.textSecondary)
                }

                // Stats Card
                VStack(spacing: .spacingM) {
                    // Score
                    HStack {
                        Text("Score")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)

                        Spacer()

                        Text("\(correctAnswers)/\(totalQuestions)")
                            .font(.heading3)
                            .foregroundStyle(Color.textPrimary)
                    }

                    Divider()

                    // Accuracy
                    HStack {
                        Text("Accuracy")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)

                        Spacer()

                        Text("\(Int(accuracy * 100))%")
                            .font(.heading3)
                            .foregroundStyle(accuracy >= 0.8 ? Color.correct : Color.warning)
                    }

                    Divider()

                    // XP Earned
                    HStack {
                        HStack(spacing: .spacingS) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.warning)
                            Text("XP Earned")
                                .font(.body)
                                .foregroundStyle(Color.textSecondary)
                        }

                        Spacer()

                        Text("+\(Int(xpAnimationValue))")
                            .font(.heading2)
                            .foregroundStyle(Color.warning)
                            .fontWeight(.bold)
                    }
                }
                .padding(.spacingL)
                .background(Color.backgroundSecondary)
                .cornerRadius(.radiusL)

                // Encouragement Message
                VStack(spacing: .spacingS) {
                    if isPerfectScore {
                        Text("Outstanding work!")
                            .font(.bodyLarge)
                            .foregroundStyle(sport.accentColor)
                            .fontWeight(.semibold)
                        Text("You've mastered this lesson!")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                    } else if accuracy >= 0.8 {
                        Text("Great job!")
                            .font(.bodyLarge)
                            .foregroundStyle(sport.accentColor)
                            .fontWeight(.semibold)
                        Text("You're making excellent progress")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                    } else if accuracy >= 0.6 {
                        Text("Good effort!")
                            .font(.bodyLarge)
                            .foregroundStyle(sport.accentColor)
                            .fontWeight(.semibold)
                        Text("Keep practicing to improve your score")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                    } else {
                        Text("Keep learning!")
                            .font(.bodyLarge)
                            .foregroundStyle(sport.accentColor)
                            .fontWeight(.semibold)
                        Text("Review the lesson to boost your understanding")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                .multilineTextAlignment(.center)

                Spacer()

                // Continue Button
                PrimaryButton(
                    title: "Continue",
                    action: onContinue,
                    color: sport.accentColor
                )
            }
            .padding(.spacingM)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            animateCompletion()
        }
    }

    private func animateCompletion() {
        // Scale animation for trophy
        withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
            scaleEffect = 1.0
        }

        // XP counter animation
        withAnimation(.easeOut(duration: 1.5)) {
            xpAnimationValue = Double(xpEarned)
        }

        // Confetti for perfect score
        if isPerfectScore {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
            }
        }
    }
}

#Preview("Perfect Score") {
    NavigationStack {
        LessonCompleteView(
            lesson: .footballBasicsLesson1,
            sport: .football,
            correctAnswers: 8,
            totalQuestions: 8,
            xpEarned: 120,
            onContinue: {}
        )
    }
}

#Preview("Good Score") {
    NavigationStack {
        LessonCompleteView(
            lesson: .footballBasicsLesson1,
            sport: .football,
            correctAnswers: 6,
            totalQuestions: 8,
            xpEarned: 80,
            onContinue: {}
        )
    }
}
