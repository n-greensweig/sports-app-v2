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
import CryptoKit

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
        let rawNonce = randomNonceString()
        let hashedNonce = sha256(rawNonce)
        
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
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
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
