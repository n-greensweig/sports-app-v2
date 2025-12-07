//
//  TestOutPromptView.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import SwiftUI

/// Sheet view shown when user can take a test-out for a module
/// Displays test info, eligibility status, and options to start or skip
struct TestOutPromptView: View {
    let testOut: TestOut
    let module: Module
    let eligibility: TestOutEligibility
    let onStartTest: () -> Void
    let onSkip: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: .spacingL) {
                // Header Icon
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.1))
                        .frame(width: 80, height: 80)

                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(Color.brandPrimary)
                }
                .padding(.top, .spacingXL)

                // Title
                VStack(spacing: .spacingS) {
                    Text("Test Out of \(module.title)")
                        .font(.heading2)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Skip ahead by proving your knowledge")
                        .font(.body)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }

                // Test Info Card
                VStack(spacing: .spacingM) {
                    InfoRow(icon: "list.number", title: "Questions", value: "\(testOut.totalQuestions)")
                    Divider()
                    InfoRow(icon: "checkmark.circle", title: "To Pass", value: "\(testOut.passingScore)/\(testOut.totalQuestions) correct")
                    Divider()
                    InfoRow(icon: "clock", title: "Attempts", value: attemptsText)
                }
                .padding(.spacingM)
                .background(Color.backgroundSecondary)
                .cornerRadius(.radiusL)
                .padding(.horizontal, .spacingL)

                // Eligibility Status
                if !eligibility.canAttempt && !eligibility.hasPassed {
                    cooldownCard
                }

                if eligibility.hasPassed {
                    passedCard
                }

                Spacer()

                // Action Buttons
                VStack(spacing: .spacingM) {
                    if eligibility.canAttempt {
                        PrimaryButton(
                            title: "Start Test",
                            action: {
                                dismiss()
                                onStartTest()
                            },
                            color: .brandPrimary
                        )
                    } else if eligibility.hasPassed {
                        PrimaryButton(
                            title: "Continue Learning",
                            action: {
                                dismiss()
                                onSkip()
                            },
                            color: .brandPrimary
                        )
                    }

                    if eligibility.canAttempt {
                        Button {
                            dismiss()
                            onSkip()
                        } label: {
                            Text("Skip for now")
                                .font(.body)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, .spacingL)
                .padding(.bottom, .spacingXL)
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.textTertiary)
                    }
                }
            }
        }
    }

    private var attemptsText: String {
        if eligibility.hasPassed {
            return "Passed!"
        }
        if eligibility.canAttempt {
            return "\(eligibility.attemptsRemaining) remaining today"
        }
        return "On cooldown"
    }

    private var cooldownCard: some View {
        HStack(spacing: .spacingM) {
            Image(systemName: "clock.badge.exclamationmark")
                .font(.title2)
                .foregroundStyle(Color.warning)

            VStack(alignment: .leading, spacing: .spacingXS) {
                Text("Cooldown Active")
                    .font(.body.bold())
                    .foregroundStyle(Color.textPrimary)

                Text(eligibility.statusMessage)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()
        }
        .padding(.spacingM)
        .background(Color.warning.opacity(0.1))
        .cornerRadius(.radiusM)
        .padding(.horizontal, .spacingL)
    }

    private var passedCard: some View {
        HStack(spacing: .spacingM) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title2)
                .foregroundStyle(Color.correct)

            VStack(alignment: .leading, spacing: .spacingXS) {
                Text("Already Passed!")
                    .font(.body.bold())
                    .foregroundStyle(Color.textPrimary)

                Text("You've unlocked the next module")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()
        }
        .padding(.spacingM)
        .background(Color.correct.opacity(0.1))
        .cornerRadius(.radiusM)
        .padding(.horizontal, .spacingL)
    }
}

// MARK: - Info Row

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(Color.textSecondary)

            Text(title)
                .font(.body)
                .foregroundStyle(Color.textSecondary)

            Spacer()

            Text(value)
                .font(.body.bold())
                .foregroundStyle(Color.textPrimary)
        }
    }
}

// MARK: - Preview

#Preview("Can Attempt") {
    TestOutPromptView(
        testOut: TestOut.rookieTestOut,
        module: Module.rookie,
        eligibility: .available,
        onStartTest: {},
        onSkip: {}
    )
}

#Preview("One Attempt Left") {
    TestOutPromptView(
        testOut: TestOut.rookieTestOut,
        module: Module.rookie,
        eligibility: .oneAttemptLeft,
        onStartTest: {},
        onSkip: {}
    )
}

#Preview("On Cooldown") {
    TestOutPromptView(
        testOut: TestOut.rookieTestOut,
        module: Module.rookie,
        eligibility: .inCooldown(until: Date().addingTimeInterval(3600)),
        onStartTest: {},
        onSkip: {}
    )
}

#Preview("Already Passed") {
    TestOutPromptView(
        testOut: TestOut.rookieTestOut,
        module: Module.rookie,
        eligibility: .alreadyPassed,
        onStartTest: {},
        onSkip: {}
    )
}
