//
//  GuestDataMigrationService.swift
//  Ola Ball
//
//  Created on 2025-12-18.
//  Guest Mode Implementation - Migrates guest data to authenticated account
//

import Foundation
import Supabase

/// Service responsible for migrating guest user data to a newly created authenticated account
class GuestDataMigrationService {
    // MARK: - Properties

    private let localDataStore: LocalDataStore
    private let supabaseClient: SupabaseClient

    // MARK: - Initialization

    init(
        localDataStore: LocalDataStore = .shared,
        supabaseClient: SupabaseClient = SupabaseService.shared.client
    ) {
        self.localDataStore = localDataStore
        self.supabaseClient = supabaseClient
    }

    // MARK: - Migration

    /// Migrate all guest data to an authenticated user account
    /// - Parameters:
    ///   - guestUserId: The UUID that was used for the guest session
    ///   - newUserId: The UUID of the newly created authenticated user
    func migrateToAuthenticatedUser(guestUserId: UUID, newUserId: UUID) async throws {
        #if DEBUG
        print("🔄 Starting guest data migration from \(guestUserId) to \(newUserId)")
        #endif

        // 1. Migrate user progress
        if let localProgress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self) {
            try await migrateProgress(localProgress, to: newUserId)
        }

        // 2. Migrate lesson completions
        if let completions = localDataStore.load(forKey: .lessonCompletions, as: LocalLessonCompletionsContainer.self) {
            try await migrateCompletions(completions, to: newUserId)
        }

        // 3. Migrate streak
        if let localStreak = localDataStore.load(forKey: .streak, as: LocalStreak.self) {
            try await migrateStreak(localStreak, to: newUserId)
        }

        // 4. Migrate XP events
        if let xpEvents = localDataStore.load(forKey: .xpEvents, as: LocalXPEventsContainer.self) {
            try await migrateXPEvents(xpEvents, to: newUserId)
        }

        #if DEBUG
        print("✅ Guest data migration completed successfully")
        #endif
    }

    // MARK: - Private Migration Methods

    private func migrateProgress(_ localProgress: LocalUserProgress, to userId: UUID) async throws {
        let nowString = ISO8601DateFormatter().string(from: Date())

        struct UserProgressPayload: Encodable {
            let user_id: String
            let sport_id: String
            let level: Int
            let overall_rating: Int
            let total_xp: Int
            let lessons_completed: Int
            let live_answers: Int
            let concepts_mastered: Int
            let last_active_at: String
        }

        let payload = UserProgressPayload(
            user_id: userId.uuidString,
            sport_id: localProgress.sportId.uuidString,
            level: 1,
            overall_rating: localProgress.overallRating,
            total_xp: localProgress.totalXP,
            lessons_completed: localProgress.lessonsCompleted,
            live_answers: 0,
            concepts_mastered: 0,
            last_active_at: nowString
        )

        // Upsert - update if exists (from AuthService initial creation), insert if not
        _ = try await supabaseClient
            .from("user_progress")
            .upsert(payload, onConflict: "user_id,sport_id")
            .execute()

        #if DEBUG
        print("✅ Migrated user progress: \(localProgress.totalXP) XP, \(localProgress.lessonsCompleted) lessons")
        #endif
    }

    private func migrateCompletions(_ container: LocalLessonCompletionsContainer, to userId: UUID) async throws {
        guard !container.completions.isEmpty else { return }

        struct CompletionPayload: Encodable {
            let user_id: String
            let lesson_id: String
            let completion_count: Int
            let last_completed_at: String
        }

        let nowString = ISO8601DateFormatter().string(from: Date())
        var payloads: [CompletionPayload] = []

        for (lessonIdString, completion) in container.completions {
            let payload = CompletionPayload(
                user_id: userId.uuidString,
                lesson_id: lessonIdString,
                completion_count: completion.completionCount,
                last_completed_at: ISO8601DateFormatter().string(from: completion.lastCompletedAt)
            )
            payloads.append(payload)
        }

        // Insert all completions (use upsert to handle potential conflicts)
        _ = try await supabaseClient
            .from("user_lesson_completions")
            .upsert(payloads, onConflict: "user_id,lesson_id")
            .execute()

        #if DEBUG
        print("✅ Migrated \(payloads.count) lesson completions")
        #endif
    }

    private func migrateStreak(_ localStreak: LocalStreak, to userId: UUID) async throws {
        struct StreakPayload: Encodable {
            let user_id: String
            let sport_id: String
            let current_days: Int
            let longest_days: Int
            let last_checkin_date: String
            let freeze_days_available: Int
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let payload = StreakPayload(
            user_id: userId.uuidString,
            sport_id: localStreak.sportId.uuidString,
            current_days: localStreak.currentDays,
            longest_days: localStreak.longestDays,
            last_checkin_date: dateFormatter.string(from: localStreak.lastCheckinDate),
            freeze_days_available: localStreak.freezeDaysAvailable
        )

        _ = try await supabaseClient
            .from("streaks")
            .upsert(payload, onConflict: "user_id,sport_id")
            .execute()

        #if DEBUG
        print("✅ Migrated streak: \(localStreak.currentDays) days")
        #endif
    }

    private func migrateXPEvents(_ container: LocalXPEventsContainer, to userId: UUID) async throws {
        guard !container.events.isEmpty else { return }

        struct XPEventPayload: Encodable {
            let user_id: String
            let sport_id: String?
            let source: String
            let amount: Int
        }

        let payloads = container.events.map { event in
            XPEventPayload(
                user_id: userId.uuidString,
                sport_id: event.sportId?.uuidString,
                source: event.source,
                amount: event.amount
            )
        }

        // Insert XP events (don't upsert - these are append-only)
        _ = try await supabaseClient
            .from("user_xp_events")
            .insert(payloads)
            .execute()

        #if DEBUG
        print("✅ Migrated \(payloads.count) XP events")
        #endif
    }

    // MARK: - Summary

    /// Get a summary of guest data for display before migration
    func getMigrationSummary() -> GuestDataSummary {
        let progress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self)
        let streak = localDataStore.load(forKey: .streak, as: LocalStreak.self)

        return GuestDataSummary(
            totalXP: progress?.totalXP ?? 0,
            lessonsCompleted: progress?.lessonsCompleted ?? 0,
            currentStreak: streak?.currentDays ?? 0,
            totalAnswered: progress?.totalAnswered ?? 0
        )
    }
}
