//
//  LessonDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Lesson from Supabase
struct LessonDTO: Codable {
    let id: String
    let module_id: String
    let title: String
    let description: String?
    let order_index: Int
    let est_minutes: Int
    let xp_award: Int
    let prerequisite_lesson_id: String?
    let is_locked: Bool
    let created_at: String
    let updated_at: String
    let deleted_at: String?

    /// Convert DTO to Domain entity
    func toDomain(items: [Item] = []) throws -> Lesson {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let moduleUuid = UUID(uuidString: module_id) else {
            throw DTOConversionError.invalidUUID(field: "module_id", value: module_id)
        }

        return Lesson(
            id: uuid,
            moduleId: moduleUuid,
            title: title,
            description: description ?? "",
            orderIndex: order_index,
            estimatedMinutes: est_minutes,
            xpAward: xp_award,
            isLocked: is_locked,
            items: items // Items passed in or empty array
        )
    }
}

// MARK: - Domain to DTO Extension
extension Lesson {
    func toDTO() -> LessonDTO {
        LessonDTO(
            id: id.uuidString,
            module_id: moduleId.uuidString,
            title: title,
            description: description.isEmpty ? nil : description,
            order_index: orderIndex,
            est_minutes: estimatedMinutes,
            xp_award: xpAward,
            prerequisite_lesson_id: nil, // Not tracked in current domain model
            is_locked: isLocked,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date()),
            deleted_at: nil
        )
    }
}
