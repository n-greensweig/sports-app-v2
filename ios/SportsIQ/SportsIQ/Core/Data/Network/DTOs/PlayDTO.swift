//
//  PlayDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Play from Supabase
struct PlayDTO: Codable {
    let id: String
    let game_id: String
    let drive_id: String?
    let sequence: Int
    let clock: String?
    let down: Int?
    let distance: Int?
    let yard_line: Int?
    let yard_line_side: String?
    let play_text: String?
    let possession_team_id: String?
    let defense_team_id: String?
    let provider_play_id: String?
    let created_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> Play {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let gameUuid = UUID(uuidString: game_id) else {
            throw DTOConversionError.invalidUUID(field: "game_id", value: game_id)
        }

        var driveUuid: UUID? = nil
        if let driveId = drive_id {
            guard let uuid = UUID(uuidString: driveId) else {
                throw DTOConversionError.invalidUUID(field: "drive_id", value: driveId)
            }
            driveUuid = uuid
        }

        var possessionTeamUuid: UUID? = nil
        if let teamId = possession_team_id {
            guard let uuid = UUID(uuidString: teamId) else {
                throw DTOConversionError.invalidUUID(field: "possession_team_id", value: teamId)
            }
            possessionTeamUuid = uuid
        }

        var defenseTeamUuid: UUID? = nil
        if let teamId = defense_team_id {
            guard let uuid = UUID(uuidString: teamId) else {
                throw DTOConversionError.invalidUUID(field: "defense_team_id", value: teamId)
            }
            defenseTeamUuid = uuid
        }

        return Play(
            id: uuid,
            gameId: gameUuid,
            driveId: driveUuid,
            sequence: sequence,
            clock: clock,
            down: down,
            distance: distance,
            yardLine: yard_line,
            yardLineSide: yard_line_side,
            playText: play_text,
            possessionTeamId: possessionTeamUuid,
            defenseTeamId: defenseTeamUuid,
            providerPlayId: provider_play_id
        )
    }
}

/// Domain entity for Play (if not already defined)
struct Play: Identifiable, Codable {
    let id: UUID
    let gameId: UUID
    let driveId: UUID?
    let sequence: Int
    let clock: String?
    let down: Int?
    let distance: Int?
    let yardLine: Int?
    let yardLineSide: String?
    let playText: String?
    let possessionTeamId: UUID?
    let defenseTeamId: UUID?
    let providerPlayId: String?
}

// MARK: - Domain to DTO Extension
extension Play {
    func toDTO() -> PlayDTO {
        PlayDTO(
            id: id.uuidString,
            game_id: gameId.uuidString,
            drive_id: driveId?.uuidString,
            sequence: sequence,
            clock: clock,
            down: down,
            distance: distance,
            yard_line: yardLine,
            yard_line_side: yardLineSide,
            play_text: playText,
            possession_team_id: possessionTeamId?.uuidString,
            defense_team_id: defenseTeamId?.uuidString,
            provider_play_id: providerPlayId,
            created_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
