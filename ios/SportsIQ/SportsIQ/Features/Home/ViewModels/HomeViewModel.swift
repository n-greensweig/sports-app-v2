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
            // Fetch sports first to get the real Football ID
            sports = try await learningRepository.getSports()
            
            // Find Football sport (should be first, but search by slug to be safe)
            if let footballSport = sports.first(where: { $0.slug == "football" }) {
                userProgress = try await userRepository.getUserProgress(
                    userId: userId,
                    sportId: footballSport.id
                )
            } else {
                print("⚠️ Football sport not found in database")
            }
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
