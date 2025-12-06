//
//  XPEvent.swift
//  Ola Ball
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

/// Celebration intensity levels for milestones
enum CelebrationIntensity {
    case low
    case medium
    case high
    case extreme

    var particleCount: Int {
        switch self {
        case .low: return 30
        case .medium: return 50
        case .high: return 80
        case .extreme: return 120
        }
    }
}

/// Streak milestone thresholds
enum StreakMilestone: Int, CaseIterable {
    case fiveDays = 5
    case oneWeek = 7
    case twoWeeks = 14
    case oneMonth = 30
    case fiftyDays = 50
    case hundredDays = 100
    case oneYear = 365

    var title: String {
        switch self {
        case .fiveDays: return "5 Day Streak!"
        case .oneWeek: return "1 Week Streak!"
        case .twoWeeks: return "2 Week Streak!"
        case .oneMonth: return "1 Month Streak!"
        case .fiftyDays: return "50 Day Streak!"
        case .hundredDays: return "100 Day Streak!"
        case .oneYear: return "1 Year Streak!"
        }
    }

    var celebrationMessage: String {
        switch self {
        case .fiveDays: return "You're building a great habit!"
        case .oneWeek: return "A full week of learning!"
        case .twoWeeks: return "Two weeks strong!"
        case .oneMonth: return "Incredible dedication!"
        case .fiftyDays: return "You're unstoppable!"
        case .hundredDays: return "Triple digits - legendary!"
        case .oneYear: return "A whole year - you're a true champion!"
        }
    }

    var celebrationIntensity: CelebrationIntensity {
        switch self {
        case .fiveDays: return .low
        case .oneWeek: return .medium
        case .twoWeeks: return .medium
        case .oneMonth: return .high
        case .fiftyDays: return .high
        case .hundredDays: return .extreme
        case .oneYear: return .extreme
        }
    }
}

/// Streak tracking
struct Streak: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let sportId: UUID
    var currentStreak: Int
    var longestStreak: Int
    var lastActivityDate: Date
    var freezeDaysAvailable: Int

    func isActiveToday() -> Bool {
        Calendar.current.isDateInToday(lastActivityDate) ||
        Calendar.current.isDateInYesterday(lastActivityDate)
    }

    func shouldIncrementStreak() -> Bool {
        Calendar.current.isDateInYesterday(lastActivityDate)
    }

    /// Check if current streak is a milestone
    var isMilestone: Bool {
        StreakMilestone.allCases.map(\.rawValue).contains(currentStreak)
    }

    /// Get the milestone type if current streak is a milestone
    var milestoneType: StreakMilestone? {
        StreakMilestone(rawValue: currentStreak)
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
        id: UUID(),
        userId: UUID(),
        sportId: Sport.football.id,
        currentStreak: 7,
        longestStreak: 14,
        lastActivityDate: Date(),
        freezeDaysAvailable: 0
    )
}
