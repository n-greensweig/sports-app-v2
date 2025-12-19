//
//  Config.swift
//  Ola Ball
//
//  Configuration helper to access app credentials
//  Values are read from environment variables first, with fallback to Secrets.swift (gitignored)
//

import Foundation

enum Config {
    /// Supabase project URL
    /// Reads from SUPABASE_URL environment variable, falls back to Secrets.swift for local development
    static var supabaseURL: String {
        ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? Secrets.supabaseURL
    }

    /// Supabase anonymous/public key for client-side requests
    /// Reads from SUPABASE_ANON_KEY environment variable, falls back to Secrets.swift for local development
    static var supabaseAnonKey: String {
        ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? Secrets.supabaseAnonKey
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
