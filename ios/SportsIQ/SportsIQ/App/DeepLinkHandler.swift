//
//  DeepLinkHandler.swift
//  SportsIQ
//
//  Deep link handler for email confirmation and other auth flows
//

import SwiftUI

extension SportsIQApp {
    /// Handle incoming URLs (email confirmation, password reset, etc.)
    func handleIncomingURL(_ url: URL) {
        print("📱 Received URL: \(url)")

        // Check if this is a Supabase auth callback
        guard url.scheme == "com.sportsiq.app" || url.scheme == "sportsiq",
              url.host == "auth" || url.path.contains("auth") else {
            print("⚠️ URL is not an auth callback")
            return
        }

        // Handle the auth callback
        Task {
            do {
                // Use AuthService's public method to handle the callback
                try await AuthService.shared.handleAuthCallback(from: url)
            } catch {
                print("❌ Failed to handle auth callback: \(error)")
            }
        }
    }
}
