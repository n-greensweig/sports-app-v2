//
//  TeamDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Team from Supabase
struct TeamDTO: Codable {
    let id: String
    let league_id: String
    let provider_team_key: String?
    let name: String
    let abbreviation: String
    let city: String?
    let logo_url: String?
    let primary_color: String?
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> Team {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }

        return Team(
            id: uuid,
            name: name,
            shortName: abbreviation,
            logoURL: logo_url,
            primaryColorHex: primary_color ?? "#000000"
        )
    }
}

// Note: Team domain entity is defined in Game.swift with different structure
// The existing Team doesn't have leagueId, abbreviation, city, or providerTeamKey
// toDTO() method not implemented yet - will be added when domain model is updated to match database schema
