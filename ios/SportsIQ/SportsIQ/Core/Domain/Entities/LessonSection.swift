//
//  LessonSection.swift
//  Ola Ball
//
//  Defines content sections that group lessons between quizzes/tests
//

import SwiftUI

/// Represents a thematic section of lessons that ends with a quiz or test
/// Sections are used for the dynamic banner that changes as users scroll
struct LessonSection: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let color: Color

    /// The order index of the first lesson in this section
    let startOrderIndex: Int

    /// The order index of the last lesson (inclusive) - typically a quiz/test
    let endOrderIndex: Int

    /// Check if a lesson belongs to this section
    func contains(lessonOrderIndex: Int) -> Bool {
        lessonOrderIndex >= startOrderIndex && lessonOrderIndex <= endOrderIndex
    }
}

// MARK: - Module Identifiers
extension LessonSection {
    /// Known module IDs for section lookup
    static let footballRookieModuleId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let footballVeteranModuleId = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
    static let baseballRookieModuleId = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
}

// MARK: - Football Rookie Section Definitions
extension LessonSection {

    /// All sections for the Football Rookie module
    /// Sections are divided thematically with quizzes marking natural break points
    static let footballRookieSections: [LessonSection] = [
        // Section 1: Welcome to Football (GB1, TF1, TF2)
        // Covers: What is football, field dimensions, sidelines/boundaries
        LessonSection(
            id: "football_welcome",
            title: "Welcome to Football",
            subtitle: "Section 1, Unit 1",
            color: Color(hex: "#2E7D32"), // Green - fresh start
            startOrderIndex: 1,
            endOrderIndex: 3
        ),

        // Section 2: How the Game Works (SC1, DS1, DS2, PT1, SC2, TF3, PT2 + Foundations Quiz)
        // Covers: Scoring, downs, play types - the core gameplay mechanics
        LessonSection(
            id: "football_gameplay",
            title: "How the Game Works",
            subtitle: "Section 1, Unit 2",
            color: Color(hex: "#1565C0"), // Blue - learning mechanics
            startOrderIndex: 4,
            endOrderIndex: 11
        ),

        // Section 3: Meet the Players (OP1, OP2, DP1, DP2 + Positions Quiz)
        // Covers: All offensive and defensive positions
        LessonSection(
            id: "football_positions",
            title: "Meet the Players",
            subtitle: "Section 1, Unit 3",
            color: Color(hex: "#E65100"), // Orange - energy, players in action
            startOrderIndex: 12,
            endOrderIndex: 16
        ),

        // Section 4: When Things Go Wrong (TO1, TO2, CP1, CP2 + Turnovers/Penalties Quiz)
        // Covers: Turnovers and common penalties - disruptions to normal play
        LessonSection(
            id: "football_disruptions",
            title: "When Things Go Wrong",
            subtitle: "Section 1, Unit 4",
            color: Color(hex: "#C62828"), // Red - caution, disruptions
            startOrderIndex: 17,
            endOrderIndex: 21
        ),

        // Section 5: The Full Picture (GS1, GS2, ST1, ST2 + Game Structure Quiz + Final Test)
        // Covers: Game structure, special teams, and comprehensive final assessment
        LessonSection(
            id: "football_complete",
            title: "The Full Picture",
            subtitle: "Section 1, Unit 5",
            color: Color(hex: "#7B1FA2"), // Purple - mastery, completion
            startOrderIndex: 22,
            endOrderIndex: 27
        )
    ]

    /// All sections for the Football Veteran module
    /// Covers intermediate concepts: penalties, formations, clock management, lingo, league structure
    static let footballVeteranSections: [LessonSection] = [
        // Section 1: Rules & Penalties (PEN1, PEN2)
        // Covers: Common penalties, penalty enforcement
        LessonSection(
            id: "veteran_penalties",
            title: "Rules & Penalties",
            subtitle: "Veteran, Unit 1",
            color: Color(hex: "#C62828"), // Red - penalties/flags
            startOrderIndex: 1,
            endOrderIndex: 2
        ),

        // Section 2: Formations & Alignments (FMT1, FMT2)
        // Covers: Offensive and defensive formations
        LessonSection(
            id: "veteran_formations",
            title: "Formations & Alignments",
            subtitle: "Veteran, Unit 2",
            color: Color(hex: "#1565C0"), // Blue - strategy
            startOrderIndex: 3,
            endOrderIndex: 4
        ),

        // Section 3: Clock Management (CLK1)
        // Covers: Game clock, play clock, timeouts, two-minute drill
        LessonSection(
            id: "veteran_clock",
            title: "Clock Management",
            subtitle: "Veteran, Unit 3",
            color: Color(hex: "#F57C00"), // Orange - time pressure
            startOrderIndex: 5,
            endOrderIndex: 5
        ),

        // Section 4: Football Lingo (LNG1, LNG2)
        // Covers: Common phrases, slang, announcer terminology
        LessonSection(
            id: "veteran_lingo",
            title: "Football Lingo",
            subtitle: "Veteran, Unit 4",
            color: Color(hex: "#2E7D32"), // Green - communication
            startOrderIndex: 6,
            endOrderIndex: 7
        ),

        // Section 5: League Structure (LG1, LG2, STR1 + Veteran Quiz)
        // Covers: NFL divisions, conferences, playoffs, strategy basics
        LessonSection(
            id: "veteran_league",
            title: "The NFL",
            subtitle: "Veteran, Unit 5",
            color: Color(hex: "#7B1FA2"), // Purple - big picture
            startOrderIndex: 8,
            endOrderIndex: 11
        )
    ]

    /// All sections for the Baseball Rookie module
    static let baseballRookieSections: [LessonSection] = [
        // Section 1: Welcome to Baseball
        LessonSection(
            id: "baseball_welcome",
            title: "Welcome to Baseball",
            subtitle: "Section 1, Unit 1",
            color: Color(hex: "#1976D2"), // Baseball blue
            startOrderIndex: 1,
            endOrderIndex: 3
        ),

        // Section 2: How the Game Works
        LessonSection(
            id: "baseball_gameplay",
            title: "How the Game Works",
            subtitle: "Section 1, Unit 2",
            color: Color(hex: "#C62828"), // Red - baseball accent
            startOrderIndex: 4,
            endOrderIndex: 11
        ),

        // Section 3: Meet the Players
        LessonSection(
            id: "baseball_positions",
            title: "Meet the Players",
            subtitle: "Section 1, Unit 3",
            color: Color(hex: "#2E7D32"), // Green - field
            startOrderIndex: 12,
            endOrderIndex: 16
        ),

        // Section 4: Plays and Strategy
        LessonSection(
            id: "baseball_strategy",
            title: "Plays and Strategy",
            subtitle: "Section 1, Unit 4",
            color: Color(hex: "#E65100"), // Orange - energy
            startOrderIndex: 17,
            endOrderIndex: 21
        ),

        // Section 5: The Full Picture
        LessonSection(
            id: "baseball_complete",
            title: "The Full Picture",
            subtitle: "Section 1, Unit 5",
            color: Color(hex: "#7B1FA2"), // Purple - mastery
            startOrderIndex: 22,
            endOrderIndex: 27
        )
    ]

    /// Get sections for a given module ID
    static func sections(forModuleId moduleId: UUID) -> [LessonSection] {
        switch moduleId {
        case footballRookieModuleId:
            return footballRookieSections
        case footballVeteranModuleId:
            return footballVeteranSections
        case baseballRookieModuleId:
            return baseballRookieSections
        default:
            return footballRookieSections // Fallback
        }
    }

    /// Get sections for a given sport slug (defaults to Rookie)
    static func sections(forSport sportSlug: String) -> [LessonSection] {
        switch sportSlug {
        case "football":
            return footballRookieSections
        case "baseball":
            return baseballRookieSections
        default:
            return footballRookieSections // Fallback
        }
    }

    /// Find the section for a given lesson order index
    static func section(for orderIndex: Int, in sections: [LessonSection] = footballRookieSections) -> LessonSection? {
        sections.first { $0.contains(lessonOrderIndex: orderIndex) }
    }

    /// Find the section for a given lesson order index and sport
    static func section(for orderIndex: Int, sportSlug: String) -> LessonSection? {
        let sportSections = sections(forSport: sportSlug)
        return sportSections.first { $0.contains(lessonOrderIndex: orderIndex) }
    }

    /// Find the section for a given lesson order index and module
    static func section(for orderIndex: Int, moduleId: UUID) -> LessonSection? {
        let moduleSections = sections(forModuleId: moduleId)
        return moduleSections.first { $0.contains(lessonOrderIndex: orderIndex) }
    }

    /// Default section to show when no lessons are visible
    static let defaultSection = footballRookieSections[0]

    /// Default section for a given sport
    static func defaultSection(forSport sportSlug: String) -> LessonSection {
        sections(forSport: sportSlug).first ?? defaultSection
    }

    /// Default section for a given module
    static func defaultSection(forModuleId moduleId: UUID) -> LessonSection {
        sections(forModuleId: moduleId).first ?? defaultSection
    }
}
