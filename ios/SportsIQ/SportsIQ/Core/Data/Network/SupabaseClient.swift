//
//  SupabaseClient.swift
//  SportsIQ
//
//  Supabase client service for database and API access
//  Created as part of Database Setup Task 3
//

import Foundation
import Supabase

/// Supabase client wrapper for database and API operations
///
/// This service provides a singleton instance of the Supabase client
/// configured with the project credentials from the Config file.
///
/// Usage:
/// ```swift
/// let sports = try await SupabaseService.shared.client
///     .from("sports")
///     .select()
///     .execute()
/// ```
@Observable
class SupabaseService {
    // MARK: - Singleton

    static let shared = SupabaseService()

    // MARK: - Properties

    /// The Supabase client instance
    let client: SupabaseClient

    // MARK: - Initialization

    /// Private initializer to enforce singleton pattern
    private init() {
        // Validate configuration
        guard let url = URL(string: Config.supabaseURL) else {
            fatalError("Invalid Supabase URL in configuration")
        }

        // Initialize Supabase client
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: Config.supabaseAnonKey
        )

        #if DEBUG
        print("✅ SupabaseService initialized")
        print("   URL: \(Config.supabaseURL)")
        #endif
    }

    // MARK: - Convenience Methods

    /// Test connection to Supabase by fetching sports
    /// - Throws: NetworkError if the request fails
    func testConnection() async throws {
        do {
            _ = try await client
                .from("sports")
                .select()
                .limit(1)
                .execute()

            #if DEBUG
            print("✅ Supabase connection test successful")
            #endif
        } catch {
            #if DEBUG
            print("❌ Supabase connection test failed: \(error)")
            #endif
            throw NetworkError.connectionFailed(error)
        }
    }

    // Authentication methods commented out until Task 8 (Authentication Integration)
    // Uncomment these when implementing authentication

    /*
    /// Get current authenticated user
    /// - Returns: Current user session, or nil if not authenticated
    func getCurrentUser() async -> Auth.User? {
        do {
            let session = try await client.auth.session
            return session.user
        } catch {
            #if DEBUG
            print("⚠️ No authenticated user: \(error)")
            #endif
            return nil
        }
    }

    /// Check if user is authenticated
    /// - Returns: True if user has valid session
    func isAuthenticated() async -> Bool {
        return await getCurrentUser() != nil
    }
    */
}

// MARK: - Testing Support

#if DEBUG
extension SupabaseService {
    /// Create a mock instance for testing (future use)
    /// Note: For now, this returns the real instance.
    /// In the future, we may want to support mock/test instances.
    static var mock: SupabaseService {
        return shared
    }
}
#endif
