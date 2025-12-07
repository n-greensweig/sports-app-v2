//
//  ModuleListView.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import SwiftUI

/// Full-screen list of all modules for a sport (like Duolingo's section list)
struct ModuleListView: View {
    let sport: Sport
    let modules: [Module]
    let currentModule: Module?
    let lessonCompletions: [UUID: Int]
    let learningRepository: LearningRepository
    let onModuleSelected: (Module) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var moduleProgress: [UUID: Double] = [:]
    @State private var moduleLessonCounts: [UUID: Int] = [:]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .spacingM) {
                    ForEach(modules) { module in
                        ModuleCard(
                            module: module,
                            isCurrentModule: module.id == currentModule?.id,
                            progress: moduleProgress[module.id] ?? 0,
                            lessonCount: moduleLessonCounts[module.id] ?? 0,
                            onTap: {
                                onModuleSelected(module)
                                dismiss()
                            }
                        )
                    }
                }
                .padding(.horizontal, .spacingM)
                .padding(.vertical, .spacingM)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle(sport.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Color.textPrimary)
                    }
                }
            }
            .task {
                await loadModuleData()
            }
        }
    }

    private func loadModuleData() async {
        var progress: [UUID: Double] = [:]
        var counts: [UUID: Int] = [:]

        for module in modules {
            do {
                let lessons = try await learningRepository.getLessons(moduleId: module.id)
                counts[module.id] = lessons.count

                guard !lessons.isEmpty else {
                    progress[module.id] = 0
                    continue
                }

                var totalProgress: Double = 0
                for lesson in lessons {
                    let completions = lessonCompletions[lesson.id] ?? 0
                    let lessonProgress = min(1.0, Double(completions) / Double(lesson.requiredCompletions))
                    totalProgress += lessonProgress
                }
                progress[module.id] = totalProgress / Double(lessons.count)
            } catch {
                progress[module.id] = 0
                counts[module.id] = 0
            }
        }

        await MainActor.run {
            moduleProgress = progress
            moduleLessonCounts = counts
        }
    }
}

// MARK: - Module Card
struct ModuleCard: View {
    let module: Module
    let isCurrentModule: Bool
    let progress: Double
    let lessonCount: Int
    let onTap: () -> Void

    private var isComplete: Bool {
        progress >= 1.0
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: .spacingS) {
                // Module title
                Text(module.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)

                // Progress bar with trophy
                HStack(spacing: .spacingM) {
                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.backgroundSecondary)
                                .frame(height: 16)

                            // Progress fill
                            RoundedRectangle(cornerRadius: 8)
                                .fill(progressGradient)
                                .frame(width: geo.size.width * progress, height: 16)
                        }
                    }
                    .frame(height: 16)

                    // Trophy icon
                    Image(systemName: isComplete ? "trophy.fill" : "trophy")
                        .font(.title2)
                        .foregroundStyle(isComplete ? Color.correct : Color.textTertiary)
                }
            }
            .padding(.spacingL)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .cornerRadius(.radiusL)
            .overlay(
                RoundedRectangle(cornerRadius: .radiusL)
                    .stroke(isCurrentModule ? Color.brandPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var progressGradient: LinearGradient {
        if isComplete {
            return LinearGradient(
                colors: [Color.correct, Color.correct.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            return LinearGradient(
                colors: [Color.brandPrimary, Color.brandPrimary.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    private var cardBackground: Color {
        if isCurrentModule {
            return Color(UIColor.systemBackground)
        } else {
            return Color(UIColor.systemBackground)
        }
    }
}

#Preview("Module List") {
    ModuleListView(
        sport: Sport.football,
        modules: Module.mockModules,
        currentModule: Module.rookie,
        lessonCompletions: [:],
        learningRepository: MockLearningRepository(),
        onModuleSelected: { _ in }
    )
}
