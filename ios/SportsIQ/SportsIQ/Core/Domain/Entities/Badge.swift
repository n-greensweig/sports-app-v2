//
//  Badge.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Types of badges that can be earned
enum BadgeType: String, Codable {
    case firstLesson = "first_lesson"
    case perfectScore = "perfect_score"
    case weekStreak = "week_streak"
    case monthStreak = "month_streak"
    case moduleComplete = "module_complete"
    case sportMaster = "sport_master"
    case liveExpert = "live_expert"
    case earlyBird = "early_bird"
    case nightOwl = "night_owl"
    case speedster = "speedster"
    case perfectWeek = "perfect_week"
}

/// Badge that can be earned by users
struct Badge: Identifiable, Codable, Hashable {
    let id: UUID
    let type: BadgeType
    let name: String
    let description: String
    let iconName: String
    let rarity: BadgeRarity
    let requirement: String

    enum BadgeRarity: String, Codable {
        case common
        case rare
        case epic
        case legendary

        var colorHex: String {
            switch self {
            case .common: return "#9E9E9E"
            case .rare: return "#2196F3"
            case .epic: return "#9C27B0"
            case .legendary: return "#FF9800"
            }
        }
    }
}

/// User's earned badge with timestamp
struct UserBadge: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let badge: Badge
    let earnedAt: Date
    let sportId: UUID?

    init(id: UUID = UUID(), userId: UUID, badge: Badge, earnedAt: Date = Date(), sportId: UUID? = nil) {
        self.id = id
        self.userId = userId
        self.badge = badge
        self.earnedAt = earnedAt
        self.sportId = sportId
    }
}

// MARK: - Mock Data
extension Badge {
    static let firstLesson = Badge(
        id: UUID(),
        type: .firstLesson,
        name: "First Steps",
        description: "Complete your first lesson",
        iconName: "figure.walk",
        rarity: .common,
        requirement: "Complete 1 lesson"
    )

    static let perfectScore = Badge(
        id: UUID(),
        type: .perfectScore,
        name: "Perfectionist",
        description: "Get 100% on a lesson",
        iconName: "star.fill",
        rarity: .rare,
        requirement: "Score 100% on any lesson"
    )

    static let weekStreak = Badge(
        id: UUID(),
        type: .weekStreak,
        name: "Week Warrior",
        description: "Maintain a 7-day streak",
        iconName: "flame.fill",
        rarity: .rare,
        requirement: "Learn for 7 days in a row"
    )

    static let moduleComplete = Badge(
        id: UUID(),
        type: .moduleComplete,
        name: "Module Master",
        description: "Complete an entire module",
        iconName: "checkmark.seal.fill",
        rarity: .epic,
        requirement: "Complete all lessons in a module"
    )

    static let sportMaster = Badge(
        id: UUID(),
        type: .sportMaster,
        name: "Sport Expert",
        description: "Complete all modules for a sport",
        iconName: "trophy.fill",
        rarity: .legendary,
        requirement: "Complete all modules in one sport"
    )

    static let liveExpert = Badge(
        id: UUID(),
        type: .liveExpert,
        name: "Live Game Expert",
        description: "Answer 50 live game questions correctly",
        iconName: "bolt.fill",
        rarity: .epic,
        requirement: "50 correct answers in live mode"
    )

    static let mockBadges = [
        firstLesson,
        perfectScore,
        weekStreak,
        moduleComplete,
        sportMaster,
        liveExpert
    ]
}
