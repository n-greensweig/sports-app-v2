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
    var userProgress: UserProgress?
    var isLoading = false
    var isLoadingModules = false
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

            // Load user progress for selected sport
            if let sport = selectedSport {
                userProgress = try await userRepository.getUserProgress(
                    userId: userId,
                    sportId: sport.id
                )
                await loadModules(for: sport)
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

        // Load progress and modules for newly selected sport
        do {
            userProgress = try await userRepository.getUserProgress(
                userId: userId,
                sportId: sport.id
            )
            await loadModules(for: sport)
        } catch {
            print("Error loading progress for \(sport.name): \(error)")
        }
    }

    @MainActor
    private func loadModules(for sport: Sport) async {
        isLoadingModules = true
        do {
            modules = try await learningRepository.getModules(sportId: sport.id)
        } catch {
            print("Error loading modules for \(sport.name): \(error)")
            modules = []
        }
        isLoadingModules = false
    }
}
