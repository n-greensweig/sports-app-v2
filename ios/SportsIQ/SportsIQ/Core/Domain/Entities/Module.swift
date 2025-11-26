//
//  Module.swift
//  Ola Ball
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
    // MARK: - Sections (Modules represent sections in the CLAUDE.md structure)

    /// Rookie Section - First section for beginners
    /// Contains: The Field, Offensive Terms, Defensive Terms, Games & Overtime, etc.
    static let rookie = Module(
        id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        sportId: Sport.football.id,
        title: "Rookie",
        description: "Start your football journey! Learn the basics of the field, scoring, and key terms.",
        orderIndex: 1,
        estimatedMinutes: 60,
        totalLessons: 20,  // TF1-2, OT1-3, DT1-3, G&O1-3, etc.
        isLocked: false
    )

    /// Veteran Section - Intermediate content
    static let veteran = Module(
        id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
        sportId: Sport.football.id,
        title: "Veteran",
        description: "Level up your knowledge with offensive and defensive fundamentals.",
        orderIndex: 2,
        estimatedMinutes: 90,
        totalLessons: 35,
        isLocked: true
    )

    /// All-Pro Section - Advanced content
    static let allPro = Module(
        id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
        sportId: Sport.football.id,
        title: "All-Pro",
        description: "Master the intricacies of NFL rules, roster management, and fantasy football.",
        orderIndex: 3,
        estimatedMinutes: 80,
        totalLessons: 15,
        isLocked: true
    )

    /// MVP Section - Expert content
    static let mvp = Module(
        id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
        sportId: Sport.football.id,
        title: "MVP",
        description: "Advanced offensive and defensive strategies for the serious fan.",
        orderIndex: 4,
        estimatedMinutes: 50,
        totalLessons: 6,
        isLocked: true
    )

    /// Hall of Fame Section - Expert+ content
    static let hallOfFame = Module(
        id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
        sportId: Sport.football.id,
        title: "Hall of Fame",
        description: "Deep dive into advanced run schemes, blitzes, and coverage disguises.",
        orderIndex: 5,
        estimatedMinutes: 45,
        totalLessons: 5,
        isLocked: true
    )

    /// Legend Section - Master content
    static let legend = Module(
        id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!,
        sportId: Sport.football.id,
        title: "Legend",
        description: "Master zone coverage principles and personnel matchups.",
        orderIndex: 6,
        estimatedMinutes: 30,
        totalLessons: 3,
        isLocked: true
    )

    /// GOAT Section - Ultimate mastery
    static let goat = Module(
        id: UUID(uuidString: "77777777-7777-7777-7777-777777777777")!,
        sportId: Sport.football.id,
        title: "GOAT",
        description: "Scheme evolution, advanced metrics, and the history of football strategy.",
        orderIndex: 7,
        estimatedMinutes: 35,
        totalLessons: 4,
        isLocked: true
    )

    // Backwards compatibility alias
    static let footballBasics = rookie

    static let mockModules = [
        rookie,
        veteran,
        allPro,
        mvp,
        hallOfFame,
        legend,
        goat
    ]
}
