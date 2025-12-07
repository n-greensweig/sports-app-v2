//
//  LearnView.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import SwiftUI

struct LearnView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: LearnViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = State(initialValue: LearnViewModel(
            learningRepository: coordinator.learningRepository
        ))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .spacingL) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.spacingXL)
                    } else {
                        // Sport Selection
                        VStack(alignment: .leading, spacing: .spacingM) {
                            Text("Choose a Sport")
                                .font(.heading3)
                                .foregroundStyle(Color.textPrimary)

                            ForEach(viewModel.sports) { sport in
                                NavigationLink {
                                    SportModulesView(
                                        sport: sport,
                                        coordinator: coordinator
                                    )
                                } label: {
                                    VStack(alignment: .leading, spacing: .spacingS) {
                                        HStack {
                                            Image(systemName: sport.iconName)
                                                .font(.system(size: 32))
                                                .foregroundStyle(sport.accentColor)

                                            Spacer()

                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 16))
                                                .foregroundStyle(Color.textSecondary)
                                        }

                                        Text(sport.name)
                                            .font(.heading3)
                                            .foregroundStyle(Color.textPrimary)

                                        Text(sport.description)
                                            .font(.bodySmall)
                                            .foregroundStyle(Color.textSecondary)
                                            .lineLimit(2)
                                    }
                                    .padding(.spacingM)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(.radiusL)
                                }
                            }
                        }
                    }
                }
                .padding(.spacingM)
            }
            .navigationTitle("Learn")
            .task {
                await viewModel.loadSports()
            }
        }
    }
}

// MARK: - Sport Modules View (Duolingo-style sections)
struct SportModulesView: View {
    let sport: Sport
    let coordinator: AppCoordinator
    @State private var modules: [Module] = []
    @State private var expandedModuleId: UUID?
    @State private var lessonsByModule: [UUID: [Lesson]] = [:]
    @State private var completions: [UUID: Int] = [:]  // lessonId -> completionCount
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.spacingXL)
                } else if modules.isEmpty {
                    VStack(spacing: .spacingM) {
                        Text("No modules available")
                            .font(.heading3)
                            .foregroundStyle(Color.textPrimary)
                        Text("Modules will appear here once they're loaded")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.spacingXL)
                } else {
                    ForEach(Array(modules.enumerated()), id: \.element.id) { index, module in
                        ModuleSectionView(
                            module: module,
                            sectionNumber: index + 1,
                            sport: sport,
                            coordinator: coordinator,
                            isExpanded: expandedModuleId == module.id,
                            lessons: lessonsByModule[module.id] ?? [],
                            completions: completions,
                            onToggle: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if expandedModuleId == module.id {
                                        expandedModuleId = nil
                                    } else {
                                        expandedModuleId = module.id
                                        // Load lessons if not already loaded
                                        if lessonsByModule[module.id] == nil {
                                            Task {
                                                await loadLessons(for: module.id)
                                            }
                                        }
                                    }
                                }
                            }
                        )
                    }
                }
            }
            .padding(.spacingM)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle(sport.name)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await loadModules()
        }
    }

    private func loadModules() async {
        isLoading = true
        do {
            modules = try await coordinator.learningRepository.getModules(sportId: sport.id)
            print("🔍 Loaded \(modules.count) modules: \(modules.map { "\($0.title) (locked: \($0.isLocked))" })")

            // Auto-expand the first non-locked module (or just the first one)
            if let firstModule = modules.first(where: { !$0.isLocked }) ?? modules.first {
                expandedModuleId = firstModule.id
                await loadLessons(for: firstModule.id)
            }

            // Load completions
            if let userId = coordinator.currentUser?.id {
                completions = try await coordinator.learningRepository.getLessonCompletions(
                    userId: userId,
                    sportId: sport.id
                )
            }
        } catch {
            print("❌ Error loading modules: \(error)")
        }
        isLoading = false
    }

    private func loadLessons(for moduleId: UUID) async {
        do {
            let lessons = try await coordinator.learningRepository.getLessons(moduleId: moduleId)
            lessonsByModule[moduleId] = lessons
        } catch {
            print("❌ Error loading lessons for module \(moduleId): \(error)")
        }
    }
}

// MARK: - Module Section View (Duolingo-style expandable section)
struct ModuleSectionView: View {
    let module: Module
    let sectionNumber: Int
    let sport: Sport
    let coordinator: AppCoordinator
    let isExpanded: Bool
    let lessons: [Lesson]
    let completions: [UUID: Int]
    let onToggle: () -> Void

    /// Calculate progress as percentage of mastered lessons
    private var progress: Double {
        guard !lessons.isEmpty else { return 0 }
        let masteredCount = lessons.filter { lesson in
            (completions[lesson.id] ?? 0) >= lesson.requiredCompletions
        }.count
        return Double(masteredCount) / Double(lessons.count)
    }

    /// Check if all lessons are mastered
    private var isCompleted: Bool {
        progress >= 1.0
    }

    /// The index of the current lesson (first unlocked, incomplete lesson)
    private var currentLessonIndex: Int? {
        lessons.firstIndex { lesson in
            !lesson.isLocked && (completions[lesson.id] ?? 0) < lesson.requiredCompletions
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Section Header (tappable)
            Button(action: onToggle) {
                HStack(spacing: .spacingM) {
                    VStack(alignment: .leading, spacing: .spacingXS) {
                        Text(module.title)
                            .font(.heading4)
                            .foregroundStyle(module.isLocked ? Color.textTertiary : Color.textPrimary)

                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background track
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.backgroundTertiary)
                                    .frame(height: 8)

                                // Progress fill
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(sport.accentColor)
                                    .frame(width: geometry.size.width * progress, height: 8)
                            }
                        }
                        .frame(height: 8)
                    }

                    // Trophy or Lock icon
                    if module.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundStyle(Color.textTertiary)
                    } else {
                        Image(systemName: isCompleted ? "trophy.fill" : "trophy")
                            .font(.title2)
                            .foregroundStyle(isCompleted ? sport.accentColor : Color.textTertiary)
                    }
                }
                .padding(.spacingM)
                .background(Color.backgroundSecondary)
                .cornerRadius(.radiusL)
                .overlay(
                    RoundedRectangle(cornerRadius: .radiusL)
                        .stroke(isExpanded ? sport.accentColor : Color.clear, lineWidth: 2)
                )
            }
            .buttonStyle(.plain)
            .disabled(module.isLocked)
            .opacity(module.isLocked ? 0.5 : 1.0)

            // Expanded content (lessons)
            if isExpanded && !module.isLocked {
                VStack(spacing: .spacingS) {
                    // Module description
                    Text(module.description)
                        .font(.bodySmall)
                        .foregroundStyle(Color.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, .spacingM)
                        .padding(.top, .spacingM)

                    // Lessons
                    if lessons.isEmpty {
                        ProgressView()
                            .padding(.spacingL)
                    } else {
                        ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                            NavigationLink {
                                LessonView(
                                    lesson: lesson,
                                    sport: sport,
                                    coordinator: coordinator
                                )
                            } label: {
                                LessonCard(
                                    lesson: lesson,
                                    lessonNumber: index + 1,
                                    sport: sport,
                                    completionCount: completions[lesson.id] ?? 0,
                                    isCurrentLesson: index == currentLessonIndex
                                )
                            }
                            .disabled(lesson.isLocked)
                            .padding(.horizontal, .spacingS)
                        }
                    }
                }
                .padding(.bottom, .spacingM)
                .background(Color.backgroundSecondary.opacity(0.5))
                .cornerRadius(.radiusL)
                .padding(.top, -8) // Overlap slightly with header
            }
        }
        .padding(.bottom, .spacingS)
    }
}

#Preview("Learn View") {
    LearnView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository(),
        gameRepository: MockGameRepository()
    ))
}

#Preview("Sport Modules - Duolingo Style") {
    NavigationStack {
        SportModulesView(
            sport: .football,
            coordinator: AppCoordinator(
                learningRepository: MockLearningRepository(),
                userRepository: MockUserRepository(),
                gameRepository: MockGameRepository()
            )
        )
    }
}
