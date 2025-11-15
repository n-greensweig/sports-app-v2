//
//  XPEvent.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Source of XP award
enum XPSource: String, Codable {
    case lessonItem = "lesson_item"
    case lessonComplete = "lesson_complete"
    case lessonPerfect = "lesson_perfect"
    case liveAnswer = "live_answer"
    case reviewItem = "review_item"
    case dailyStreak = "daily_streak"
    case weeklyStreak = "weekly_streak"
    case moduleComplete = "module_complete"
    case badgeEarned = "badge_earned"

    var baseXP: Int {
        switch self {
        case .lessonItem: return 10
        case .lessonComplete: return 20
        case .lessonPerfect: return 50
        case .liveAnswer: return 15
        case .reviewItem: return 5
        case .dailyStreak: return 25
        case .weeklyStreak: return 100
        case .moduleComplete: return 200
        case .badgeEarned: return 50
        }
    }
}

/// XP event tracking individual XP awards
struct XPEvent: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let sportId: UUID?
    let source: XPSource
    let amount: Int
    let timestamp: Date
    let relatedItemId: UUID? // Lesson, Module, etc.
}

/// Streak tracking
struct Streak: Codable {
    let userId: UUID
    let sportId: UUID
    let currentStreak: Int
    let longestStreak: Int
    let lastActivityDate: Date

    func isActiveToday() -> Bool {
        Calendar.current.isDateInToday(lastActivityDate) ||
        Calendar.current.isDateInYesterday(lastActivityDate)
    }

    func shouldIncrementStreak() -> Bool {
        Calendar.current.isDateInYesterday(lastActivityDate)
    }
}

/// Daily Goal tracking
struct DailyGoal: Codable {
    let userId: UUID
    let sportId: UUID
    let date: Date
    let xpGoal: Int
    let xpEarned: Int
    let lessonsGoal: Int
    let lessonsCompleted: Int

    var isXPGoalMet: Bool {
        xpEarned >= xpGoal
    }

    var isLessonsGoalMet: Bool {
        lessonsCompleted >= lessonsGoal
    }

    var isComplete: Bool {
        isXPGoalMet && isLessonsGoalMet
    }

    var xpProgress: Double {
        guard xpGoal > 0 else { return 0 }
        return min(Double(xpEarned) / Double(xpGoal), 1.0)
    }

    var lessonsProgress: Double {
        guard lessonsGoal > 0 else { return 0 }
        return min(Double(lessonsCompleted) / Double(lessonsGoal), 1.0)
    }
}

// MARK: - Mock Data
extension DailyGoal {
    static let mockGoal = DailyGoal(
        userId: UUID(),
        sportId: Sport.football.id,
        date: Date(),
        xpGoal: 100,
        xpEarned: 65,
        lessonsGoal: 3,
        lessonsCompleted: 2
    )
}

extension Streak {
    static let mockStreak = Streak(
        userId: UUID(),
        sportId: Sport.football.id,
        currentStreak: 7,
        longestStreak: 14,
        lastActivityDate: Date()
    )
}
