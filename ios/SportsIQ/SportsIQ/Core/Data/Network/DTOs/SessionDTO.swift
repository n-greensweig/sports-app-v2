//
//  SessionDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Session from Supabase
struct SessionDTO: Codable {
    let id: String
    let user_id: String
    let mode: String
    let sport_id: String?
    let game_id: String?
    let started_at: String
    let ended_at: String?
    let device_platform: String?
    let app_version: String?

    /// Convert DTO to Domain entity
    func toDomain() throws -> Session {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }

        var sportUuid: UUID? = nil
        if let sportId = sport_id {
            guard let uuid = UUID(uuidString: sportId) else {
                throw DTOConversionError.invalidUUID(field: "sport_id", value: sportId)
            }
            sportUuid = uuid
        }

        var gameUuid: UUID? = nil
        if let gameId = game_id {
            guard let uuid = UUID(uuidString: gameId) else {
                throw DTOConversionError.invalidUUID(field: "game_id", value: gameId)
            }
            gameUuid = uuid
        }

        guard let startedDate = ISO8601DateFormatter().date(from: started_at) else {
            throw DTOConversionError.invalidDate(field: "started_at", value: started_at)
        }

        var endedDate: Date? = nil
        if let ended = ended_at {
            endedDate = ISO8601DateFormatter().date(from: ended)
        }

        return Session(
            id: uuid,
            userId: userUuid,
            mode: mode,
            sportId: sportUuid,
            gameId: gameUuid,
            startedAt: startedDate,
            endedAt: endedDate,
            devicePlatform: device_platform,
            appVersion: app_version
        )
    }
}

/// Domain entity for Session (if not already defined)
struct Session: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let mode: String
    let sportId: UUID?
    let gameId: UUID?
    let startedAt: Date
    let endedAt: Date?
    let devicePlatform: String?
    let appVersion: String?
}

// MARK: - Domain to DTO Extension
extension Session {
    func toDTO() -> SessionDTO {
        SessionDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            mode: mode,
            sport_id: sportId?.uuidString,
            game_id: gameId?.uuidString,
            started_at: ISO8601DateFormatter().string(from: startedAt),
            ended_at: endedAt != nil ? ISO8601DateFormatter().string(from: endedAt!) : nil,
            device_platform: devicePlatform,
            app_version: appVersion
        )
    }
}
