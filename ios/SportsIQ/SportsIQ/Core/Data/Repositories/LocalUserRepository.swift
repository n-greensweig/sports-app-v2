//
//  LocalUserRepository.swift
//  Ola Ball
//
//  Created on 2025-12-18.
//  Guest Mode Implementation - Local storage implementation of UserRepository
//

import Foundation

/// Local storage implementation of UserRepository for guest users
/// All data is stored locally on the device using JSON files
final class LocalUserRepository: UserRepository {
    // MARK: - Properties

    private let localDataStore: LocalDataStore
    private let guestUserId: UUID

    // MARK: - Initialization

    init(guestUserId: UUID, localDataStore: LocalDataStore = .shared) {
        self.guestUserId = guestUserId
        self.localDataStore = localDataStore
    }

    // MARK: - UserRepository

    func getCurrentUser() async throws -> User? {
        GuestSessionManager.shared.getGuestUser()
    }

    func getUser(id: UUID) async throws -> User? {
        guard id == guestUserId else { return nil }
        return GuestSessionManager.shared.getGuestUser()
    }

    func updateUser(_ user: User) async throws -> User {
        // Guest users can't update their profile
        return user
    }

    func getUserProgress(userId: UUID, sportId: UUID) async throws -> UserProgress? {
        guard userId == guestUserId else { return nil }

        guard let localProgress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self),
              localProgress.sportId == sportId else {
            return nil
        }

        // Get streak data to include in progress
        var progress = localProgress.toDomain()

        if let localStreak = localDataStore.load(forKey: .streak, as: LocalStreak.self),
           localStreak.sportId == sportId {
            // Create a new progress with streak info
            progress = UserProgress(
                id: progress.id,
                userId: progress.userId,
                sportId: progress.sportId,
                totalXP: progress.totalXP,
                overallRating: progress.overallRating,
                lessonsCompleted: progress.lessonsCompleted,
                currentStreak: localStreak.currentDays,
                longestStreak: localStreak.longestDays,
                totalAnswered: progress.totalAnswered,
                totalCorrect: progress.totalCorrect,
                lastActivityAt: progress.lastActivityAt
            )
        }

        return progress
    }

    func updateUserProgress(_ progress: UserProgress) async throws -> UserProgress {
        let localProgress = LocalUserProgress.from(progress)
        localDataStore.save(localProgress, forKey: .userProgress)
        return progress
    }

    // MARK: - Streak Management

    func getStreak(userId: UUID, sportId: UUID) async throws -> Streak? {
        guard userId == guestUserId else { return nil }

        guard let localStreak = localDataStore.load(forKey: .streak, as: LocalStreak.self),
              localStreak.sportId == sportId else {
            return nil
        }

        return localStreak.toDomain()
    }

    func updateStreak(userId: UUID, sportId: UUID) async throws -> Streak {
        let existing = try await getStreak(userId: userId, sportId: sportId)
        let today = Calendar.current.startOfDay(for: Date())

        if let streak = existing {
            let lastActivity = Calendar.current.startOfDay(for: streak.lastActivityDate)

            if lastActivity == today {
                // Already logged today, return unchanged
                return streak
            } else if Calendar.current.isDateInYesterday(streak.lastActivityDate) {
                // Consecutive day - increment
                return incrementStreak(streak)
            } else {
                // Streak broken - reset
                return resetStreak(streak)
            }
        } else {
            // First time - create streak
            return createStreak(userId: userId, sportId: sportId)
        }
    }

    // MARK: - Private Streak Helpers

    private func createStreak(userId: UUID, sportId: UUID) -> Streak {
        let streak = Streak(
            id: UUID(),
            userId: userId,
            sportId: sportId,
            currentStreak: 1,
            longestStreak: 1,
            lastActivityDate: Date(),
            freezeDaysAvailable: 0
        )

        let localStreak = LocalStreak.from(streak)
        localDataStore.save(localStreak, forKey: .streak)

        return streak
    }

    private func incrementStreak(_ streak: Streak) -> Streak {
        let newCurrentDays = streak.currentStreak + 1
        let newLongestDays = max(streak.longestStreak, newCurrentDays)

        let updatedStreak = Streak(
            id: streak.id,
            userId: streak.userId,
            sportId: streak.sportId,
            currentStreak: newCurrentDays,
            longestStreak: newLongestDays,
            lastActivityDate: Date(),
            freezeDaysAvailable: streak.freezeDaysAvailable
        )

        let localStreak = LocalStreak.from(updatedStreak)
        localDataStore.save(localStreak, forKey: .streak)

        return updatedStreak
    }

    private func resetStreak(_ streak: Streak) -> Streak {
        let updatedStreak = Streak(
            id: streak.id,
            userId: streak.userId,
            sportId: streak.sportId,
            currentStreak: 1,
            longestStreak: streak.longestStreak,
            lastActivityDate: Date(),
            freezeDaysAvailable: streak.freezeDaysAvailable
        )

        let localStreak = LocalStreak.from(updatedStreak)
        localDataStore.save(localStreak, forKey: .streak)

        return updatedStreak
    }

    // MARK: - Progress Helpers

    /// Create initial progress for a sport (called when guest starts learning)
    func createInitialProgress(sportId: UUID) -> UserProgress {
        let progress = UserProgress(
            id: UUID(),
            userId: guestUserId,
            sportId: sportId,
            totalXP: 0,
            overallRating: 0,
            lessonsCompleted: 0,
            currentStreak: 0,
            longestStreak: 0,
            totalAnswered: 0,
            totalCorrect: 0,
            lastActivityAt: Date()
        )

        let localProgress = LocalUserProgress.from(progress)
        localDataStore.save(localProgress, forKey: .userProgress)

        return progress
    }

    /// Increment XP for guest user
    func addXP(_ amount: Int, sportId: UUID) async throws {
        var localProgress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self)

        if localProgress == nil || localProgress?.sportId != sportId {
            // Create initial progress
            _ = createInitialProgress(sportId: sportId)
            localProgress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self)
        }

        if var progress = localProgress {
            progress.totalXP += amount
            progress.lastActiveAt = Date()
            localDataStore.save(progress, forKey: .userProgress)
        }
    }

    /// Increment lesson completion count
    func incrementLessonsCompleted(sportId: UUID) async throws {
        var localProgress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self)

        if localProgress == nil || localProgress?.sportId != sportId {
            // Create initial progress
            _ = createInitialProgress(sportId: sportId)
            localProgress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self)
        }

        if var progress = localProgress {
            progress.lessonsCompleted += 1
            progress.lastActiveAt = Date()
            localDataStore.save(progress, forKey: .userProgress)
        }
    }

    /// Update answer statistics
    func updateAnswerStats(correct: Bool, sportId: UUID) async throws {
        var localProgress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self)

        if localProgress == nil || localProgress?.sportId != sportId {
            // Create initial progress
            _ = createInitialProgress(sportId: sportId)
            localProgress = localDataStore.load(forKey: .userProgress, as: LocalUserProgress.self)
        }

        if var progress = localProgress {
            progress.totalAnswered += 1
            if correct {
                progress.totalCorrect += 1
            }
            progress.lastActiveAt = Date()
            localDataStore.save(progress, forKey: .userProgress)
        }
    }
}
