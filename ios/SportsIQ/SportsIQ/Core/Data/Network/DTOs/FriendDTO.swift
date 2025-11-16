//
//  FriendDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Friend from Supabase
struct FriendDTO: Codable {
    let id: String
    let user_id: String
    let friend_user_id: String
    let status: String
    let requested_at: String
    let accepted_at: String?
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain(friendUser: User?) throws -> Friend {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }
        guard let friendUserUuid = UUID(uuidString: friend_user_id) else {
            throw DTOConversionError.invalidUUID(field: "friend_user_id", value: friend_user_id)
        }

        guard let requestedDate = ISO8601DateFormatter().date(from: requested_at) else {
            throw DTOConversionError.invalidDate(field: "requested_at", value: requested_at)
        }

        var acceptedDate: Date? = nil
        if let accepted = accepted_at {
            acceptedDate = ISO8601DateFormatter().date(from: accepted)
        }

        return Friend(
            id: uuid,
            userId: userUuid,
            friendUserId: friendUserUuid,
            friendUser: friendUser,
            status: status,
            requestedAt: requestedDate,
            acceptedAt: acceptedDate
        )
    }
}

/// Domain entity for Friend (if not already defined)
struct Friend: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let friendUserId: UUID
    let friendUser: User?
    let status: String
    let requestedAt: Date
    let acceptedAt: Date?
}

// MARK: - Domain to DTO Extension
extension Friend {
    func toDTO() -> FriendDTO {
        FriendDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            friend_user_id: friendUserId.uuidString,
            status: status,
            requested_at: ISO8601DateFormatter().string(from: requestedAt),
            accepted_at: acceptedAt != nil ? ISO8601DateFormatter().string(from: acceptedAt!) : nil,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
