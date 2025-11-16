//
//  GameDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Game from Supabase
struct GameDTO: Codable {
    let id: String
    let league_id: String
    let season_id: String
    let provider_game_id: String
    let home_team_id: String
    let away_team_id: String
    let start_time: String
    let venue: String?
    let status: String
    let final_home_score: Int?
    let final_away_score: Int?
    let current_period: String?
    let current_clock: String?
    let metadata_json: [String: AnyCodable]?
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain(homeTeam: Team, awayTeam: Team, sportId: UUID) throws -> Game {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }

        guard let startTimeDate = ISO8601DateFormatter().date(from: start_time) else {
            throw DTOConversionError.invalidDate(field: "start_time", value: start_time)
        }

        // Parse GameStatus from status string
        guard let gameStatus = GameStatus(rawValue: status) else {
            throw DTOConversionError.invalidEnum(field: "status", value: status)
        }

        // Parse current_period to Int for currentQuarter
        let currentQuarter: Int?
        if let periodStr = current_period {
            currentQuarter = Int(periodStr)
        } else {
            currentQuarter = nil
        }

        return Game(
            id: uuid,
            sportId: sportId,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            scheduledTime: startTimeDate,
            status: gameStatus,
            currentQuarter: currentQuarter,
            timeRemaining: current_clock,
            homeScore: final_home_score ?? 0,
            awayScore: final_away_score ?? 0,
            venue: venue ?? ""
        )
    }
}

// Note: Game domain entity in Game.swift has different structure than database schema
// Database has: league_id, season_id, provider_game_id, home_team_id, away_team_id
// Domain has: sportId, homeTeam (object), awayTeam (object), scheduledTime, currentQuarter
// toDTO() method not implemented - requires additional context (league_id, season_id, team IDs)
