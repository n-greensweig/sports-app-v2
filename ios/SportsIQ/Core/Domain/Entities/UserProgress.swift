//
//  UserProgress.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Tracks user's progress in a specific sport
struct UserProgress: Identifiable, Codable, Hashable {
    let id: UUID
    let userId: UUID
    let sportId: UUID
    let totalXP: Int
    let overallRating: Int          // 0-99
    let lessonsCompleted: Int
    let currentStreak: Int          // Days
    let longestStreak: Int
    let totalAnswered: Int
    let totalCorrect: Int
    let lastActivityAt: Date

    var accuracyPercentage: Double {
        guard totalAnswered > 0 else { return 0 }
        return (Double(totalCorrect) / Double(totalAnswered)) * 100
    }

    init(
        id: UUID = UUID(),
        userId: UUID,
        sportId: UUID,
        totalXP: Int = 0,
        overallRating: Int = 0,
        lessonsCompleted: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        totalAnswered: Int = 0,
        totalCorrect: Int = 0,
        lastActivityAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.sportId = sportId
        self.totalXP = totalXP
        self.overallRating = overallRating
        self.lessonsCompleted = lessonsCompleted
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.totalAnswered = totalAnswered
        self.totalCorrect = totalCorrect
        self.lastActivityAt = lastActivityAt
    }
}

// MARK: - Mock Data
extension UserProgress {
    static let mock = UserProgress(
        userId: User.mock.id,
        sportId: Sport.football.id,
        totalXP: 450,
        overallRating: 32,
        lessonsCompleted: 3,
        currentStreak: 5,
        longestStreak: 12,
        totalAnswered: 24,
        totalCorrect: 20
    )
}
