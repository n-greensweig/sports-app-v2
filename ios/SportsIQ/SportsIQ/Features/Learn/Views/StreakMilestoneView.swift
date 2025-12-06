//
//  StreakMilestoneView.swift
//  Ola Ball
//
//  Created for Engagement Features
//

import SwiftUI

/// Full-screen celebration overlay for streak milestones
struct StreakMilestoneView: View {
    let milestone: StreakMilestone
    let currentStreak: Int
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var triggerShake = false
    @State private var flameScale: CGFloat = 0.8

    var body: some View {
        ZStack {
            // Dark overlay
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            // Burst confetti
            BurstConfettiView(intensity: milestone.celebrationIntensity)
                .ignoresSafeArea()

            VStack(spacing: .spacingXL) {
                Spacer()

                // Animated flame icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.orange.opacity(0.4), .clear],
                                center: .center,
                                startRadius: 40,
                                endRadius: 100
                            )
                        )
                        .frame(width: 180, height: 180)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange, .red],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .scaleEffect(flameScale)
                        .shadow(color: .orange.opacity(0.5), radius: 20, x: 0, y: 10)
                }

                VStack(spacing: .spacingM) {
                    Text("\(currentStreak)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Day Streak!")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(milestone.celebrationMessage)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, .spacingXL)
                }

                Spacer()

                PrimaryButton(title: "Keep Going!", action: onDismiss)
                    .padding(.horizontal, .spacingXL)
                    .padding(.bottom, .spacingXXL)
            }
            .scaleEffect(showContent ? 1 : 0.8)
            .opacity(showContent ? 1 : 0)
        }
        .screenShake(trigger: $triggerShake, intensity: 15, duration: 0.6)
        .onAppear {
            // Animate content in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showContent = true
            }

            // Trigger shake
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                triggerShake = true
            }

            // Pulsing flame animation
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                flameScale = 1.1
            }

            // Play celebration feedback
            HapticManager.shared.playMilestonePattern()
            AudioManager.shared.playStreakSound()
        }
    }
}

#Preview("5 Day Streak") {
    StreakMilestoneView(
        milestone: .fiveDays,
        currentStreak: 5,
        onDismiss: {}
    )
}

#Preview("1 Week Streak") {
    StreakMilestoneView(
        milestone: .oneWeek,
        currentStreak: 7,
        onDismiss: {}
    )
}

#Preview("1 Month Streak") {
    StreakMilestoneView(
        milestone: .oneMonth,
        currentStreak: 30,
        onDismiss: {}
    )
}
