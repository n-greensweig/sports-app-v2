//
//  DeepLinkHandler.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import SwiftUI

extension OlaBallApp {
    /// Handle incoming URLs (email confirmation, password reset, etc.)
    func handleIncomingURL(_ url: URL) {
        print("📱 Received URL: \(url)")

        // Check if this is a Supabase auth callback
        guard url.scheme == "com.olaball.app" || url.scheme == "olaball",
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
