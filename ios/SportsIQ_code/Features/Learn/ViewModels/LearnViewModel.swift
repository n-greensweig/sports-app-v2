//
//  LearnViewModel.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

@Observable
class LearnViewModel {
    // MARK: - Dependencies
    private let learningRepository: LearningRepository

    // MARK: - State
    var sports: [Sport] = []
    var isLoading = false
    var errorMessage: String?

    init(learningRepository: LearningRepository) {
        self.learningRepository = learningRepository
    }

    @MainActor
    func loadSports() async {
        isLoading = true
        errorMessage = nil

        do {
            sports = try await learningRepository.getSports()
        } catch {
            errorMessage = "Failed to load sports: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
