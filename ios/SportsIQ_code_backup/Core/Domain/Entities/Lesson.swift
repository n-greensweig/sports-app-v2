//
//  Lesson.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Represents a learning lesson within a module
struct Lesson: Identifiable, Codable, Hashable {
    let id: UUID
    let moduleId: UUID
    let title: String
    let description: String
    let orderIndex: Int
    let estimatedMinutes: Int
    let xpAward: Int
    let isLocked: Bool
    let items: [Item]

    init(
        id: UUID,
        moduleId: UUID,
        title: String,
        description: String,
        orderIndex: Int,
        estimatedMinutes: Int,
        xpAward: Int,
        isLocked: Bool = false,
        items: [Item] = []
    ) {
        self.id = id
        self.moduleId = moduleId
        self.title = title
        self.description = description
        self.orderIndex = orderIndex
        self.estimatedMinutes = estimatedMinutes
        self.xpAward = xpAward
        self.isLocked = isLocked
        self.items = items
    }
}

// MARK: - Mock Data
extension Lesson {
    static let footballBasicsLesson1 = Lesson(
        id: UUID(),
        moduleId: Module.footballBasics.id,
        title: "The Field & Players",
        description: "Learn about the football field and how many players are on each team",
        orderIndex: 1,
        estimatedMinutes: 5,
        xpAward: 50,
        isLocked: false,
        items: [
            Item.mockMCQ,
            Item.mockBinary
        ]
    )

    static let footballBasicsLesson2 = Lesson(
        id: UUID(),
        moduleId: Module.footballBasics.id,
        title: "Scoring Basics",
        description: "Understand how points are scored in football",
        orderIndex: 2,
        estimatedMinutes: 5,
        xpAward: 50,
        isLocked: true,
        items: []
    )

    static let mockLessons = [footballBasicsLesson1, footballBasicsLesson2]
}
