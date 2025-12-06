//
//  MockUserRepository.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import Foundation

/// Mock implementation of UserRepository for development and testing
class MockUserRepository: UserRepository {
    private var currentUser: User? = User.mock
    private var userProgress: [UUID: UserProgress] = [
        Sport.football.id: UserProgress.mock
    ]
    private var streaks: [String: Streak] = [:] // Key: "userId_sportId"

    func getCurrentUser() async throws -> User? {
        try await Task.sleep(nanoseconds: 300_000_000)
        return currentUser
    }

    func getUser(id: UUID) async throws -> User? {
        try await Task.sleep(nanoseconds: 300_000_000)
        return currentUser?.id == id ? currentUser : nil
    }

    func updateUser(_ user: User) async throws -> User {
        try await Task.sleep(nanoseconds: 300_000_000)
        currentUser = user
        return user
    }

    func getUserProgress(userId: UUID, sportId: UUID) async throws -> UserProgress? {
        try await Task.sleep(nanoseconds: 300_000_000)
        return userProgress[sportId]
    }

    func updateUserProgress(_ progress: UserProgress) async throws -> UserProgress {
        try await Task.sleep(nanoseconds: 300_000_000)
        userProgress[progress.sportId] = progress
        return progress
    }

    // MARK: - Streak Management

    func getStreak(userId: UUID, sportId: UUID) async throws -> Streak? {
        try await Task.sleep(nanoseconds: 100_000_000)
        let key = "\(userId.uuidString)_\(sportId.uuidString)"
        return streaks[key]
    }

    func updateStreak(userId: UUID, sportId: UUID) async throws -> Streak {
        try await Task.sleep(nanoseconds: 100_000_000)
        let key = "\(userId.uuidString)_\(sportId.uuidString)"

        if var existing = streaks[key] {
            let today = Calendar.current.startOfDay(for: Date())
            let lastActivity = Calendar.current.startOfDay(for: existing.lastActivityDate)

            if lastActivity == today {
                // Already logged today
                return existing
            } else if Calendar.current.isDateInYesterday(existing.lastActivityDate) {
                // Increment streak
                existing.currentStreak += 1
                existing.longestStreak = max(existing.longestStreak, existing.currentStreak)
                existing.lastActivityDate = Date()
                streaks[key] = existing
                return existing
            } else {
                // Reset streak
                existing.currentStreak = 1
                existing.lastActivityDate = Date()
                streaks[key] = existing
                return existing
            }
        } else {
            // Create new streak
            let newStreak = Streak(
                id: UUID(),
                userId: userId,
                sportId: sportId,
                currentStreak: 1,
                longestStreak: 1,
                lastActivityDate: Date(),
                freezeDaysAvailable: 0
            )
            streaks[key] = newStreak
            return newStreak
        }
    }
}
