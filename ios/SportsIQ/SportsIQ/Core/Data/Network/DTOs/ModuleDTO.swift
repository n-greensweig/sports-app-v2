//
//  ModuleDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Module from Supabase
struct ModuleDTO: Codable {
    let id: String
    let sport_id: String
    let title: String
    let description: String?
    let order_index: Int
    let min_level: Int
    let max_level: Int
    let icon_name: String?
    let xp_reward: Int
    let release_id: String?
    let created_at: String
    let updated_at: String
    let deleted_at: String?

    /// Convert DTO to Domain entity
    func toDomain(totalLessons: Int = 0, isLocked: Bool = true) throws -> Module {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let sportUuid = UUID(uuidString: sport_id) else {
            throw DTOConversionError.invalidUUID(field: "sport_id", value: sport_id)
        }

        return Module(
            id: uuid,
            sportId: sportUuid,
            title: title,
            description: description ?? "",
            orderIndex: order_index,
            estimatedMinutes: 0, // Will be calculated from lessons
            totalLessons: totalLessons,
            isLocked: isLocked
        )
    }
}

// MARK: - Domain to DTO Extension
extension Module {
    func toDTO() -> ModuleDTO {
        ModuleDTO(
            id: id.uuidString,
            sport_id: sportId.uuidString,
            title: title,
            description: description.isEmpty ? nil : description,
            order_index: orderIndex,
            min_level: 1,
            max_level: 4,
            icon_name: nil,
            xp_reward: 0,
            release_id: nil,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date()),
            deleted_at: nil
        )
    }
}
