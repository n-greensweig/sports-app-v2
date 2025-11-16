//
//  SeasonDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Season from Supabase
struct SeasonDTO: Codable {
    let id: String
    let league_id: String
    let year: Int
    let phase: String
    let start_date: String?
    let end_date: String?
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> Season {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let leagueUuid = UUID(uuidString: league_id) else {
            throw DTOConversionError.invalidUUID(field: "league_id", value: league_id)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var startDate: Date? = nil
        if let dateStr = start_date {
            startDate = dateFormatter.date(from: dateStr)
        }

        var endDate: Date? = nil
        if let dateStr = end_date {
            endDate = dateFormatter.date(from: dateStr)
        }

        return Season(
            id: uuid,
            leagueId: leagueUuid,
            year: year,
            phase: phase,
            startDate: startDate,
            endDate: endDate
        )
    }
}

/// Domain entity for Season (if not already defined)
struct Season: Identifiable, Codable {
    let id: UUID
    let leagueId: UUID
    let year: Int
    let phase: String
    let startDate: Date?
    let endDate: Date?
}

// MARK: - Domain to DTO Extension
extension Season {
    func toDTO() -> SeasonDTO {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return SeasonDTO(
            id: id.uuidString,
            league_id: leagueId.uuidString,
            year: year,
            phase: phase,
            start_date: startDate != nil ? dateFormatter.string(from: startDate!) : nil,
            end_date: endDate != nil ? dateFormatter.string(from: endDate!) : nil,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
