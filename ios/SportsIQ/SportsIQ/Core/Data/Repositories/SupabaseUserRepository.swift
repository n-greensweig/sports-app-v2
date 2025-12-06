//
//  SupabaseUserRepository.swift
//  Ola Ball
//
//  Created for Database Setup Task 6
//

import Foundation
import Supabase

/// Concrete implementation of `UserRepository` backed by Supabase
///
/// This repository handles all user-related operations including user profiles,
/// progress tracking, XP history, badges, and streaks.
final class SupabaseUserRepository: UserRepository {
    // MARK: - Nested Types

    private struct CacheEntry<Value> {
        let value: Value
        let expiration: Date

        var isExpired: Bool { Date() > expiration }
    }

    // MARK: - Properties

    private let client: SupabaseClient
    private let cacheTTL: TimeInterval = 60 * 5 // 5 minutes
    private let maxRetries = 2
    private let initialRetryDelay: TimeInterval = 0.5

    private var currentUserCache: CacheEntry<User>?
    private var userCache: [UUID: CacheEntry<User>] = [:]
    private var progressCache: [String: CacheEntry<UserProgress>] = [:] // Key: "userId_sportId"

    private let cacheLock = NSLock()

    // MARK: - Initialization

    init(client: SupabaseClient = SupabaseService.shared.client) {
        self.client = client
    }

    // MARK: - UserRepository

    func getCurrentUser() async throws -> User? {
        // Get current user from AuthService
        let authService = AuthService.shared
        return authService.currentUser
    }

    func getUser(id: UUID) async throws -> User? {
        #if DEBUG
        print("🔄 SupabaseUserRepository.getUser(\(id))")
        #endif

        if let cached = cachedUser(id: id) {
            #if DEBUG
            print("✅ Returning user from cache")
            #endif
            return cached
        }

        #if DEBUG
        print("🌐 Fetching user from Supabase...")
        #endif

        return try await executeWithRetry { () -> User? in
            let response = try await self.client
                .from("users")
                .select()
                .eq("id", value: id.uuidString)
                .limit(1)
                .execute()

            let dtos: [UserDTO] = try self.decode(response.data, as: [UserDTO].self)

            guard let dto = dtos.first else {
                #if DEBUG
                print("❌ User not found")
                #endif
                return nil
            }

            // TODO: Fetch user profile separately when needed
            let user = try dto.toDomain(profile: nil)

            #if DEBUG
            print("✅ User fetched: \(user.username)")
            #endif

            self.cacheUser(user)
            return user
        }
    }

    func updateUser(_ user: User) async throws -> User {
        #if DEBUG
        print("🔄 SupabaseUserRepository.updateUser(\(user.id))")
        #endif

        return try await executeWithRetry {
            let dto = user.toDTO()

            let response = try await self.client
                .from("users")
                .update(dto)
                .eq("id", value: user.id.uuidString)
                .select()
                .limit(1)
                .execute()

            let dtos: [UserDTO] = try self.decode(response.data, as: [UserDTO].self)

            guard let updatedDTO = dtos.first else {
                throw NetworkError.noData
            }

            // TODO: Fetch user profile separately when needed
            let updatedUser = try updatedDTO.toDomain(profile: nil)

            #if DEBUG
            print("✅ User updated successfully")
            #endif

            self.cacheUser(updatedUser)
            return updatedUser
        }
    }

    func getUserProgress(userId: UUID, sportId: UUID) async throws -> UserProgress? {
        #if DEBUG
        print("🔄 SupabaseUserRepository.getUserProgress(user: \(userId), sport: \(sportId))")
        #endif

        let cacheKey = "\(userId.uuidString)_\(sportId.uuidString)"

        if let cached = cachedProgress(key: cacheKey) {
            #if DEBUG
            print("✅ Returning progress from cache")
            #endif
            return cached
        }

        #if DEBUG
        print("🌐 Fetching user progress from Supabase...")
        #endif

        return try await executeWithRetry { () -> UserProgress? in
            let response = try await self.client
                .from("user_progress")
                .select()
                .eq("user_id", value: userId.uuidString)
                .eq("sport_id", value: sportId.uuidString)
                .limit(1)
                .execute()

            let dtos: [UserProgressDTO] = try self.decode(response.data, as: [UserProgressDTO].self)

            guard let dto = dtos.first else {
                #if DEBUG
                print("❌ User progress not found")
                #endif
                return nil
            }

            let progress = try dto.toDomain()

            #if DEBUG
            print("✅ User progress fetched: Rating \(progress.overallRating), \(progress.totalXP) XP")
            #endif

            self.cacheProgress(progress, key: cacheKey)
            return progress
        }
    }

    func updateUserProgress(_ progress: UserProgress) async throws -> UserProgress {
        #if DEBUG
        print("🔄 SupabaseUserRepository.updateUserProgress(user: \(progress.userId), sport: \(progress.sportId))")
        #endif

        return try await executeWithRetry {
            let dto = progress.toDTO()

            let response = try await self.client
                .from("user_progress")
                .update(dto)
                .eq("user_id", value: progress.userId.uuidString)
                .eq("sport_id", value: progress.sportId.uuidString)
                .select()
                .limit(1)
                .execute()

            let dtos: [UserProgressDTO] = try self.decode(response.data, as: [UserProgressDTO].self)

            guard let updatedDTO = dtos.first else {
                throw NetworkError.noData
            }

            let updatedProgress = try updatedDTO.toDomain()

            #if DEBUG
            print("✅ User progress updated successfully")
            #endif

            let cacheKey = "\(progress.userId.uuidString)_\(progress.sportId.uuidString)"
            self.cacheProgress(updatedProgress, key: cacheKey)

            return updatedProgress
        }
    }

    // MARK: - Cache Helpers

    private func cachedUser(id: UUID) -> User? {
        cacheLock.lock(); defer { cacheLock.unlock() }
        guard let cache = userCache[id] else { return nil }
        if cache.isExpired {
            userCache.removeValue(forKey: id)
            return nil
        }
        return cache.value
    }

    private func cacheUser(_ user: User) {
        cacheLock.lock(); defer { cacheLock.unlock() }
        userCache[user.id] = CacheEntry(value: user, expiration: Date().addingTimeInterval(cacheTTL))
    }

    private func cachedProgress(key: String) -> UserProgress? {
        cacheLock.lock(); defer { cacheLock.unlock() }
        guard let cache = progressCache[key] else { return nil }
        if cache.isExpired {
            progressCache.removeValue(forKey: key)
            return nil
        }
        return cache.value
    }

    private func cacheProgress(_ progress: UserProgress, key: String) {
        cacheLock.lock(); defer { cacheLock.unlock() }
        progressCache[key] = CacheEntry(value: progress, expiration: Date().addingTimeInterval(cacheTTL))
    }
    
    func invalidateProgressCache(userId: UUID, sportId: UUID) {
        let cacheKey = "\(userId.uuidString)_\(sportId.uuidString)"
        cacheLock.lock(); defer { cacheLock.unlock() }
        progressCache.removeValue(forKey: cacheKey)
        print("🗑️ Invalidated progress cache for user: \(userId), sport: \(sportId)")
    }

    // MARK: - Streak Management

    func getStreak(userId: UUID, sportId: UUID) async throws -> Streak? {
        #if DEBUG
        print("🔄 SupabaseUserRepository.getStreak(user: \(userId), sport: \(sportId))")
        #endif

        return try await executeWithRetry { () -> Streak? in
            let response = try await self.client
                .from("streaks")
                .select()
                .eq("user_id", value: userId.uuidString)
                .eq("sport_id", value: sportId.uuidString)
                .limit(1)
                .execute()

            let dtos: [StreakDTO] = try self.decode(response.data, as: [StreakDTO].self)

            guard let dto = dtos.first else {
                #if DEBUG
                print("❌ No streak found")
                #endif
                return nil
            }

            let streak = try dto.toDomain()
            #if DEBUG
            print("✅ Streak fetched: \(streak.currentStreak) days")
            #endif
            return streak
        }
    }

    func updateStreak(userId: UUID, sportId: UUID) async throws -> Streak {
        #if DEBUG
        print("🔄 SupabaseUserRepository.updateStreak(user: \(userId), sport: \(sportId))")
        #endif

        let existing = try await getStreak(userId: userId, sportId: sportId)
        let today = Calendar.current.startOfDay(for: Date())

        if let streak = existing {
            let lastActivity = Calendar.current.startOfDay(for: streak.lastActivityDate)

            if lastActivity == today {
                // Already logged today, return unchanged
                #if DEBUG
                print("✅ Already logged today, streak unchanged: \(streak.currentStreak)")
                #endif
                return streak
            } else if Calendar.current.isDateInYesterday(streak.lastActivityDate) {
                // Consecutive day - increment
                return try await incrementStreak(streak)
            } else {
                // Streak broken - reset
                #if DEBUG
                print("⚠️ Streak broken, resetting to 1")
                #endif
                return try await resetStreak(streak)
            }
        } else {
            // First time - create streak
            return try await createStreak(userId: userId, sportId: sportId)
        }
    }

    private func createStreak(userId: UUID, sportId: UUID) async throws -> Streak {
        #if DEBUG
        print("🔄 Creating new streak for user: \(userId)")
        #endif

        let payload = StreakInsertPayload(
            user_id: userId.uuidString,
            sport_id: sportId.uuidString,
            current_days: 1,
            longest_days: 1,
            last_checkin_date: formatDate(Date()),
            freeze_days_available: 0
        )

        let response = try await client
            .from("streaks")
            .insert(payload)
            .select()
            .limit(1)
            .execute()

        let dtos: [StreakDTO] = try decode(response.data, as: [StreakDTO].self)
        guard let dto = dtos.first else {
            throw NetworkError.noData
        }

        let streak = try dto.toDomain()
        #if DEBUG
        print("✅ Created new streak with 1 day")
        #endif
        return streak
    }

    private func incrementStreak(_ streak: Streak) async throws -> Streak {
        let newCurrentDays = streak.currentStreak + 1
        let newLongestDays = max(streak.longestStreak, newCurrentDays)

        #if DEBUG
        print("🔄 Incrementing streak from \(streak.currentStreak) to \(newCurrentDays)")
        #endif

        let payload = StreakUpdatePayload(
            current_days: newCurrentDays,
            longest_days: newLongestDays,
            last_checkin_date: formatDate(Date())
        )

        let response = try await client
            .from("streaks")
            .update(payload)
            .eq("id", value: streak.id.uuidString)
            .select()
            .limit(1)
            .execute()

        let dtos: [StreakDTO] = try decode(response.data, as: [StreakDTO].self)
        guard let dto = dtos.first else {
            throw NetworkError.noData
        }

        let updatedStreak = try dto.toDomain()
        #if DEBUG
        print("✅ Streak incremented to \(newCurrentDays) days")
        #endif
        return updatedStreak
    }

    private func resetStreak(_ streak: Streak) async throws -> Streak {
        let payload = StreakUpdatePayload(
            current_days: 1,
            longest_days: streak.longestStreak,
            last_checkin_date: formatDate(Date())
        )

        let response = try await client
            .from("streaks")
            .update(payload)
            .eq("id", value: streak.id.uuidString)
            .select()
            .limit(1)
            .execute()

        let dtos: [StreakDTO] = try decode(response.data, as: [StreakDTO].self)
        guard let dto = dtos.first else {
            throw NetworkError.noData
        }

        let updatedStreak = try dto.toDomain()
        #if DEBUG
        print("⚠️ Streak reset to 1 day (was broken)")
        #endif
        return updatedStreak
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // MARK: - Networking Helpers

    private func executeWithRetry<T>(_ operation: @escaping () async throws -> T) async throws -> T {
        var attempt = 0
        var delay = initialRetryDelay
        var lastError: NetworkError?

        while attempt <= maxRetries {
            do {
                return try await operation()
            } catch {
                let networkError = mapError(error)
                lastError = networkError

                guard networkError.isRetryable, attempt < maxRetries else {
                    throw networkError
                }

                let nanoseconds = UInt64(delay * Double(NSEC_PER_SEC))
                try await Task.sleep(nanoseconds: nanoseconds)
                attempt += 1
                delay *= 2
            }
        }

        throw lastError ?? .unknown(NSError(domain: "Supabase", code: -1))
    }

    private func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .connectionFailed(urlError)
            case .timedOut:
                return .timeout
            default:
                return .connectionFailed(urlError)
            }
        }

        return .unknown(error)
    }

    private func decode<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        return try ResponseParser.decode(type, from: data)
    }
}

// MARK: - NSLock Convenience

private extension NSLock {
    func withLock<T>(_ block: () -> T) -> T {
        lock()
        defer { unlock() }
        return block()
    }
}

// MARK: - Streak Payload Types

private struct StreakInsertPayload: Encodable {
    let user_id: String
    let sport_id: String
    let current_days: Int
    let longest_days: Int
    let last_checkin_date: String
    let freeze_days_available: Int
}

private struct StreakUpdatePayload: Encodable {
    let current_days: Int
    let longest_days: Int
    let last_checkin_date: String
}
