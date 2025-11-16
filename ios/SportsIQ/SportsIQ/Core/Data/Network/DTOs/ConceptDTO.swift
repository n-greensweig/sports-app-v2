//
//  ConceptDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Concept from Supabase
struct ConceptDTO: Codable {
    let id: String
    let sport_id: String
    let slug: String
    let name: String
    let description_md: String?
    let difficulty: Int?
    let parent_concept_id: String?
    let order_index: Int
    let created_at: String
    let updated_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> Concept {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let sportUuid = UUID(uuidString: sport_id) else {
            throw DTOConversionError.invalidUUID(field: "sport_id", value: sport_id)
        }

        var parentUuid: UUID? = nil
        if let parentId = parent_concept_id {
            guard let uuid = UUID(uuidString: parentId) else {
                throw DTOConversionError.invalidUUID(field: "parent_concept_id", value: parentId)
            }
            parentUuid = uuid
        }

        return Concept(
            id: uuid,
            sportId: sportUuid,
            slug: slug,
            name: name,
            description: description_md,
            difficulty: difficulty,
            parentConceptId: parentUuid,
            orderIndex: order_index
        )
    }
}

/// Domain entity for Concept (if not already defined)
struct Concept: Identifiable, Codable, Hashable {
    let id: UUID
    let sportId: UUID
    let slug: String
    let name: String
    let description: String?
    let difficulty: Int?
    let parentConceptId: UUID?
    let orderIndex: Int
}

// MARK: - Domain to DTO Extension
extension Concept {
    func toDTO() -> ConceptDTO {
        ConceptDTO(
            id: id.uuidString,
            sport_id: sportId.uuidString,
            slug: slug,
            name: name,
            description_md: description,
            difficulty: difficulty,
            parent_concept_id: parentConceptId?.uuidString,
            order_index: orderIndex,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
