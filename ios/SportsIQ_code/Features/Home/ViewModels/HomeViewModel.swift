//
//  HomeViewModel.swift
//  SportsIQ
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
    var userProgress: UserProgress?
    var isLoading = false
    var errorMessage: String?

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
            async let sportsTask = learningRepository.getSports()
            async let progressTask = userRepository.getUserProgress(
                userId: userId,
                sportId: Sport.football.id // TODO: Make this dynamic
            )

            sports = try await sportsTask
            userProgress = try await progressTask
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
