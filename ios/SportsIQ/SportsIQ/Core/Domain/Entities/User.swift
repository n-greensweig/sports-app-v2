//
//  User.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Represents a user of the app
struct User: Identifiable, Codable, Hashable {
    let id: UUID
    let externalId: String          // Legacy external auth ID (e.g. Clerk)
    let username: String
    let email: String
    let displayName: String?
    let avatarURL: String?
    let createdAt: Date
    let lastActiveAt: Date

    init(
        id: UUID,
        externalId: String,
        username: String,
        email: String,
        displayName: String? = nil,
        avatarURL: String? = nil,
        createdAt: Date = Date(),
        lastActiveAt: Date = Date()
    ) {
        self.id = id
        self.externalId = externalId
        self.username = username
        self.email = email
        self.displayName = displayName
        self.avatarURL = avatarURL
        self.createdAt = createdAt
        self.lastActiveAt = lastActiveAt
    }
}

// MARK: - Mock Data
extension User {
    static let mock = User(
        id: UUID(),
        externalId: "mock_external_123",
        username: "sports_fan_42",
        email: "fan@example.com",
        displayName: "Sports Fan"
    )
}
