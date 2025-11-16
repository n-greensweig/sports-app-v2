//
//  LeaderboardDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Leaderboard from Supabase
struct LeaderboardDTO: Codable {
    let id: String
    let sport_id: String
    let window: String
    let window_start: String
    let window_end: String
    let rank: Int
    let user_id: String
    let xp: Int
    let created_at: String

    /// Convert DTO to Domain entity
    func toDomain(username: String, overallRating: Int) throws -> LeaderboardEntry {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }

        return LeaderboardEntry(
            id: uuid,
            userId: userUuid,
            username: username,
            xp: xp,
            overallRating: overallRating
        )
    }
}

// Note: LeaderboardEntry domain entity already exists elsewhere
// toDTO() method not implemented yet - will be added when domain model matches database schema
