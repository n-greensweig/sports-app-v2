//
//  ModuleSelectorView.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import SwiftUI

/// Horizontal scrolling module selector tabs for the home screen
struct ModuleSelectorView: View {
    let modules: [Module]
    let selectedModule: Module?
    let lessonCompletions: [UUID: Int]
    let learningRepository: LearningRepository
    let onModuleSelected: (Module) -> Void

    @State private var moduleProgress: [UUID: Double] = [:]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .spacingS) {
                ForEach(modules) { module in
                    ModuleTabButton(
                        module: module,
                        isSelected: selectedModule?.id == module.id,
                        progress: moduleProgress[module.id] ?? 0,
                        onTap: {
                            onModuleSelected(module)
                        }
                    )
                }
            }
            .padding(.horizontal, .spacingM)
        }
        .task {
            await loadModuleProgress()
        }
    }

    private func loadModuleProgress() async {
        var progress: [UUID: Double] = [:]

        for module in modules {
            do {
                let lessons = try await learningRepository.getLessons(moduleId: module.id)
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
            }
        }

        await MainActor.run {
            moduleProgress = progress
        }
    }
}

// MARK: - Module Tab Button
struct ModuleTabButton: View {
    let module: Module
    let isSelected: Bool
    let progress: Double
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: .spacingXS) {
                // Module title with icon
                HStack(spacing: .spacingXS) {
                    moduleIcon
                        .font(.system(size: 14))

                    Text(module.title)
                        .font(.subheadline)
                        .fontWeight(isSelected ? .semibold : .medium)
                }
                .foregroundStyle(isSelected ? Color.brandPrimary : Color.textSecondary)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.backgroundSecondary)
                            .frame(height: 4)

                        // Progress fill
                        RoundedRectangle(cornerRadius: 2)
                            .fill(progressColor)
                            .frame(width: geo.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal, .spacingM)
            .padding(.vertical, .spacingS)
            .background(
                RoundedRectangle(cornerRadius: .radiusM)
                    .fill(isSelected ? Color.brandPrimary.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .radiusM)
                    .stroke(isSelected ? Color.brandPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var moduleIcon: Image {
        if progress >= 1.0 {
            return Image(systemName: "checkmark.circle.fill")
        } else if progress > 0 {
            return Image(systemName: "circle.lefthalf.filled")
        } else {
            return Image(systemName: "circle")
        }
    }

    private var progressColor: Color {
        if progress >= 1.0 {
            return .correct
        } else {
            return .brandPrimary
        }
    }
}

#Preview("Module Selector") {
    VStack {
        ModuleSelectorView(
            modules: Module.mockModules,
            selectedModule: Module.rookie,
            lessonCompletions: [:],
            learningRepository: MockLearningRepository(),
            onModuleSelected: { _ in }
        )
    }
    .padding()
}
