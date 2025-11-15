//
//  MockUserRepository.swift
//  SportsIQ
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
}
