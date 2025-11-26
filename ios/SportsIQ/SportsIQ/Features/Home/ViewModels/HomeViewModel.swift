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
    var lessons: [Lesson] = []
    var lessonCompletions: [UUID: Int] = [:]  // lessonId -> completionCount
    var userProgress: UserProgress?
    var isLoading = false
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

            // Load user progress and lessons for selected sport
            if let sport = selectedSport {
                userProgress = try await userRepository.getUserProgress(
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

        // Load progress and lessons for newly selected sport
        do {
            userProgress = try await userRepository.getUserProgress(
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
            // Get all modules for the sport
            let modules = try await learningRepository.getModules(sportId: sport.id)

            // Flatten all lessons from all modules
            var allLessons: [Lesson] = []
            for module in modules {
                let moduleLessons = try await learningRepository.getLessons(moduleId: module.id)
                allLessons.append(contentsOf: moduleLessons)
            }

            // Sort by orderIndex
            lessons = allLessons.sorted { $0.orderIndex < $1.orderIndex }

            // Load actual completion counts from repository
            lessonCompletions = try await learningRepository.getLessonCompletions(
                userId: userId,
                sportId: sport.id
            )
            print("📊 Loaded \(lessonCompletions.count) lesson completions")

        } catch {
            print("Error loading lessons for \(sport.name): \(error)")
            lessons = []
            lessonCompletions = [:]
        }
        isLoadingLessons = false
    }
}
