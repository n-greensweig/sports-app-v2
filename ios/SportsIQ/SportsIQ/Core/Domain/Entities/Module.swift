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
        id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        sportId: Sport.football.id,
        title: "Football Basics",
        description: "Learn the fundamental rules and positions",
        orderIndex: 1,
        estimatedMinutes: 45,
        totalLessons: 8,
        isLocked: false
    )

    static let offensiveStrategies = Module(
        id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
        sportId: Sport.football.id,
        title: "Offensive Strategies",
        description: "Understand common offensive plays and formations",
        orderIndex: 2,
        estimatedMinutes: 60,
        totalLessons: 10,
        isLocked: true
    )

    static let defensiveTactics = Module(
        id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
        sportId: Sport.football.id,
        title: "Defensive Tactics",
        description: "Master defensive formations and strategies",
        orderIndex: 3,
        estimatedMinutes: 55,
        totalLessons: 9,
        isLocked: true
    )

    static let specialTeams = Module(
        id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
        sportId: Sport.football.id,
        title: "Special Teams",
        description: "Learn about kicking, punting, and returns",
        orderIndex: 4,
        estimatedMinutes: 40,
        totalLessons: 7,
        isLocked: true
    )

    static let penalties = Module(
        id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
        sportId: Sport.football.id,
        title: "Penalties & Rules",
        description: "Understand common penalties and rule infractions",
        orderIndex: 5,
        estimatedMinutes: 50,
        totalLessons: 8,
        isLocked: true
    )

    static let advancedConcepts = Module(
        id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!,
        sportId: Sport.football.id,
        title: "Advanced Concepts",
        description: "Deep dive into advanced strategies and analytics",
        orderIndex: 6,
        estimatedMinutes: 70,
        totalLessons: 12,
        isLocked: true
    )

    static let mockModules = [
        footballBasics,
        offensiveStrategies,
        defensiveTactics,
        specialTeams,
        penalties,
        advancedConcepts
    ]
}
