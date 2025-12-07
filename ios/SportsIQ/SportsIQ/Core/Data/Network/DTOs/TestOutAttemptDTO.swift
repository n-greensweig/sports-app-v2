//
//  TestOutAttemptDTO.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import Foundation

/// Data Transfer Object for user_test_out_attempts table from Supabase
struct TestOutAttemptDTO: Codable {
    let id: String
    let user_id: String
    let module_id: String
    let score: Int
    let passed: Bool
    let attempted_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> TestOutAttempt {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }
        guard let moduleUuid = UUID(uuidString: module_id) else {
            throw DTOConversionError.invalidUUID(field: "module_id", value: module_id)
        }

        // Parse the ISO8601 date
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let attemptedDate = formatter.date(from: attempted_at) ?? Date()

        return TestOutAttempt(
            id: uuid,
            userId: userUuid,
            moduleId: moduleUuid,
            score: score,
            passed: passed,
            attemptedAt: attemptedDate
        )
    }
}

// MARK: - Domain to DTO Extension
extension TestOutAttempt {
    func toDTO() -> TestOutAttemptDTO {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return TestOutAttemptDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            module_id: moduleId.uuidString,
            score: score,
            passed: passed,
            attempted_at: formatter.string(from: attemptedAt)
        )
    }
}
