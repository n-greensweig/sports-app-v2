//
//  StreakCard.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct StreakCard: View {
    let currentStreak: Int
    let longestStreak: Int

    var body: some View {
        HStack(spacing: .spacingL) {
            // Current Streak
            VStack(spacing: .spacingS) {
                HStack(spacing: .spacingS) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(currentStreak > 0 ? Color.warning : Color.textTertiary)

                    Text("\(currentStreak)")
                        .font(.heading1)
                        .foregroundStyle(Color.textPrimary)
                }

                Text("Day Streak")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
            .frame(maxWidth: .infinity)

            Divider()

            // Longest Streak
            VStack(spacing: .spacingS) {
                HStack(spacing: .spacingS) {
                    Image(systemName: "trophy.fill")
                        .font(.title2)
                        .foregroundStyle(Color.footballAccent)

                    Text("\(longestStreak)")
                        .font(.heading1)
                        .foregroundStyle(Color.textPrimary)
                }

                Text("Best Streak")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.spacingL)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
    }
}

#Preview("Streak Card") {
    VStack(spacing: .spacingM) {
        StreakCard(currentStreak: 7, longestStreak: 14)
        StreakCard(currentStreak: 0, longestStreak: 5)
    }
    .padding(.spacingM)
}
