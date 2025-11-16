//
//  ItemDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Item from Supabase
struct ItemDTO: Codable {
    let id: String
    let lesson_id: String?
    let type: String
    let base_prompt: String
    let answer_schema_json: [String: AnyCodable]
    let author_id: String
    let status: String
    let difficulty: Int?
    let created_at: String
    let updated_at: String
    let deleted_at: String?

    /// Convert DTO to Domain entity
    func toDomain(variant: ItemVariantDTO?, orderIndex: Int = 0) throws -> Item {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }

        guard let lessonUuid = lesson_id.flatMap({ UUID(uuidString: $0) }) else {
            throw DTOConversionError.invalidUUID(field: "lesson_id", value: lesson_id ?? "nil")
        }

        guard let itemType = ItemType(rawValue: type) else {
            throw DTOConversionError.invalidEnum(field: "type", value: type)
        }

        // Use variant if available, otherwise use base prompt
        let prompt = variant?.prompt_richtext ?? base_prompt
        let options = variant?.options_json

        // Parse correct answer from variant or answer schema
        let correctAnswer: ItemAnswer
        if let variant = variant {
            correctAnswer = try parseAnswer(from: variant.correct_answer_json, type: itemType)
        } else {
            // Fallback to answer schema
            correctAnswer = try parseAnswer(from: answer_schema_json, type: itemType)
        }

        return Item(
            id: uuid,
            lessonId: lessonUuid,
            type: itemType,
            orderIndex: orderIndex,
            prompt: prompt,
            options: options,
            correctAnswer: correctAnswer,
            explanation: variant?.explanation_richtext,
            mediaURL: variant?.media_ref,
            xpValue: 10 // Default XP value
        )
    }

    private func parseAnswer(from json: [String: AnyCodable], type: ItemType) throws -> ItemAnswer {
        switch type {
        case .mcq:
            if let index = json["index"]?.value as? Int {
                return .single(index)
            }
        case .multiSelect:
            if let indices = json["indices"]?.value as? [Int] {
                return .multiple(indices)
            }
        case .binary:
            if let bool = json["value"]?.value as? Bool {
                return .boolean(bool)
            }
        case .slider:
            if let value = json["value"]?.value as? Double {
                return .range(min: value - 2, max: value + 2) // Acceptable range
            } else if let value = json["value"]?.value as? Int {
                let doubleValue = Double(value)
                return .range(min: doubleValue - 2, max: doubleValue + 2)
            }
        case .freeText:
            if let text = json["value"]?.value as? String {
                return .text(text)
            }
        case .clipLabel:
            // clipLabel doesn't have a specific ItemAnswer yet, treat as text
            if let label = json["label"]?.value as? String {
                return .text(label)
            }
        }

        // Default fallback
        return .single(0)
    }
}

/// Data Transfer Object for ItemVariant from Supabase
struct ItemVariantDTO: Codable {
    let id: String
    let item_id: String
    let version: Int
    let prompt_richtext: String
    let options_json: [String]?
    let correct_answer_json: [String: AnyCodable]
    let explanation_richtext: String?
    let media_ref: String?
    let active: Bool
    let ab_test_id: String?
    let created_at: String
    let updated_at: String
}

/// Helper type for decoding arbitrary JSON
struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { AnyCodable($0) })
        default:
            try container.encodeNil()
        }
    }
}

// MARK: - Domain to DTO Extension
extension Item {
    func toDTO(authorId: UUID) -> ItemDTO {
        let answerJson: [String: AnyCodable]
        switch correctAnswer {
        case .single(let index):
            answerJson = ["index": AnyCodable(index)]
        case .multiple(let indices):
            answerJson = ["indices": AnyCodable(indices)]
        case .boolean(let value):
            answerJson = ["value": AnyCodable(value)]
        case .range(let min, let max):
            answerJson = ["min": AnyCodable(min), "max": AnyCodable(max)]
        case .text(let text):
            answerJson = ["value": AnyCodable(text)]
        }

        return ItemDTO(
            id: id.uuidString,
            lesson_id: lessonId.uuidString,
            type: type.rawValue,
            base_prompt: prompt,
            answer_schema_json: answerJson,
            author_id: authorId.uuidString,
            status: "live",
            difficulty: nil,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date()),
            deleted_at: nil
        )
    }
}
