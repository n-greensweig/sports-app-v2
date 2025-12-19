//
//  LocalStorageModels.swift
//  Ola Ball
//
//  Created on 2025-12-18.
//  Guest Mode Implementation - Codable models for local JSON storage
//

import Foundation

// MARK: - Local User Progress

/// Local storage model for user progress in a sport
struct LocalUserProgress: Codable {
    let id: UUID
    let userId: UUID
    let sportId: UUID
    var totalXP: Int
    var overallRating: Int
    var lessonsCompleted: Int
    var totalAnswered: Int
    var totalCorrect: Int
    var lastActiveAt: Date

    /// Convert to domain entity
    func toDomain() -> UserProgress {
        UserProgress(
            id: id,
            userId: userId,
            sportId: sportId,
            totalXP: totalXP,
            overallRating: overallRating,
            lessonsCompleted: lessonsCompleted,
            currentStreak: 0, // Streak is stored separately
            longestStreak: 0,
            totalAnswered: totalAnswered,
            totalCorrect: totalCorrect,
            lastActivityAt: lastActiveAt
        )
    }

    /// Create from domain entity
    static func from(_ domain: UserProgress) -> LocalUserProgress {
        LocalUserProgress(
            id: domain.id,
            userId: domain.userId,
            sportId: domain.sportId,
            totalXP: domain.totalXP,
            overallRating: domain.overallRating,
            lessonsCompleted: domain.lessonsCompleted,
            totalAnswered: domain.totalAnswered,
            totalCorrect: domain.totalCorrect,
            lastActiveAt: domain.lastActivityAt
        )
    }
}

// MARK: - Local Lesson Completion

/// Local storage model for lesson completion tracking
struct LocalLessonCompletion: Codable {
    let lessonId: UUID
    var completionCount: Int
    var lastCompletedAt: Date
    var seenItemIds: [UUID]

    init(lessonId: UUID, completionCount: Int = 0, lastCompletedAt: Date = Date(), seenItemIds: [UUID] = []) {
        self.lessonId = lessonId
        self.completionCount = completionCount
        self.lastCompletedAt = lastCompletedAt
        self.seenItemIds = seenItemIds
    }
}

/// Container for all lesson completions (dictionary keyed by lessonId string)
struct LocalLessonCompletionsContainer: Codable {
    var completions: [String: LocalLessonCompletion]

    init(completions: [String: LocalLessonCompletion] = [:]) {
        self.completions = completions
    }

    /// Get completion for a lesson
    func getCompletion(for lessonId: UUID) -> LocalLessonCompletion? {
        completions[lessonId.uuidString]
    }

    /// Set completion for a lesson
    mutating func setCompletion(_ completion: LocalLessonCompletion) {
        completions[completion.lessonId.uuidString] = completion
    }

    /// Get completion count for a lesson
    func getCompletionCount(for lessonId: UUID) -> Int {
        completions[lessonId.uuidString]?.completionCount ?? 0
    }

    /// Get all completion counts as a dictionary
    func toCompletionCountDict() -> [UUID: Int] {
        var result: [UUID: Int] = [:]
        for (key, value) in completions {
            if let uuid = UUID(uuidString: key) {
                result[uuid] = value.completionCount
            }
        }
        return result
    }
}

// MARK: - Local Streak

/// Local storage model for streak tracking
struct LocalStreak: Codable {
    let id: UUID
    let userId: UUID
    let sportId: UUID
    var currentDays: Int
    var longestDays: Int
    var lastCheckinDate: Date
    var freezeDaysAvailable: Int

    /// Convert to domain entity
    func toDomain() -> Streak {
        Streak(
            id: id,
            userId: userId,
            sportId: sportId,
            currentStreak: currentDays,
            longestStreak: longestDays,
            lastActivityDate: lastCheckinDate,
            freezeDaysAvailable: freezeDaysAvailable
        )
    }

    /// Create from domain entity
    static func from(_ domain: Streak) -> LocalStreak {
        LocalStreak(
            id: domain.id,
            userId: domain.userId,
            sportId: domain.sportId,
            currentDays: domain.currentStreak,
            longestDays: domain.longestStreak,
            lastCheckinDate: domain.lastActivityDate,
            freezeDaysAvailable: domain.freezeDaysAvailable
        )
    }
}

// MARK: - Local XP Event

/// Local storage model for XP events
struct LocalXPEvent: Codable {
    let id: UUID
    let userId: UUID
    let sportId: UUID?
    let source: String
    let amount: Int
    let earnedAt: Date
    let relatedItemId: UUID?

    /// Convert to domain entity
    func toDomain() -> XPEvent? {
        guard let xpSource = XPSource(rawValue: source) else { return nil }
        return XPEvent(
            id: id,
            userId: userId,
            sportId: sportId,
            source: xpSource,
            amount: amount,
            timestamp: earnedAt,
            relatedItemId: relatedItemId
        )
    }

    /// Create from domain entity
    static func from(_ domain: XPEvent) -> LocalXPEvent {
        LocalXPEvent(
            id: domain.id,
            userId: domain.userId,
            sportId: domain.sportId,
            source: domain.source.rawValue,
            amount: domain.amount,
            earnedAt: domain.timestamp,
            relatedItemId: domain.relatedItemId
        )
    }
}

/// Container for XP events
struct LocalXPEventsContainer: Codable {
    var events: [LocalXPEvent]

    init(events: [LocalXPEvent] = []) {
        self.events = events
    }

    mutating func addEvent(_ event: LocalXPEvent) {
        events.append(event)
    }

    func totalXP(for sportId: UUID) -> Int {
        events.filter { $0.sportId == sportId }.reduce(0) { $0 + $1.amount }
    }
}

// MARK: - Guest Data Bundle (for migration)

/// Container for all guest data - used when migrating to a real account
struct GuestDataBundle: Codable {
    let progress: LocalUserProgress?
    let completions: LocalLessonCompletionsContainer
    let streak: LocalStreak?
    let xpEvents: LocalXPEventsContainer

    /// Get a summary of the guest data for display
    var summary: GuestDataSummary {
        GuestDataSummary(
            totalXP: progress?.totalXP ?? 0,
            lessonsCompleted: progress?.lessonsCompleted ?? 0,
            currentStreak: streak?.currentDays ?? 0,
            totalAnswered: progress?.totalAnswered ?? 0
        )
    }
}

/// Summary of guest data for UI display
struct GuestDataSummary {
    let totalXP: Int
    let lessonsCompleted: Int
    let currentStreak: Int
    let totalAnswered: Int

    var hasProgress: Bool {
        totalXP > 0 || lessonsCompleted > 0 || currentStreak > 0
    }
}
