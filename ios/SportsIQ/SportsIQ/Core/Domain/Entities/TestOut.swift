//
//  TestOut.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import Foundation

/// Configuration for a module's test-out assessment
/// Allows users to skip a module by passing a comprehensive test
struct TestOut: Identifiable, Codable, Hashable {
    let id: UUID
    let moduleId: UUID
    let passingScore: Int      // Number of correct answers required (default 20)
    let totalQuestions: Int    // Total questions in the test (default 25)
    let isActive: Bool

    init(
        id: UUID,
        moduleId: UUID,
        passingScore: Int = 20,
        totalQuestions: Int = 25,
        isActive: Bool = true
    ) {
        self.id = id
        self.moduleId = moduleId
        self.passingScore = passingScore
        self.totalQuestions = totalQuestions
        self.isActive = isActive
    }

    /// The percentage required to pass (e.g., 80%)
    var passingPercentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(passingScore) / Double(totalQuestions) * 100
    }
}

// MARK: - Mock Data
extension TestOut {
    static let rookieTestOut = TestOut(
        id: UUID(uuidString: "10000001-0000-0000-0000-000000000001")!,
        moduleId: Module.rookie.id,
        passingScore: 20,
        totalQuestions: 25,
        isActive: true
    )

    static let veteranTestOut = TestOut(
        id: UUID(uuidString: "10000001-0000-0000-0000-000000000002")!,
        moduleId: Module.veteran.id,
        passingScore: 20,
        totalQuestions: 25,
        isActive: true
    )
}
