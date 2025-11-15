//
//  Config.swift
//  SportsIQ
//
//  Configuration helper to access app credentials
//  Values are read from Secrets.swift (gitignored)
//

import Foundation

enum Config {
    /// Supabase project URL
    static var supabaseURL: String {
        return Secrets.supabaseURL
    }

    /// Supabase anonymous/public key for client-side requests
    static var supabaseAnonKey: String {
        return Secrets.supabaseAnonKey
    }

    /// Debug helper to verify configuration
    static func printConfiguration() {
        #if DEBUG
        print("🔧 Configuration loaded:")
        print("   Supabase URL: \(supabaseURL)")
        print("   Anon Key: \(String(supabaseAnonKey.prefix(20)))...")
        #endif
    }
}
