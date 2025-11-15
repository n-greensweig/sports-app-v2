//
//  LessonCard.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct LessonCard: View {
    let lesson: Lesson
    let sport: Sport
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: .spacingM) {
                // Icon
                ZStack {
                    Circle()
                        .fill(lesson.isLocked ? Color.backgroundTertiary : sport.accentColor.opacity(0.2))
                        .frame(width: 48, height: 48)

                    Image(systemName: lesson.isLocked ? "lock.fill" : "book.fill")
                        .font(.title3)
                        .foregroundStyle(lesson.isLocked ? Color.textTertiary : sport.accentColor)
                }

                // Content
                VStack(alignment: .leading, spacing: .spacingXS) {
                    Text(lesson.title)
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundStyle(lesson.isLocked ? Color.textSecondary : Color.textPrimary)

                    HStack(spacing: .spacingM) {
                        Label("\(lesson.estimatedMinutes) min", systemImage: "clock")
                        Label("\(lesson.xpAward) XP", systemImage: "star")
                    }
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                }

                Spacer()

                // Arrow
                if !lesson.isLocked {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.textTertiary)
                }
            }
            .padding(.spacingM)
            .background(Color.backgroundSecondary)
            .cornerRadius(.radiusM)
        }
        .buttonStyle(.plain)
        .disabled(lesson.isLocked)
    }
}

#Preview("Lesson Cards") {
    VStack(spacing: .spacingM) {
        LessonCard(
            lesson: .footballBasicsLesson1,
            sport: .football,
            onTap: {}
        )

        LessonCard(
            lesson: .footballBasicsLesson2,
            sport: .football,
            onTap: {}
        )
    }
    .padding(.spacingM)
}
