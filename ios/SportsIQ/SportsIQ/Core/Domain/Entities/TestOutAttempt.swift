//
//  TestOutAttempt.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import Foundation

/// Records a user's attempt at a module test-out assessment
struct TestOutAttempt: Identifiable, Codable, Hashable {
    let id: UUID
    let userId: UUID
    let moduleId: UUID
    let score: Int           // Number of correct answers
    let passed: Bool         // Whether the attempt met the passing threshold
    let attemptedAt: Date

    init(
        id: UUID,
        userId: UUID,
        moduleId: UUID,
        score: Int,
        passed: Bool,
        attemptedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.moduleId = moduleId
        self.score = score
        self.passed = passed
        self.attemptedAt = attemptedAt
    }
}

// MARK: - Mock Data
extension TestOutAttempt {
    static let mockFailedAttempt = TestOutAttempt(
        id: UUID(),
        userId: User.mock.id,
        moduleId: Module.rookie.id,
        score: 15,
        passed: false,
        attemptedAt: Date().addingTimeInterval(-3600) // 1 hour ago
    )

    static let mockPassedAttempt = TestOutAttempt(
        id: UUID(),
        userId: User.mock.id,
        moduleId: Module.rookie.id,
        score: 22,
        passed: true,
        attemptedAt: Date().addingTimeInterval(-86400) // 1 day ago
    )
}
