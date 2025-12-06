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

// MARK: - Football Rookie Section Definitions
extension LessonSection {

    /// All sections for the Football Rookie module
    /// Sections are divided thematically with quizzes marking natural break points
    static let footballRookieSections: [LessonSection] = [
        // Section 1: Welcome to Football (GB1, TF1, TF2)
        // Covers: What is football, field dimensions, sidelines/boundaries
        LessonSection(
            id: "welcome",
            title: "Welcome to Football",
            subtitle: "Section 1, Unit 1",
            color: Color(hex: "#2E7D32"), // Green - fresh start
            startOrderIndex: 1,
            endOrderIndex: 3
        ),

        // Section 2: How the Game Works (SC1, DS1, DS2, PT1, SC2, TF3, PT2 + Foundations Quiz)
        // Covers: Scoring, downs, play types - the core gameplay mechanics
        LessonSection(
            id: "gameplay",
            title: "How the Game Works",
            subtitle: "Section 1, Unit 2",
            color: Color(hex: "#1565C0"), // Blue - learning mechanics
            startOrderIndex: 4,
            endOrderIndex: 11
        ),

        // Section 3: Meet the Players (OP1, OP2, DP1, DP2 + Positions Quiz)
        // Covers: All offensive and defensive positions
        LessonSection(
            id: "positions",
            title: "Meet the Players",
            subtitle: "Section 1, Unit 3",
            color: Color(hex: "#E65100"), // Orange - energy, players in action
            startOrderIndex: 12,
            endOrderIndex: 16
        ),

        // Section 4: When Things Go Wrong (TO1, TO2, CP1, CP2 + Turnovers/Penalties Quiz)
        // Covers: Turnovers and common penalties - disruptions to normal play
        LessonSection(
            id: "disruptions",
            title: "When Things Go Wrong",
            subtitle: "Section 1, Unit 4",
            color: Color(hex: "#C62828"), // Red - caution, disruptions
            startOrderIndex: 17,
            endOrderIndex: 21
        ),

        // Section 5: The Full Picture (GS1, GS2, ST1, ST2 + Game Structure Quiz + Final Test)
        // Covers: Game structure, special teams, and comprehensive final assessment
        LessonSection(
            id: "complete",
            title: "The Full Picture",
            subtitle: "Section 1, Unit 5",
            color: Color(hex: "#7B1FA2"), // Purple - mastery, completion
            startOrderIndex: 22,
            endOrderIndex: 27
        )
    ]

    /// Find the section for a given lesson order index
    static func section(for orderIndex: Int, in sections: [LessonSection] = footballRookieSections) -> LessonSection? {
        sections.first { $0.contains(lessonOrderIndex: orderIndex) }
    }

    /// Default section to show when no lessons are visible
    static let defaultSection = footballRookieSections[0]
}
