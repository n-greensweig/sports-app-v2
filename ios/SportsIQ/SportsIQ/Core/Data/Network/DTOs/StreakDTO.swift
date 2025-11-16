//
//  StreakDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Streak from Supabase
struct StreakDTO: Codable {
    let id: String
    let user_id: String
    let sport_id: String
    let current_days: Int
    let longest_days: Int
    let last_checkin_date: String
    let freeze_days_available: Int
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> Streak {
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }
        guard let sportUuid = UUID(uuidString: sport_id) else {
            throw DTOConversionError.invalidUUID(field: "sport_id", value: sport_id)
        }

        // Parse date (format: YYYY-MM-DD)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let lastCheckinDate = dateFormatter.date(from: last_checkin_date) else {
            throw DTOConversionError.invalidDate(field: "last_checkin_date", value: last_checkin_date)
        }

        return Streak(
            userId: userUuid,
            sportId: sportUuid,
            currentStreak: current_days,
            longestStreak: longest_days,
            lastActivityDate: lastCheckinDate
        )
    }
}

// Note: Streak domain entity is defined in XPEvent.swift with different structure
// The existing Streak doesn't have id or freezeDaysAvailable fields
// toDTO() method not implemented yet - will be added when domain model is updated to match database schema
