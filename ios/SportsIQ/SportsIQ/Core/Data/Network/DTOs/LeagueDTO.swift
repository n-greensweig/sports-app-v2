//
//  LeagueDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for League from Supabase
struct LeagueDTO: Codable {
    let id: String
    let sport_id: String
    let slug: String
    let name: String
    let country: String?
    let provider_league_key: String?
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> League {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let sportUuid = UUID(uuidString: sport_id) else {
            throw DTOConversionError.invalidUUID(field: "sport_id", value: sport_id)
        }

        return League(
            id: uuid,
            sportId: sportUuid,
            slug: slug,
            name: name,
            country: country,
            providerLeagueKey: provider_league_key
        )
    }
}

/// Domain entity for League (if not already defined)
struct League: Identifiable, Codable, Hashable {
    let id: UUID
    let sportId: UUID
    let slug: String
    let name: String
    let country: String?
    let providerLeagueKey: String?
}

// MARK: - Domain to DTO Extension
extension League {
    func toDTO() -> LeagueDTO {
        LeagueDTO(
            id: id.uuidString,
            sport_id: sportId.uuidString,
            slug: slug,
            name: name,
            country: country,
            provider_league_key: providerLeagueKey,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
