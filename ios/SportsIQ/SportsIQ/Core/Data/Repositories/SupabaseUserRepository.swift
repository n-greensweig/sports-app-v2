//
//  SupabaseUserRepository.swift
//  SportsIQ
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
