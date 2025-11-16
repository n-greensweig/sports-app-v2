//
//  XPEventDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for XPEvent from Supabase
struct XPEventDTO: Codable {
    let id: String
    let user_id: String
    let sport_id: String
    let source: String
    let amount: Int
    let meta_json: [String: AnyCodable]?
    let occurred_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> XPEvent {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }
        guard let sportUuid = UUID(uuidString: sport_id) else {
            throw DTOConversionError.invalidUUID(field: "sport_id", value: sport_id)
        }

        guard let occurredDate = ISO8601DateFormatter().date(from: occurred_at) else {
            throw DTOConversionError.invalidDate(field: "occurred_at", value: occurred_at)
        }

        guard let xpSource = XPSource(rawValue: source) else {
            throw DTOConversionError.invalidEnum(field: "source", value: source)
        }

        return XPEvent(
            id: uuid,
            userId: userUuid,
            sportId: sportUuid,
            source: xpSource,
            amount: amount,
            timestamp: occurredDate,
            relatedItemId: nil // Not tracked in DTO meta_json currently
        )
    }
}

// MARK: - Domain to DTO Extension
extension XPEvent {
    func toDTO() -> XPEventDTO {
        var metaJson: [String: AnyCodable]? = nil
        if let relatedItemId = relatedItemId {
            metaJson = ["related_item_id": AnyCodable(relatedItemId.uuidString)]
        }

        return XPEventDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            sport_id: sportId?.uuidString ?? "",
            source: source.rawValue,
            amount: amount,
            meta_json: metaJson,
            occurred_at: ISO8601DateFormatter().string(from: timestamp)
        )
    }
}
