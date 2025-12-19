//
//  LocalDataStore.swift
//  Ola Ball
//
//  Created on 2025-12-18.
//  Guest Mode Implementation - Local JSON storage for guest progress
//

import Foundation

/// Centralized local storage for guest user data using JSON files
class LocalDataStore {
    // MARK: - Singleton

    static let shared = LocalDataStore()

    // MARK: - Storage Keys

    enum StorageKey: String {
        case userProgress = "guest_user_progress"
        case lessonCompletions = "guest_lesson_completions"
        case streak = "guest_streak"
        case xpEvents = "guest_xp_events"
    }

    // MARK: - Properties

    private let fileManager = FileManager.default
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let queue = DispatchQueue(label: "com.olaball.localdatastore", qos: .userInitiated)

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("GuestData", isDirectory: true)
    }

    // MARK: - Initialization

    private init() {
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        // Ensure guest data directory exists
        createDirectoryIfNeeded()
    }

    // MARK: - Directory Management

    private func createDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: documentsDirectory.path) {
            do {
                try fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
            } catch {
                print("❌ Failed to create guest data directory: \(error)")
            }
        }
    }

    private func fileURL(for key: String) -> URL {
        documentsDirectory.appendingPathComponent("\(key).json")
    }

    // MARK: - CRUD Operations

    /// Save a Codable object to local storage
    func save<T: Codable>(_ object: T, forKey key: StorageKey) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try self.encoder.encode(object)
                let url = self.fileURL(for: key.rawValue)
                try data.write(to: url, options: .atomic)
                print("✅ Saved \(key.rawValue) to local storage")
            } catch {
                print("❌ Failed to save \(key.rawValue): \(error)")
            }
        }
    }

    /// Save synchronously (for critical operations)
    func saveSync<T: Codable>(_ object: T, forKey key: StorageKey) throws {
        let data = try encoder.encode(object)
        let url = fileURL(for: key.rawValue)
        try data.write(to: url, options: .atomic)
    }

    /// Load a Codable object from local storage
    func load<T: Codable>(forKey key: StorageKey, as type: T.Type) -> T? {
        let url = fileURL(for: key.rawValue)

        guard fileManager.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print("❌ Failed to load \(key.rawValue): \(error)")
            return nil
        }
    }

    /// Delete data for a specific key
    func delete(forKey key: StorageKey) {
        queue.async { [weak self] in
            guard let self = self else { return }
            let url = self.fileURL(for: key.rawValue)

            if self.fileManager.fileExists(atPath: url.path) {
                do {
                    try self.fileManager.removeItem(at: url)
                    print("✅ Deleted \(key.rawValue) from local storage")
                } catch {
                    print("❌ Failed to delete \(key.rawValue): \(error)")
                }
            }
        }
    }

    /// Clear all guest data
    func clearAll() {
        queue.async { [weak self] in
            guard let self = self else { return }

            if self.fileManager.fileExists(atPath: self.documentsDirectory.path) {
                do {
                    try self.fileManager.removeItem(at: self.documentsDirectory)
                    self.createDirectoryIfNeeded()
                    print("✅ Cleared all guest data")
                } catch {
                    print("❌ Failed to clear guest data: \(error)")
                }
            }
        }
    }

    /// Check if data exists for a key
    func exists(forKey key: StorageKey) -> Bool {
        let url = fileURL(for: key.rawValue)
        return fileManager.fileExists(atPath: url.path)
    }
}
