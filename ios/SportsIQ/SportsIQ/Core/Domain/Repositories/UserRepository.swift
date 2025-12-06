//
//  UserRepository.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import Foundation

/// Protocol for user-related data operations
protocol UserRepository {
    /// Get current authenticated user
    func getCurrentUser() async throws -> User?

    /// Get user by ID
    func getUser(id: UUID) async throws -> User?

    /// Update user profile
    func updateUser(_ user: User) async throws -> User

    /// Get user's progress for a specific sport
    func getUserProgress(userId: UUID, sportId: UUID) async throws -> UserProgress?

    /// Update user progress
    func updateUserProgress(_ progress: UserProgress) async throws -> UserProgress

    // MARK: - Streak Management

    /// Get user's streak for a specific sport
    func getStreak(userId: UUID, sportId: UUID) async throws -> Streak?

    /// Update user's streak after completing a lesson
    /// - Returns: The updated streak (creates one if it doesn't exist)
    func updateStreak(userId: UUID, sportId: UUID) async throws -> Streak
}
