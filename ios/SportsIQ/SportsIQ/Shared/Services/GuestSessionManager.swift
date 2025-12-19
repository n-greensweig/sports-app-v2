//
//  GuestSessionManager.swift
//  Ola Ball
//
//  Created on 2025-12-18.
//  Guest Mode Implementation - Apple Guideline 5.1.1 Compliance
//

import Foundation

/// Manages guest session state and data for users who haven't created an account
@Observable
class GuestSessionManager {
    // MARK: - Singleton

    static let shared = GuestSessionManager()

    // MARK: - UserDefaults Keys

    private static let isGuestModeKey = "isGuestMode"
    private static let guestUserIdKey = "guestUserId"

    // MARK: - Properties

    /// Whether the app is currently in guest mode
    private(set) var isGuestMode: Bool {
        didSet {
            UserDefaults.standard.set(isGuestMode, forKey: Self.isGuestModeKey)
        }
    }

    /// Unique ID for the guest user (used to key local data)
    private(set) var guestUserId: UUID

    // MARK: - Initialization

    private init() {
        // Load persisted guest mode state
        self.isGuestMode = UserDefaults.standard.bool(forKey: Self.isGuestModeKey)

        // Load or generate guest user ID
        if let storedIdString = UserDefaults.standard.string(forKey: Self.guestUserIdKey),
           let storedId = UUID(uuidString: storedIdString) {
            self.guestUserId = storedId
        } else {
            let newId = UUID()
            self.guestUserId = newId
            UserDefaults.standard.set(newId.uuidString, forKey: Self.guestUserIdKey)
        }
    }

    // MARK: - Session Management

    /// Start a guest session
    @MainActor
    func startGuestSession() {
        isGuestMode = true
        #if DEBUG
        print("✅ Guest session started with ID: \(guestUserId)")
        #endif
    }

    /// End the guest session and clear all local data
    @MainActor
    func endGuestSession() {
        // Clear all local guest data
        LocalDataStore.shared.clearAll()

        // Generate a new guest ID for next time
        let newId = UUID()
        guestUserId = newId
        UserDefaults.standard.set(newId.uuidString, forKey: Self.guestUserIdKey)

        // Disable guest mode
        isGuestMode = false

        #if DEBUG
        print("✅ Guest session ended, data cleared")
        #endif
    }

    /// Get a synthetic User object for the guest
    func getGuestUser() -> User {
        User(
            id: guestUserId,
            externalId: "guest_\(guestUserId.uuidString)",
            username: "Guest",
            email: "",
            displayName: "Guest",
            avatarURL: nil,
            createdAt: Date(),
            lastActiveAt: Date()
        )
    }
}
