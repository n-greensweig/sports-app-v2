//
//  AuthService.swift
//  Ola Ball
//
//  Created by Claude on 2025-11-17.
//  Task 8: Authentication Integration
//

import Foundation
import Supabase
import AuthenticationServices

/// Authentication service using Supabase Auth
/// Supports Email/Password, Apple Sign In, and Google OAuth
@Observable
class AuthService {
    // MARK: - Properties

    /// Shared singleton instance
    static let shared = AuthService()

    /// Supabase client for authentication
    private let supabase: SupabaseClient

    /// Current authenticated user
    private(set) var currentUser: User?

    /// Current Supabase session
    private(set) var session: Supabase.Session?

    /// Authentication state (includes guest mode)
    var isAuthenticated: Bool {
        session != nil && currentUser != nil
    }

    /// Whether the app is currently in guest mode
    var isGuestMode: Bool {
        GuestSessionManager.shared.isGuestMode
    }

    /// Guest user (synthetic user for guest sessions)
    var guestUser: User? {
        guard isGuestMode else { return nil }
        return GuestSessionManager.shared.getGuestUser()
    }

    /// Loading state
    private(set) var isLoading = false

    // MARK: - Initialization

    private init() {
        self.supabase = SupabaseService.shared.client

        // Check for existing session on init
        Task {
            await loadCurrentSession()
        }
    }

    // MARK: - Session Management

    /// Load the current session from Supabase
    @MainActor
    func loadCurrentSession() async {
        do {
            // Get current session
            let session = try await supabase.auth.session
            self.session = session

            // Fetch user profile from database
            let userId = session.user.id
            await fetchUserProfile(userId: userId)

            print("✅ Session loaded successfully")
        } catch {
            print("ℹ️ No existing session found: \(error.localizedDescription)")
            self.session = nil
            self.currentUser = nil
        }
    }

    /// Listen to authentication state changes
    func setupAuthStateListener() {
        Task {
            for await state in supabase.auth.authStateChanges {
                await handleAuthStateChange(state.event, session: state.session)
            }
        }
    }

    @MainActor
    private func handleAuthStateChange(_ event: AuthChangeEvent, session: Supabase.Session?) async {
        print("🔐 Auth state changed: \(event)")

        self.session = session

        switch event {
        case .signedIn, .tokenRefreshed:
            if let session = session {
                let userId = session.user.id
                await fetchUserProfile(userId: userId)
            }
        case .signedOut:
            self.currentUser = nil
        case .userUpdated:
            if let session = session {
                let userId = session.user.id
                await fetchUserProfile(userId: userId)
            }
        default:
            break
        }
    }

    // MARK: - Email/Password Authentication

    /// Sign up with email and password
    @MainActor
    func signUp(email: String, password: String, username: String) async throws -> User {
        isLoading = true
        defer { isLoading = false }

        // Check if we're converting from guest mode
        let wasGuestMode = isGuestMode

        do {
            // Sign up with Supabase Auth
            let authResponse = try await supabase.auth.signUp(
                email: email,
                password: password
            )

            let userId = authResponse.user.id

            // Create user profile in database
            let newUser = try await createUserProfile(
                id: userId,
                email: email,
                username: username
            )

            self.session = authResponse.session
            self.currentUser = newUser

            // Migrate guest data if converting from guest mode
            if wasGuestMode {
                await migrateGuestData(to: userId)
            }

            print("✅ User signed up successfully: \(username)")
            return newUser

        } catch let error as AuthError {
            print("❌ Sign up failed: \(error.localizedDescription)")
            throw error
        } catch {
            print("❌ Sign up failed: \(error.localizedDescription)")
            throw AuthError.signUpFailed
        }
    }

    /// Migrate guest data to a new authenticated user
    private func migrateGuestData(to userId: UUID) async {
        do {
            let migrationService = GuestDataMigrationService()
            try await migrationService.migrateToAuthenticatedUser(
                guestUserId: GuestSessionManager.shared.guestUserId,
                newUserId: userId
            )
            // Clear guest session after successful migration
            GuestSessionManager.shared.endGuestSession()
            print("✅ Guest data migrated successfully")
        } catch {
            // Migration failure shouldn't block account creation
            print("⚠️ Guest data migration failed: \(error)")
            // Still clear guest session
            GuestSessionManager.shared.endGuestSession()
        }
    }

    /// Sign in with email and password
    @MainActor
    func signIn(email: String, password: String) async throws -> User {
        isLoading = true
        defer { isLoading = false }

        // If signing into existing account, discard guest data (per user preference)
        if isGuestMode {
            GuestSessionManager.shared.endGuestSession()
            print("ℹ️ Guest data discarded - signing into existing account")
        }

        do {
            // Sign in with Supabase Auth
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )

            let userId = session.user.id

            self.session = session

            // Fetch user profile from database
            await fetchUserProfile(userId: userId)

            guard let user = currentUser else {
                throw AuthError.userNotFound
            }

            print("✅ User signed in successfully: \(user.username)")
            return user

        } catch let error as AuthError {
            print("❌ Sign in failed: \(error.localizedDescription)")
            throw error
        } catch {
            print("❌ Sign in failed: \(error.localizedDescription)")
            throw AuthError.signInFailed
        }
    }

    /// Sign out current user
    @MainActor
    func signOut() async throws {
        isLoading = true
        defer { isLoading = false }

        // Handle guest mode sign out
        if isGuestMode {
            GuestSessionManager.shared.endGuestSession()
            print("✅ Guest session ended")
            return
        }

        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.currentUser = nil
            print("✅ User signed out successfully")
        } catch {
            print("❌ Sign out failed: \(error.localizedDescription)")
            throw AuthError.signOutFailed
        }
    }

    // MARK: - Guest Mode

    /// Continue as a guest user (no account required)
    @MainActor
    func continueAsGuest() {
        GuestSessionManager.shared.startGuestSession()
        print("✅ Continuing as guest")
    }

    /// Sign out guest and clear all local data
    @MainActor
    func signOutGuest() {
        GuestSessionManager.shared.endGuestSession()
        print("✅ Guest signed out, data cleared")
    }

    // MARK: - Social Authentication

    /// Sign in with Apple
    @MainActor
    func signInWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws -> User {
        isLoading = true
        defer { isLoading = false }

        guard let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            throw AuthError.invalidAppleCredential
        }

        do {
            // Sign in with Apple via Supabase
            let session = try await supabase.auth.signInWithIdToken(
                credentials: .init(
                    provider: .apple,
                    idToken: tokenString,
                    nonce: nonce
                )
            )

            let userId = session.user.id

            self.session = session

            // Check if user profile exists, if not create one
            await fetchUserProfile(userId: userId)

            if currentUser == nil {
                // Create user profile for new Apple sign-in
                let username = credential.fullName?.givenName ?? "User\(userId.uuidString.prefix(8))"
                let email = credential.email ?? session.user.email ?? ""

                let newUser = try await createUserProfile(
                    id: userId,
                    email: email,
                    username: username
                )

                self.currentUser = newUser
            }

            guard let user = currentUser else {
                throw AuthError.userNotFound
            }

            print("✅ User signed in with Apple: \(user.username)")
            return user

        } catch let error as AuthError {
            print("❌ Apple sign in failed: \(error.localizedDescription)")
            throw error
        } catch {
            print("❌ Apple sign in failed: \(error.localizedDescription)")
            throw AuthError.appleSignInFailed
        }
    }

    /// Sign in with Google
    /// Note: Requires Google Sign-In SDK integration
    @MainActor
    func signInWithGoogle(idToken: String, nonce: String) async throws -> User {
        isLoading = true
        defer { isLoading = false }

        do {
            // Sign in with Google via Supabase
            let session = try await supabase.auth.signInWithIdToken(
                credentials: .init(
                    provider: .google,
                    idToken: idToken,
                    nonce: nonce
                )
            )

            let userId = session.user.id

            self.session = session

            // Check if user profile exists, if not create one
            await fetchUserProfile(userId: userId)

            if currentUser == nil {
                // Check if user already exists in database by email to avoid duplicate key error
                // This can happen if Auth created the user but our local profile fetch failed previously
                let email = session.user.email ?? ""
                
                let existingUser: UserDTO? = try? await supabase
                    .from("users")
                    .select()
                    .eq("email", value: email)
                    .single()
                    .execute()
                    .value
                
                if let existing = existingUser {
                    // User exists, just link it
                    print("ℹ️ User already exists in database, linking profile...")
                    await fetchUserProfile(userId: UUID(uuidString: existing.id)!)
                } else {
                    // Create user profile for new Google sign-in
                    let username = email.components(separatedBy: "@").first ?? "User\(userId.uuidString.prefix(8))"
    
                    let newUser = try await createUserProfile(
                        id: userId,
                        email: email,
                        username: username
                    )
    
                    self.currentUser = newUser
                }
            }

            guard let user = currentUser else {
                throw AuthError.userNotFound
            }

            print("✅ User signed in with Google: \(user.username)")
            return user

        } catch let error as AuthError {
            print("❌ Google sign in failed: \(error.localizedDescription)")
            throw error
        } catch {
            print("❌ Google sign in failed: \(error.localizedDescription)")
            // Throw the original error to see details in UI
            throw error
        }
    }

    // MARK: - Password Reset

    /// Send password reset email
    func resetPassword(email: String) async throws {
        do {
            try await supabase.auth.resetPasswordForEmail(email)
            print("✅ Password reset email sent to: \(email)")
        } catch {
            print("❌ Password reset failed: \(error.localizedDescription)")
            throw AuthError.passwordResetFailed
        }
    }

    /// Update password (when user is signed in)
    func updatePassword(newPassword: String) async throws {
        guard isAuthenticated else {
            throw AuthError.notAuthenticated
        }

        do {
            try await supabase.auth.update(user: UserAttributes(password: newPassword))
            print("✅ Password updated successfully")
        } catch {
            print("❌ Password update failed: \(error.localizedDescription)")
            throw AuthError.passwordUpdateFailed
        }
    }

    // MARK: - User Profile Management

    /// Fetch user profile from database
    @MainActor
    private func fetchUserProfile(userId: UUID) async {
        do {
            let userDTO: UserDTO = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
                .value

            // Fetch user profile separately
            let profileDTO: UserProfileDTO? = try? await supabase
                .from("user_profiles")
                .select()
                .eq("user_id", value: userId.uuidString)
                .single()
                .execute()
                .value

            self.currentUser = try userDTO.toDomain(profile: profileDTO)
            print("✅ User profile fetched: \(currentUser?.username ?? "Unknown")")

        } catch {
            print("❌ Failed to fetch user profile: \(error.localizedDescription)")
        }
    }

    /// Create user profile in database
    private func createUserProfile(id: UUID, email: String, username: String) async throws -> User {
        let now = ISO8601DateFormatter().string(from: Date())

        // Create user record
        let newUserDTO = UserDTO(
            id: id.uuidString,
            // The database has NOT NULL and UNIQUE constraints on this legacy column (formerly for Clerk).
            // We generate a unique dummy value to satisfy both.
            clerk_user_id: "google_\(id.uuidString)",
            email: email,
            role: "user",
            status: "active",
            created_at: now,
            updated_at: now,
            deleted_at: nil
        )

        let createdUserDTO: UserDTO = try await supabase
            .from("users")
            .insert(newUserDTO)
            .select()
            .single()
            .execute()
            .value

        // Create user profile
        let profileDTO = UserProfileDTO(
            user_id: id.uuidString,
            display_name: username,
            username: username,
            avatar_url: nil,
            bio: nil,
            country: nil,
            timezone: TimeZone.current.identifier,
            birth_year: nil,
            favorite_team_id: nil,
            notification_preferences: [:],
            privacy_settings: [:],
            created_at: now,
            updated_at: now
        )

        let createdProfileDTO: UserProfileDTO = try await supabase
            .from("user_profiles")
            .insert(profileDTO)
            .select()
            .single()
            .execute()
            .value

        // Create initial user_progress records for each sport
        try await createInitialProgressRecords(userId: id)

        print("✅ User profile created in database: \(username)")

        return try createdUserDTO.toDomain(profile: createdProfileDTO)
    }

    /// Create initial user_progress records for all sports
    private func createInitialProgressRecords(userId: UUID) async throws {
        // Fetch all active sports
        let sports: [SportDTO] = try await supabase
            .from("sports")
            .select()
            .eq("is_active", value: true)
            .execute()
            .value

        let now = ISO8601DateFormatter().string(from: Date())

        // Create progress record for each sport
        let progressRecords = sports.compactMap { sport -> UserProgressDTO? in
            guard let sportId = UUID(uuidString: sport.id) else { return nil }

            return UserProgressDTO(
                id: UUID().uuidString,
                user_id: userId.uuidString,
                sport_id: sportId.uuidString,
                level: 1,
                overall_rating: 0,
                current_module_id: nil,
                current_lesson_id: nil,
                total_xp: 0,
                lessons_completed: 0,
                live_answers: 0,
                concepts_mastered: 0,
                last_active_at: nil,
                created_at: now,
                updated_at: now
            )
        }

        if !progressRecords.isEmpty {
            let _: [UserProgressDTO] = try await supabase
                .from("user_progress")
                .insert(progressRecords)
                .select()
                .execute()
                .value

            print("✅ Created initial progress records for \(progressRecords.count) sports")
        }
    }

    /// Update user profile
    @MainActor
    func updateUserProfile(displayName: String?, bio: String?, location: String?, avatarUrl: String?) async throws {
        guard let userId = currentUser?.id else {
            throw AuthError.notAuthenticated
        }

        // Create an update struct with only the fields we want to update
        struct ProfileUpdate: Encodable {
            let display_name: String?
            let bio: String?
            let country: String?  // Using country instead of location
            let avatar_url: String?
            let updated_at: String

            init(displayName: String?, bio: String?, country: String?, avatarUrl: String?) {
                self.display_name = displayName
                self.bio = bio
                self.country = country
                self.avatar_url = avatarUrl
                self.updated_at = ISO8601DateFormatter().string(from: Date())
            }
        }

        let update = ProfileUpdate(
            displayName: displayName,
            bio: bio,
            country: location,
            avatarUrl: avatarUrl
        )

        let _: UserProfileDTO = try await supabase
            .from("user_profiles")
            .update(update)
            .eq("user_id", value: userId.uuidString)
            .select()
            .single()
            .execute()
            .value

        // Refresh user profile
        await fetchUserProfile(userId: userId)

        print("✅ User profile updated")
    }

    // MARK: - Account Deletion

    /// Delete the current user's account and all associated data
    @MainActor
    func deleteAccount() async throws {
        guard let userId = currentUser?.id else {
            throw AuthError.notAuthenticated
        }

        let userIdString = userId.uuidString
        isLoading = true
        defer { isLoading = false }

        do {
            // Delete user data from app tables (order matters due to foreign keys)
            // Tables with foreign key dependencies on other user tables are deleted first

            // Delete SRS cards (srs_reviews should CASCADE delete)
            try? await supabase.from("srs_cards")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            // Delete submissions (submission_judgments should CASCADE delete)
            try? await supabase.from("submissions")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            // Delete progress and completion data
            try? await supabase.from("user_lesson_completions")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            try? await supabase.from("user_item_stats")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            try? await supabase.from("user_xp_events")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            try? await supabase.from("streaks")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            try? await supabase.from("user_badges")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            try? await supabase.from("user_progress")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            // Delete test-out data
            try? await supabase.from("test_out_attempts")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            // Delete sessions and analytics
            try? await supabase.from("analytics_events")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            try? await supabase.from("sessions")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            // Delete social data
            try? await supabase.from("friends")
                .delete()
                .or("user_id.eq.\(userIdString),friend_user_id.eq.\(userIdString)")
                .execute()

            try? await supabase.from("devices")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            // Delete live mode data
            try? await supabase.from("live_prompt_windows")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            // Delete user profile
            try? await supabase.from("user_profiles")
                .delete()
                .eq("user_id", value: userIdString)
                .execute()

            // Delete the user record
            try await supabase.from("users")
                .delete()
                .eq("id", value: userIdString)
                .execute()

            // Sign out from Supabase Auth
            try await supabase.auth.signOut()

            self.session = nil
            self.currentUser = nil

            print("✅ Account deleted successfully")

        } catch {
            print("❌ Account deletion failed: \(error.localizedDescription)")
            throw AuthError.deleteAccountFailed
        }
    }

    // MARK: - Helper Methods

    /// Get current user ID
    var currentUserId: UUID? {
        currentUser?.id
    }

    /// Get authentication token
    func getAccessToken() async throws -> String {
        guard let session = session else {
            throw AuthError.notAuthenticated
        }

        return session.accessToken
    }

    // MARK: - Deep Link Handling

    /// Handle authentication callback from deep link
    /// Used for email verification, password reset, etc.
    @MainActor
    func handleAuthCallback(from url: URL) async throws {
        do {
            // Let Supabase handle the session from the URL
            try await supabase.auth.session(from: url)

            // Reload the current session to update our state
            await loadCurrentSession()

            print("✅ Email confirmed and session created!")
        } catch {
            print("❌ Failed to handle auth callback: \(error.localizedDescription)")
            throw AuthError.signInFailed
        }
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case signUpFailed
    case signInFailed
    case signOutFailed
    case userNotFound
    case invalidAppleCredential
    case appleSignInFailed
    case googleSignInFailed
    case passwordResetFailed
    case passwordUpdateFailed
    case notAuthenticated
    case invalidCredentials
    case deleteAccountFailed

    var errorDescription: String? {
        switch self {
        case .signUpFailed:
            return "Failed to create account. Please try again."
        case .signInFailed:
            return "Failed to sign in. Please check your credentials."
        case .signOutFailed:
            return "Failed to sign out. Please try again."
        case .userNotFound:
            return "User profile not found."
        case .invalidAppleCredential:
            return "Invalid Apple Sign In credentials."
        case .appleSignInFailed:
            return "Apple Sign In failed. Please try again."
        case .googleSignInFailed:
            return "Google Sign In failed. Please try again."
        case .passwordResetFailed:
            return "Failed to send password reset email."
        case .passwordUpdateFailed:
            return "Failed to update password."
        case .notAuthenticated:
            return "You must be signed in to perform this action."
        case .invalidCredentials:
            return "Invalid email or password."
        case .deleteAccountFailed:
            return "Failed to delete account. Please try again or contact support."
        }
    }
}
