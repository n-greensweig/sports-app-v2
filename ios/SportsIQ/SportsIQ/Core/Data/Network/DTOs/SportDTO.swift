//
//  SportDTO.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Sport from Supabase
struct SportDTO: Codable {
    let id: String
    let slug: String
    let name: String
    let icon_url: String?
    let accent_color: String?
    let description: String?
    let emoji: String?
    let order_index: Int
    let is_active: Bool
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> Sport {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }

        // Default emojis based on sport slug
        let sportEmoji = emoji ?? defaultEmoji(for: slug)

        return Sport(
            id: uuid,
            name: name,
            slug: slug,
            description: description ?? "",
            iconName: icon_url ?? "sportscourt.fill", // Default SF Symbol
            accentColorHex: accent_color ?? "#000000",
            emoji: sportEmoji,
            isActive: is_active,
            displayOrder: order_index
        )
    }

    /// Provides default emoji based on sport slug
    private func defaultEmoji(for slug: String) -> String {
        switch slug.lowercased() {
        case "football": return "🏈"
        case "basketball": return "🏀"
        case "baseball": return "⚾"
        case "hockey": return "🏒"
        case "soccer": return "⚽"
        case "golf": return "⛳"
        case "tennis": return "🎾"
        default: return "🏆"
        }
    }
}

/// Errors that can occur during DTO conversion
enum DTOConversionError: Error, LocalizedError {
    case invalidUUID(field: String, value: String)
    case invalidDate(field: String, value: String)
    case missingRequiredField(field: String)
    case invalidEnum(field: String, value: String)

    var errorDescription: String? {
        switch self {
        case .invalidUUID(let field, let value):
            return "Invalid UUID for field '\(field)': \(value)"
        case .invalidDate(let field, let value):
            return "Invalid date for field '\(field)': \(value)"
        case .missingRequiredField(let field):
            return "Missing required field: \(field)"
        case .invalidEnum(let field, let value):
            return "Invalid enum value for field '\(field)': \(value)"
        }
    }
}

// MARK: - Domain to DTO Extension
extension Sport {
    func toDTO() -> SportDTO {
        SportDTO(
            id: id.uuidString,
            slug: slug,
            name: name,
            icon_url: iconName,
            accent_color: accentColorHex,
            description: description.isEmpty ? nil : description,
            emoji: emoji.isEmpty ? nil : emoji,
            order_index: displayOrder,
            is_active: isActive,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
