//
//  UserItemStatsDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for UserItemStats from Supabase
struct UserItemStatsDTO: Codable {
    let id: String
    let user_id: String
    let item_id: String
    let seen_count: Int
    let correct_count: Int
    let streak_correct: Int
    let last_seen_at: String?
    let easiness_factor: Double
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> UserItemStats {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }
        guard let itemUuid = UUID(uuidString: item_id) else {
            throw DTOConversionError.invalidUUID(field: "item_id", value: item_id)
        }

        var lastSeenDate: Date? = nil
        if let lastSeen = last_seen_at {
            lastSeenDate = ISO8601DateFormatter().date(from: lastSeen)
        }

        return UserItemStats(
            id: uuid,
            userId: userUuid,
            itemId: itemUuid,
            seenCount: seen_count,
            correctCount: correct_count,
            streakCorrect: streak_correct,
            lastSeenAt: lastSeenDate,
            easinessFactor: easiness_factor
        )
    }
}

/// Domain entity for UserItemStats (if not already defined)
struct UserItemStats: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let itemId: UUID
    let seenCount: Int
    let correctCount: Int
    let streakCorrect: Int
    let lastSeenAt: Date?
    let easinessFactor: Double
}

// MARK: - Domain to DTO Extension
extension UserItemStats {
    func toDTO() -> UserItemStatsDTO {
        UserItemStatsDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            item_id: itemId.uuidString,
            seen_count: seenCount,
            correct_count: correctCount,
            streak_correct: streakCorrect,
            last_seen_at: lastSeenAt != nil ? ISO8601DateFormatter().string(from: lastSeenAt!) : nil,
            easiness_factor: easinessFactor,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
