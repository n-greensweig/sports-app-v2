//
//  ModuleCard.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct ModuleCard: View {
    let module: Module
    let sport: Sport
    let progress: Double // 0.0 to 1.0
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: .spacingM) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: .spacingXS) {
                        Text(module.title)
                            .font(.heading3)
                            .foregroundStyle(module.isLocked ? Color.textSecondary : Color.textPrimary)

                        Text("\(module.totalLessons) lessons • \(module.estimatedMinutes) min")
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }

                    Spacer()

                    if module.isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(Color.textTertiary)
                    }
                }

                // Description
                Text(module.description)
                    .font(.body)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(2)

                // Progress
                if progress > 0 && !module.isLocked {
                    VStack(alignment: .leading, spacing: .spacingS) {
                        HStack {
                            Text("Progress")
                                .font(.caption)
                                .foregroundStyle(Color.textSecondary)

                            Spacer()

                            Text("\(Int(progress * 100))%")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(sport.accentColor)
                        }

                        ProgressBar(
                            progress: progress,
                            color: sport.accentColor,
                            height: 6
                        )
                    }
                }
            }
            .padding(.spacingL)
            .background(Color.backgroundSecondary)
            .cornerRadius(.radiusL)
            .overlay(
                RoundedRectangle(cornerRadius: .radiusL)
                    .stroke(module.isLocked ? Color.clear : sport.accentColor.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(module.isLocked)
    }
}

#Preview("Module Cards") {
    VStack(spacing: .spacingM) {
        ModuleCard(
            module: .footballBasics,
            sport: .football,
            progress: 0.375,
            onTap: {}
        )

        ModuleCard(
            module: .offensiveStrategies,
            sport: .football,
            progress: 0.0,
            onTap: {}
        )
    }
    .padding(.spacingM)
}
