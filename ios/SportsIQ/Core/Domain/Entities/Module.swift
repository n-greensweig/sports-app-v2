//
//  Module.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Represents a learning module (collection of lessons) within a sport
struct Module: Identifiable, Codable, Hashable {
    let id: UUID
    let sportId: UUID
    let title: String
    let description: String
    let orderIndex: Int
    let estimatedMinutes: Int
    let totalLessons: Int
    let isLocked: Bool

    init(
        id: UUID,
        sportId: UUID,
        title: String,
        description: String,
        orderIndex: Int,
        estimatedMinutes: Int,
        totalLessons: Int,
        isLocked: Bool = false
    ) {
        self.id = id
        self.sportId = sportId
        self.title = title
        self.description = description
        self.orderIndex = orderIndex
        self.estimatedMinutes = estimatedMinutes
        self.totalLessons = totalLessons
        self.isLocked = isLocked
    }
}

// MARK: - Mock Data
extension Module {
    static let footballBasics = Module(
        id: UUID(),
        sportId: Sport.football.id,
        title: "Football Basics",
        description: "Learn the fundamental rules and positions",
        orderIndex: 1,
        estimatedMinutes: 45,
        totalLessons: 8,
        isLocked: false
    )

    static let offensiveStrategies = Module(
        id: UUID(),
        sportId: Sport.football.id,
        title: "Offensive Strategies",
        description: "Understand common offensive plays and formations",
        orderIndex: 2,
        estimatedMinutes: 60,
        totalLessons: 10,
        isLocked: true
    )

    static let mockModules = [footballBasics, offensiveStrategies]
}
