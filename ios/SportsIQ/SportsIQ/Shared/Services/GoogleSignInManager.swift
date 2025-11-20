//
//  GoogleSignInManager.swift
//  SportsIQ
//
//  Created on 2025-11-19.
//

import Foundation
import Foundation
import GoogleSignIn
import AuthenticationServices
// CryptoKit is now imported in CryptoUtils

/// Manager for Google Sign-In integration
class GoogleSignInManager: NSObject {
    static let shared = GoogleSignInManager()

    private override init() {}

    /// Sign in with Google and return the ID token and nonce
    /// - Returns: A tuple containing the ID token and the raw nonce
    @MainActor
    func signIn() async throws -> (idToken: String, nonce: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw GoogleSignInError.noRootViewController
        }
        
        // 1. Generate nonce
        let rawNonce = CryptoUtils.randomNonceString()
        let hashedNonce = CryptoUtils.sha256(rawNonce)
        
        // 2. Sign in with the hashed nonce
        // In Google Sign-In SDK v9+, the nonce is passed directly to the signIn method
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController,
            hint: nil,
            additionalScopes: nil,
            nonce: hashedNonce
        )
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw GoogleSignInError.noIdToken
        }

        return (idToken, rawNonce)
    }
    
    // MARK: - Helpers
    

}

enum GoogleSignInError: LocalizedError {
    case noRootViewController
    case noIdToken
    case configurationMissing

    var errorDescription: String? {
        switch self {
        case .noRootViewController:
            return "Could not find root view controller to present Google Sign-In."
        case .noIdToken:
            return "Could not retrieve ID token from Google Sign-In result."
        case .configurationMissing:
            return "Google Sign-In configuration is missing. Check Info.plist."
        }
    }
}
