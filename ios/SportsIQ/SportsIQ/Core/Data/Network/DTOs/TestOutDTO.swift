//
//  TestOutDTO.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import Foundation

/// Data Transfer Object for module_test_outs table from Supabase
struct TestOutDTO: Codable {
    let id: String
    let module_id: String
    let passing_score: Int
    let total_questions: Int
    let is_active: Bool
    let created_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> TestOut {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let moduleUuid = UUID(uuidString: module_id) else {
            throw DTOConversionError.invalidUUID(field: "module_id", value: module_id)
        }

        return TestOut(
            id: uuid,
            moduleId: moduleUuid,
            passingScore: passing_score,
            totalQuestions: total_questions,
            isActive: is_active
        )
    }
}

// MARK: - Domain to DTO Extension
extension TestOut {
    func toDTO() -> TestOutDTO {
        TestOutDTO(
            id: id.uuidString,
            module_id: moduleId.uuidString,
            passing_score: passingScore,
            total_questions: totalQuestions,
            is_active: isActive,
            created_at: ISO8601DateFormatter().string(from: Date())
        )
    }
}
