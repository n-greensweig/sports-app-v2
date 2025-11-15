//
//  DailyGoalCard.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct DailyGoalCard: View {
    let goal: DailyGoal

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            // Header
            HStack {
                Image(systemName: "target")
                    .foregroundStyle(Color.footballAccent)

                Text("Daily Goal")
                    .font(.heading3)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                if goal.isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.correct)
                }
            }

            // XP Progress
            VStack(alignment: .leading, spacing: .spacingS) {
                HStack {
                    Text("XP Progress")
                        .font(.label)
                        .foregroundStyle(Color.textSecondary)

                    Spacer()

                    Text("\(goal.xpEarned)/\(goal.xpGoal)")
                        .font(.label)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)
                }

                ProgressBar(
                    progress: goal.xpProgress,
                    color: Color.footballAccent,
                    height: 8
                )
            }

            // Lessons Progress
            VStack(alignment: .leading, spacing: .spacingS) {
                HStack {
                    Text("Lessons Completed")
                        .font(.label)
                        .foregroundStyle(Color.textSecondary)

                    Spacer()

                    Text("\(goal.lessonsCompleted)/\(goal.lessonsGoal)")
                        .font(.label)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)
                }

                ProgressBar(
                    progress: goal.lessonsProgress,
                    color: Color.footballAccent,
                    height: 8
                )
            }

            // Encouragement
            if goal.isComplete {
                Text("Goal complete! Great work today!")
                    .font(.caption)
                    .foregroundStyle(Color.correct)
            } else {
                let remaining = goal.xpGoal - goal.xpEarned
                Text("\(remaining) XP to go!")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.spacingL)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
    }
}

#Preview("Daily Goal Card") {
    VStack(spacing: .spacingM) {
        DailyGoalCard(goal: DailyGoal.mockGoal)
        DailyGoalCard(goal: DailyGoal(
            userId: UUID(),
            sportId: Sport.football.id,
            date: Date(),
            xpGoal: 100,
            xpEarned: 100,
            lessonsGoal: 3,
            lessonsCompleted: 3
        ))
    }
    .padding(.spacingM)
}
