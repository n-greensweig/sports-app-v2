//
//  UserDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for User from Supabase
struct UserDTO: Codable {
    let id: String
    let clerk_user_id: String
    let email: String
    let role: String
    let status: String
    let created_at: String
    let updated_at: String
    let deleted_at: String?

    /// Convert DTO to Domain entity
    func toDomain(profile: UserProfileDTO?) throws -> User {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }

        guard let createdDate = ISO8601DateFormatter().date(from: created_at) else {
            throw DTOConversionError.invalidDate(field: "created_at", value: created_at)
        }

        guard let updatedDate = ISO8601DateFormatter().date(from: updated_at) else {
            throw DTOConversionError.invalidDate(field: "updated_at", value: updated_at)
        }

        return User(
            id: uuid,
            clerkId: clerk_user_id,
            username: profile?.username ?? email.components(separatedBy: "@").first ?? "user",
            email: email,
            displayName: profile?.display_name,
            avatarURL: profile?.avatar_url,
            createdAt: createdDate,
            lastActiveAt: updatedDate
        )
    }
}

/// Data Transfer Object for UserProfile from Supabase
struct UserProfileDTO: Codable {
    let user_id: String
    let display_name: String
    let username: String?
    let avatar_url: String?
    let bio: String?
    let country: String?
    let timezone: String?
    let birth_year: Int?
    let favorite_team_id: String?
    let notification_preferences: [String: AnyCodable]
    let privacy_settings: [String: AnyCodable]
    let created_at: String
    let updated_at: String
}

/// Data Transfer Object for Device from Supabase
struct DeviceDTO: Codable {
    let id: String
    let user_id: String
    let platform: String
    let device_identifier: String
    let push_token: String?
    let app_version: String?
    let os_version: String?
    let last_seen_at: String
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> Device {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }

        guard let lastSeenDate = ISO8601DateFormatter().date(from: last_seen_at) else {
            throw DTOConversionError.invalidDate(field: "last_seen_at", value: last_seen_at)
        }

        return Device(
            id: uuid,
            userId: userUuid,
            platform: platform,
            deviceIdentifier: device_identifier,
            pushToken: push_token,
            appVersion: app_version,
            osVersion: os_version,
            lastSeenAt: lastSeenDate
        )
    }
}

/// Domain entity for Device (if not already defined)
struct Device: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let platform: String
    let deviceIdentifier: String
    let pushToken: String?
    let appVersion: String?
    let osVersion: String?
    let lastSeenAt: Date
}

// MARK: - Domain to DTO Extensions
extension User {
    func toDTO(role: String = "user", status: String = "active") -> UserDTO {
        UserDTO(
            id: id.uuidString,
            clerk_user_id: clerkId,
            email: email,
            role: role,
            status: status,
            created_at: ISO8601DateFormatter().string(from: createdAt),
            updated_at: ISO8601DateFormatter().string(from: lastActiveAt),
            deleted_at: nil
        )
    }

    func toProfileDTO() -> UserProfileDTO {
        UserProfileDTO(
            user_id: id.uuidString,
            display_name: displayName ?? username,
            username: username,
            avatar_url: avatarURL,
            bio: nil,
            country: nil,
            timezone: nil,
            birth_year: nil,
            favorite_team_id: nil,
            notification_preferences: [:],
            privacy_settings: [
                "leaderboard_visible": AnyCodable(true),
                "profile_public": AnyCodable(true)
            ],
            created_at: ISO8601DateFormatter().string(from: createdAt),
            updated_at: ISO8601DateFormatter().string(from: lastActiveAt)
        )
    }
}

extension Device {
    func toDTO() -> DeviceDTO {
        DeviceDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            platform: platform,
            device_identifier: deviceIdentifier,
            push_token: pushToken,
            app_version: appVersion,
            os_version: osVersion,
            last_seen_at: ISO8601DateFormatter().string(from: lastSeenAt),
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
