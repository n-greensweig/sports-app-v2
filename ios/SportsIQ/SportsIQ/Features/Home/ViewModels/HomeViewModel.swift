//
//  HomeViewModel.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import Foundation

@Observable
class HomeViewModel {
    // MARK: - Dependencies
    private let learningRepository: LearningRepository
    private let userRepository: UserRepository
    private let userId: UUID

    // MARK: - State
    var sports: [Sport] = []
    var selectedSport: Sport?
    var modules: [Module] = []
    var currentModule: Module?  // The active module being worked on
    var lessons: [Lesson] = []
    var lessonCompletions: [UUID: Int] = [:]  // lessonId -> completionCount
    var userProgress: UserProgress?
    var currentStreak: Streak?
    var isLoading = false
    var isLoadingStreak = false
    var isLoadingLessons = false
    var errorMessage: String?

    // MARK: - UserDefaults Keys
    private static let lastSelectedSportIdKey = "lastSelectedSportId"

    init(
        learningRepository: LearningRepository,
        userRepository: UserRepository,
        userId: UUID
    ) {
        self.learningRepository = learningRepository
        self.userRepository = userRepository
        self.userId = userId
    }

    @MainActor
    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            // Fetch sports first
            sports = try await learningRepository.getSports()

            // Restore last selected sport or default to first sport
            if let lastSportId = UserDefaults.standard.string(forKey: Self.lastSelectedSportIdKey),
               let uuid = UUID(uuidString: lastSportId),
               let lastSport = sports.first(where: { $0.id == uuid }) {
                selectedSport = lastSport
            } else if let firstSport = sports.first {
                selectedSport = firstSport
            }

            // Load user progress, streak, and lessons for selected sport
            if let sport = selectedSport {
                userProgress = try await userRepository.getUserProgress(
                    userId: userId,
                    sportId: sport.id
                )
                currentStreak = try await userRepository.getStreak(
                    userId: userId,
                    sportId: sport.id
                )
                await loadLessons(for: sport)
            }
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }

        isLoading = false
    }

    @MainActor
    func selectSport(_ sport: Sport) async {
        guard sport.id != selectedSport?.id else { return }

        selectedSport = sport

        // Save to UserDefaults
        UserDefaults.standard.set(sport.id.uuidString, forKey: Self.lastSelectedSportIdKey)

        // Load progress, streak, and lessons for newly selected sport
        do {
            userProgress = try await userRepository.getUserProgress(
                userId: userId,
                sportId: sport.id
            )
            currentStreak = try await userRepository.getStreak(
                userId: userId,
                sportId: sport.id
            )
            await loadLessons(for: sport)
        } catch {
            print("Error loading progress for \(sport.name): \(error)")
        }
    }

    @MainActor
    private func loadLessons(for sport: Sport) async {
        isLoadingLessons = true
        do {
            // Get all modules for the sport, sorted by orderIndex
            modules = try await learningRepository.getModules(sportId: sport.id)
            modules.sort { $0.orderIndex < $1.orderIndex }
            print("📦 Found \(modules.count) modules for sport \(sport.name) (id: \(sport.id))")
            for module in modules {
                print("   📁 Module: \(module.title) (id: \(module.id), order: \(module.orderIndex))")
            }

            // Load completion counts for all lessons
            lessonCompletions = try await learningRepository.getLessonCompletions(
                userId: userId,
                sportId: sport.id
            )
            print("📊 Loaded \(lessonCompletions.count) lesson completions")

            // Find the current active module (first module that isn't fully completed)
            currentModule = await findCurrentModule()
            print("🎯 Current module: \(currentModule?.title ?? "none")")

            // Only load lessons from the current module
            if let activeModule = currentModule {
                let moduleLessons = try await learningRepository.getLessons(moduleId: activeModule.id)
                lessons = moduleLessons.sorted { $0.orderIndex < $1.orderIndex }
                print("📚 Loaded \(lessons.count) lessons from '\(activeModule.title)'")
            } else {
                lessons = []
            }

        } catch {
            print("❌ Error loading lessons for \(sport.name): \(error)")
            lessons = []
            lessonCompletions = [:]
            modules = []
            currentModule = nil
        }
        isLoadingLessons = false
    }

    /// Find the first module that isn't fully completed
    @MainActor
    private func findCurrentModule() async -> Module? {
        for module in modules {
            // Get lessons for this module
            do {
                let moduleLessons = try await learningRepository.getLessons(moduleId: module.id)

                // Check if any lesson in this module is not fully completed (5 completions)
                let isModuleComplete = moduleLessons.allSatisfy { lesson in
                    let completionCount = lessonCompletions[lesson.id] ?? 0
                    return completionCount >= lesson.requiredCompletions
                }

                // If module is not complete, this is the current module
                if !isModuleComplete {
                    return module
                }
            } catch {
                print("❌ Error checking module completion for \(module.title): \(error)")
                return module  // Default to this module on error
            }
        }

        // All modules complete, return the last one
        return modules.last
    }

    /// Switch to a specific module
    @MainActor
    func selectModule(_ module: Module) async {
        guard module.id != currentModule?.id else { return }

        currentModule = module
        isLoadingLessons = true

        do {
            let moduleLessons = try await learningRepository.getLessons(moduleId: module.id)
            lessons = moduleLessons.sorted { $0.orderIndex < $1.orderIndex }
            print("📚 Switched to module '\(module.title)' with \(lessons.count) lessons")
        } catch {
            print("❌ Error loading lessons for module \(module.title): \(error)")
            lessons = []
        }

        isLoadingLessons = false
    }
}
