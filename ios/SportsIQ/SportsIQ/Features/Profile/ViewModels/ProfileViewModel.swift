//
//  ProfileViewModel.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

@Observable
class ProfileViewModel {
    // MARK: - Dependencies
    private let userRepository: UserRepository
    private let userId: UUID

    // MARK: - State
    var userProgress: UserProgress?
    var earnedBadges: [UserBadge] = []
    var isLoading = false
    var errorMessage: String?

    init(userRepository: UserRepository, userId: UUID) {
        self.userRepository = userRepository
        self.userId = userId
    }

    @MainActor
    func loadUserProgress() async {
        isLoading = true
        errorMessage = nil

        do {
            // Load progress for Football (default for MVP)
            userProgress = try await userRepository.getUserProgress(
                userId: userId,
                sportId: Sport.football.id
            )

            // Mock earned badges (in real app, fetch from repository)
            earnedBadges = [
                UserBadge(
                    id: UUID(),
                    userId: userId,
                    badge: Badge.firstLesson,
                    earnedAt: Date(),
                    sportId: Sport.football.id
                ),
                UserBadge(
                    id: UUID(),
                    userId: userId,
                    badge: Badge.perfectScore,
                    earnedAt: Date(),
                    sportId: Sport.football.id
                )
            ]
        } catch {
            errorMessage = "Failed to load progress: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
