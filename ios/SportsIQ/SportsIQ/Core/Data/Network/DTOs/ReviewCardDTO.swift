//
//  ReviewCardDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for SRS Card from Supabase
struct SRSCardDTO: Codable {
    let id: String
    let user_id: String
    let item_id: String
    let variant_id: String
    let sport_id: String
    let due_at: String
    let interval_days: Double
    let ease_factor: Double
    let repetitions: Int
    let lapses: Int
    let last_reviewed_at: String?
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> ReviewCard {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }
        guard let itemUuid = UUID(uuidString: item_id) else {
            throw DTOConversionError.invalidUUID(field: "item_id", value: item_id)
        }
        guard let sportUuid = UUID(uuidString: sport_id) else {
            throw DTOConversionError.invalidUUID(field: "sport_id", value: sport_id)
        }

        guard let dueDate = ISO8601DateFormatter().date(from: due_at) else {
            throw DTOConversionError.invalidDate(field: "due_at", value: due_at)
        }

        guard let createdDate = ISO8601DateFormatter().date(from: created_at) else {
            throw DTOConversionError.invalidDate(field: "created_at", value: created_at)
        }

        var lastReviewedDate: Date? = nil
        if let lastReviewed = last_reviewed_at {
            lastReviewedDate = ISO8601DateFormatter().date(from: lastReviewed)
        }

        // Convert interval_days (Double) to interval (TimeInterval in seconds)
        let intervalSeconds = interval_days * 86400 // days to seconds

        return ReviewCard(
            id: uuid,
            userId: userUuid,
            itemId: itemUuid,
            sportId: sportUuid,
            dueDate: dueDate,
            interval: intervalSeconds,
            easeFactor: ease_factor,
            repetitions: repetitions,
            createdAt: createdDate,
            lastReviewedAt: lastReviewedDate
        )
    }
}

/// Data Transfer Object for SRS Review from Supabase
struct SRSReviewDTO: Codable {
    let id: String
    let card_id: String
    let submission_id: String
    let reviewed_at: String
    let grade: Int
    let new_interval_days: Double
    let new_ease_factor: Double
    let new_due_at: String
    let created_at: String
}

// MARK: - Domain to DTO Extension
extension ReviewCard {
    func toDTO() -> SRSCardDTO {
        // Convert interval (TimeInterval in seconds) to interval_days (Double)
        let intervalDays = interval / 86400 // seconds to days

        return SRSCardDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            item_id: itemId.uuidString,
            variant_id: itemId.uuidString, // Using itemId as variant for now
            sport_id: sportId.uuidString,
            due_at: ISO8601DateFormatter().string(from: dueDate),
            interval_days: intervalDays,
            ease_factor: easeFactor,
            repetitions: repetitions,
            lapses: 0, // Not tracked in current domain model
            last_reviewed_at: lastReviewedAt != nil ? ISO8601DateFormatter().string(from: lastReviewedAt!) : nil,
            created_at: ISO8601DateFormatter().string(from: createdAt),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
