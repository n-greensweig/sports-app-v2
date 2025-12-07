//
//  TestOutResultView.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import SwiftUI

/// Results screen shown after completing a test-out assessment
/// Shows pass/fail status, score, and next steps
struct TestOutResultView: View {
    let score: Int
    let totalQuestions: Int
    let passingScore: Int
    let passed: Bool
    let moduleName: String
    let nextModuleName: String
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var triggerScreenShake = false

    var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int(round(Double(score) / Double(totalQuestions) * 100))
    }

    var xpEarned: Int {
        passed ? score * 10 : 0
    }

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            // Celebration effects for passing
            if passed {
                BurstConfettiView(intensity: .high)
                    .ignoresSafeArea()
            }

            VStack(spacing: .spacingXL) {
                Spacer()

                // Result Icon
                ZStack {
                    Circle()
                        .fill((passed ? Color.correct : Color.incorrect).opacity(0.1))
                        .frame(width: 120, height: 120)

                    Image(systemName: passed ? "checkmark.seal.fill" : "xmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(passed ? Color.correct : Color.incorrect)
                }
                .scaleEffect(showContent ? 1 : 0.5)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContent)

                // Result Title
                VStack(spacing: .spacingS) {
                    Text(passed ? "You Passed!" : "Not Quite...")
                        .font(.heading1)
                        .foregroundStyle(Color.textPrimary)

                    Text(passed ? "\(nextModuleName) Module Unlocked!" : "Keep practicing to improve")
                        .font(.heading3)
                        .foregroundStyle(Color.textSecondary)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut.delay(0.2), value: showContent)

                // Score Display
                VStack(spacing: .spacingM) {
                    // Large score
                    HStack(alignment: .firstTextBaseline, spacing: .spacingXS) {
                        Text("\(score)")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundStyle(passed ? Color.correct : Color.incorrect)
                        Text("/\(totalQuestions)")
                            .font(.heading1)
                            .foregroundStyle(Color.textSecondary)
                    }

                    // Progress to passing
                    VStack(spacing: .spacingXS) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: .radiusS)
                                    .fill(Color.backgroundSecondary)
                                    .frame(height: 12)

                                // Passing threshold marker
                                let passingPosition = CGFloat(passingScore) / CGFloat(totalQuestions) * geo.size.width
                                Rectangle()
                                    .fill(Color.textTertiary)
                                    .frame(width: 2, height: 20)
                                    .offset(x: passingPosition - 1)

                                // Score fill
                                RoundedRectangle(cornerRadius: .radiusS)
                                    .fill(passed ? Color.correct : Color.incorrect)
                                    .frame(width: CGFloat(score) / CGFloat(totalQuestions) * geo.size.width, height: 12)
                            }
                        }
                        .frame(height: 20)

                        HStack {
                            Text("0")
                                .font(.caption2)
                                .foregroundStyle(Color.textTertiary)
                            Spacer()
                            Text("\(passingScore) to pass")
                                .font(.caption2)
                                .foregroundStyle(Color.textSecondary)
                            Spacer()
                            Text("\(totalQuestions)")
                                .font(.caption2)
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                    .padding(.horizontal, .spacingL)
                }
                .padding(.spacingM)
                .background(Color.backgroundSecondary.opacity(0.5))
                .cornerRadius(.radiusL)
                .padding(.horizontal, .spacingL)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut.delay(0.4), value: showContent)

                // XP or encouragement
                if passed {
                    HStack(spacing: .spacingS) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.warning)
                        Text("+\(xpEarned) XP earned!")
                            .font(.body.bold())
                            .foregroundStyle(Color.textPrimary)
                    }
                    .padding(.vertical, .spacingS)
                    .padding(.horizontal, .spacingM)
                    .background(Color.warning.opacity(0.15))
                    .cornerRadius(.radiusM)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut.delay(0.5), value: showContent)
                } else {
                    VStack(spacing: .spacingS) {
                        Text("You needed \(passingScore - score) more correct answers")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)

                        Text("Complete lessons to learn the material, then try again!")
                            .font(.caption)
                            .foregroundStyle(Color.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, .spacingL)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut.delay(0.5), value: showContent)
                }

                Spacer()

                PrimaryButton(
                    title: passed ? "Continue to \(nextModuleName)" : "Back to Lessons",
                    action: onDismiss,
                    color: passed ? .correct : .brandPrimary
                )
                .padding(.horizontal, .spacingL)
                .padding(.bottom, .spacingXL)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut.delay(0.6), value: showContent)
            }
        }
        .screenShake(trigger: $triggerScreenShake, intensity: passed ? 12 : 0)
        .onAppear {
            showContent = true

            if passed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    triggerScreenShake = true
                    HapticManager.shared.playPerfectScorePattern()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Passed") {
    TestOutResultView(
        score: 22,
        totalQuestions: 25,
        passingScore: 20,
        passed: true,
        moduleName: "Rookie",
        nextModuleName: "Veteran",
        onDismiss: {}
    )
}

#Preview("Failed") {
    TestOutResultView(
        score: 15,
        totalQuestions: 25,
        passingScore: 20,
        passed: false,
        moduleName: "Rookie",
        nextModuleName: "Veteran",
        onDismiss: {}
    )
}
