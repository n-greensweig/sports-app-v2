//
//  UserProgressDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for UserProgress from Supabase
struct UserProgressDTO: Codable {
    let id: String
    let user_id: String
    let sport_id: String
    let level: Int
    let overall_rating: Int
    let current_module_id: String?
    let current_lesson_id: String?
    let total_xp: Int
    let lessons_completed: Int
    let live_answers: Int
    let concepts_mastered: Int
    let last_active_at: String?
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> UserProgress {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }
        guard let sportUuid = UUID(uuidString: sport_id) else {
            throw DTOConversionError.invalidUUID(field: "sport_id", value: sport_id)
        }

        let lastActiveDate: Date
        if let lastActive = last_active_at {
            lastActiveDate = ISO8601DateFormatter().date(from: lastActive) ?? Date()
        } else {
            lastActiveDate = Date()
        }

        return UserProgress(
            id: uuid,
            userId: userUuid,
            sportId: sportUuid,
            totalXP: total_xp,
            overallRating: overall_rating,
            lessonsCompleted: lessons_completed,
            currentStreak: 0, // Not tracked in DB DTO currently
            longestStreak: 0, // Not tracked in DB DTO currently
            totalAnswered: live_answers, // Using live_answers as approximation
            totalCorrect: 0, // Not tracked in DB DTO currently
            lastActivityAt: lastActiveDate
        )
    }
}

// MARK: - Domain to DTO Extension
extension UserProgress {
    func toDTO() -> UserProgressDTO {
        UserProgressDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            sport_id: sportId.uuidString,
            level: 1, // Default level, not tracked in current domain model
            overall_rating: overallRating,
            current_module_id: nil, // Not tracked in current domain model
            current_lesson_id: nil, // Not tracked in current domain model
            total_xp: totalXP,
            lessons_completed: lessonsCompleted,
            live_answers: totalAnswered, // Using totalAnswered as approximation
            concepts_mastered: 0, // Not tracked in current domain model
            last_active_at: ISO8601DateFormatter().string(from: lastActivityAt),
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
