//
//  BadgeDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Badge from Supabase
struct BadgeDTO: Codable {
    let id: String
    let slug: String
    let name: String
    let description: String?
    let criteria_json: [String: AnyCodable]
    let sport_id: String?
    let icon_asset: String?
    let order_index: Int
    let is_active: Bool
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> Badge {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }

        // Try to parse BadgeType from slug
        guard let badgeType = BadgeType(rawValue: slug) else {
            throw DTOConversionError.invalidEnum(field: "slug", value: slug)
        }

        // Parse rarity from criteria_json or default to common
        let rarity: Badge.BadgeRarity
        if let rarityStr = criteria_json["rarity"]?.value as? String,
           let parsedRarity = Badge.BadgeRarity(rawValue: rarityStr) {
            rarity = parsedRarity
        } else {
            rarity = .common
        }

        return Badge(
            id: uuid,
            type: badgeType,
            name: name,
            description: description ?? "",
            iconName: icon_asset ?? "star.fill",
            rarity: rarity,
            requirement: description ?? ""
        )
    }
}

/// Data Transfer Object for UserBadge from Supabase
struct UserBadgeDTO: Codable {
    let id: String
    let user_id: String
    let badge_id: String
    let awarded_at: String

    /// Convert DTO to Domain entity
    func toDomain(badge: Badge) throws -> UserBadge {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }

        guard let earnedDate = ISO8601DateFormatter().date(from: awarded_at) else {
            throw DTOConversionError.invalidDate(field: "awarded_at", value: awarded_at)
        }

        return UserBadge(
            id: uuid,
            userId: userUuid,
            badge: badge,
            earnedAt: earnedDate,
            sportId: nil // Not tracked in DTO currently
        )
    }
}

// Note: Badge and UserBadge domain entities are already defined in Badge.swift
// toDTO() methods not implemented yet - will be added when domain models match database schema
