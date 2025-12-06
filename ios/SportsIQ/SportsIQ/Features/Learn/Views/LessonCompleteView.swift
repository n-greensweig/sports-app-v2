//
//  LessonCompleteView.swift
//  Ola Ball
//
//  Created on 2025-11-20.
//

import SwiftUI

struct LessonCompleteView: View {
    let lesson: Lesson
    let accuracyPercentage: Int
    let xpEarned: Int
    let currentStreak: Int
    let streakMilestone: StreakMilestone?
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var showMilestoneOverlay = false
    @State private var triggerScreenShake = false

    var isPerfectScore: Bool {
        accuracyPercentage == 100
    }

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            // Use enhanced confetti for perfect scores
            if isPerfectScore {
                BurstConfettiView(intensity: .high)
                    .ignoresSafeArea()
            } else {
                CelebrationView()
                    .ignoresSafeArea()
            }

            VStack(spacing: .spacingXL) {
                Spacer()

                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.brandPrimary)
                }
                .scaleEffect(showContent ? 1 : 0.5)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContent)

                VStack(spacing: .spacingS) {
                    Text("Lesson Complete!")
                        .font(.heading1)
                        .foregroundStyle(Color.textPrimary)

                    Text(lesson.title)
                        .font(.heading3)
                        .foregroundStyle(Color.textSecondary)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut.delay(0.2), value: showContent)

                // Stats Grid
                HStack(spacing: .spacingL) {
                    StatBox(title: "Accuracy", value: "\(accuracyPercentage)%", icon: "target")
                    StatBox(title: "XP Earned", value: "+\(xpEarned)", icon: "star.fill")
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut.delay(0.4), value: showContent)

                // Streak indicator
                if currentStreak > 0 {
                    HStack(spacing: .spacingS) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("\(currentStreak) day streak!")
                            .font(.body.bold())
                            .foregroundStyle(Color.textPrimary)
                    }
                    .padding(.vertical, .spacingS)
                    .padding(.horizontal, .spacingM)
                    .background(Color.warning.opacity(0.15))
                    .cornerRadius(.radiusM)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut.delay(0.5), value: showContent)
                }

                Spacer()

                PrimaryButton(title: "Continue", action: onDismiss)
                    .padding(.horizontal, .spacingL)
                    .padding(.bottom, .spacingXL)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut.delay(0.6), value: showContent)
            }
        }
        .screenShake(trigger: $triggerScreenShake, intensity: isPerfectScore ? 12 : 0)
        .onAppear {
            showContent = true

            // Screen shake for perfect score
            if isPerfectScore {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    triggerScreenShake = true
                    HapticManager.shared.playPerfectScorePattern()
                }
            }

            // Show milestone after celebration settles
            if streakMilestone != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showMilestoneOverlay = true
                }
            }
        }
        .task {
            // Request notification permission after first lesson
            let hasAskedKey = "hasAskedNotificationPermission"
            if UserDefaults.standard.bool(forKey: hasAskedKey) == false {
                UserDefaults.standard.set(true, forKey: hasAskedKey)
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                _ = await NotificationManager.shared.requestPermission()
            }
        }
        .fullScreenCover(isPresented: $showMilestoneOverlay) {
            if let milestone = streakMilestone {
                StreakMilestoneView(
                    milestone: milestone,
                    currentStreak: currentStreak,
                    onDismiss: { showMilestoneOverlay = false }
                )
            }
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: .spacingXS) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.brandPrimary)

            Text(value)
                .font(.heading2)
                .foregroundStyle(Color.textPrimary)

            Text(title)
                .font(.label)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(width: 120, height: 100)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
    }
}

#Preview("Lesson Complete") {
    LessonCompleteView(
        lesson: .footballBasicsLesson1,
        accuracyPercentage: 80,
        xpEarned: 40,
        currentStreak: 5,
        streakMilestone: nil,
        onDismiss: {}
    )
}

#Preview("Perfect Score") {
    LessonCompleteView(
        lesson: .footballBasicsLesson1,
        accuracyPercentage: 100,
        xpEarned: 50,
        currentStreak: 7,
        streakMilestone: .oneWeek,
        onDismiss: {}
    )
}
