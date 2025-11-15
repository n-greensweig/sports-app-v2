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
    // MARK: - Football Basics Module Lessons
    static let footballBasicsLesson1 = Lesson(
        id: UUID(uuidString: "00000001-0000-0000-0000-000000000001")!,
        moduleId: Module.footballBasics.id,
        title: "The Field & Players",
        description: "Learn about the football field and how many players are on each team",
        orderIndex: 1,
        estimatedMinutes: 5,
        xpAward: 50,
        isLocked: false,
        items: [
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000001")!,
                type: .mcq,
                orderIndex: 1,
                prompt: "How many players are on the field for one team in American Football?",
                options: ["9", "11", "12", "15"],
                correctAnswer: .single(1),
                explanation: "Each team has 11 players on the field at a time.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000001")!,
                type: .slider,
                orderIndex: 2,
                prompt: "How many yards is the football field (excluding end zones)?",
                options: nil,
                correctAnswer: .range(min: 95, max: 105),
                explanation: "The football field is 100 yards long, not including the 10-yard end zones on each end.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000001")!,
                type: .binary,
                orderIndex: 3,
                prompt: "Each end zone is 10 yards deep.",
                options: ["True", "False"],
                correctAnswer: .boolean(true),
                explanation: "Correct! Each end zone is exactly 10 yards deep.",
                xpValue: 10
            )
        ]
    )

    static let footballBasicsLesson2 = Lesson(
        id: UUID(uuidString: "00000001-0000-0000-0000-000000000002")!,
        moduleId: Module.footballBasics.id,
        title: "Scoring Basics",
        description: "Understand how points are scored in football",
        orderIndex: 2,
        estimatedMinutes: 5,
        xpAward: 50,
        isLocked: false,
        items: [
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000002")!,
                type: .binary,
                orderIndex: 1,
                prompt: "A touchdown is worth 6 points.",
                options: ["True", "False"],
                correctAnswer: .boolean(true),
                explanation: "That's correct! A touchdown is worth 6 points, with the opportunity for an extra point or 2-point conversion.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000002")!,
                type: .multiSelect,
                orderIndex: 2,
                prompt: "Which of these are ways to score in football? Select all that apply.",
                options: ["Touchdown", "Field Goal", "Home Run", "Safety", "Grand Slam"],
                correctAnswer: .multiple([0, 1, 3]),
                explanation: "Touchdown, Field Goal, and Safety are all valid ways to score in football. Home Run and Grand Slam are baseball terms.",
                xpValue: 15
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000002")!,
                type: .mcq,
                orderIndex: 3,
                prompt: "How many points is a field goal worth?",
                options: ["1 point", "2 points", "3 points", "6 points"],
                correctAnswer: .single(2),
                explanation: "A field goal is worth 3 points.",
                xpValue: 10
            )
        ]
    )

    static let footballBasicsLesson3 = Lesson(
        id: UUID(uuidString: "00000001-0000-0000-0000-000000000003")!,
        moduleId: Module.footballBasics.id,
        title: "Offensive Positions",
        description: "Learn about the key offensive positions",
        orderIndex: 3,
        estimatedMinutes: 5,
        xpAward: 50,
        isLocked: false,
        items: [
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000003")!,
                type: .mcq,
                orderIndex: 1,
                prompt: "Which position typically throws the ball?",
                options: ["Running Back", "Quarterback", "Wide Receiver", "Center"],
                correctAnswer: .single(1),
                explanation: "The Quarterback (QB) is the player who throws the ball on most passing plays.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000003")!,
                type: .freeText,
                orderIndex: 2,
                prompt: "What is the abbreviation for the Quarterback position?",
                options: nil,
                correctAnswer: .text("QB"),
                explanation: "QB stands for Quarterback, the most important offensive position.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000003")!,
                type: .multiSelect,
                orderIndex: 3,
                prompt: "Select all positions that are part of the offensive line:",
                options: ["Center", "Linebacker", "Guard", "Tackle", "Safety"],
                correctAnswer: .multiple([0, 2, 3]),
                explanation: "The offensive line consists of Center, Guards, and Tackles. Linebacker and Safety are defensive positions.",
                xpValue: 15
            )
        ]
    )

    static let footballBasicsLesson4 = Lesson(
        id: UUID(uuidString: "00000001-0000-0000-0000-000000000004")!,
        moduleId: Module.footballBasics.id,
        title: "Defensive Positions",
        description: "Understand the key defensive positions",
        orderIndex: 4,
        estimatedMinutes: 5,
        xpAward: 50,
        isLocked: false,
        items: [
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000004")!,
                type: .mcq,
                orderIndex: 1,
                prompt: "Which defensive position typically covers wide receivers?",
                options: ["Linebacker", "Defensive Tackle", "Cornerback", "Defensive End"],
                correctAnswer: .single(2),
                explanation: "Cornerbacks (CBs) are responsible for covering wide receivers in pass coverage.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000004")!,
                type: .binary,
                orderIndex: 2,
                prompt: "Linebackers play behind the defensive line.",
                options: ["True", "False"],
                correctAnswer: .boolean(true),
                explanation: "Correct! Linebackers position themselves behind the defensive line and can defend both the run and pass.",
                xpValue: 10
            )
        ]
    )

    static let footballBasicsLesson5 = Lesson(
        id: UUID(uuidString: "00000001-0000-0000-0000-000000000005")!,
        moduleId: Module.footballBasics.id,
        title: "Downs and Distance",
        description: "Learn about the down system and gaining yards",
        orderIndex: 5,
        estimatedMinutes: 5,
        xpAward: 50,
        isLocked: false,
        items: [
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000005")!,
                type: .slider,
                orderIndex: 1,
                prompt: "How many yards must the offense gain to achieve a first down?",
                options: nil,
                correctAnswer: .range(min: 8, max: 12),
                explanation: "The offense must gain 10 yards within 4 downs to get a first down.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000005")!,
                type: .mcq,
                orderIndex: 2,
                prompt: "How many downs does a team get to advance 10 yards?",
                options: ["2", "3", "4", "5"],
                correctAnswer: .single(2),
                explanation: "Teams get 4 downs (attempts) to advance the ball 10 yards for a first down.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000005")!,
                type: .binary,
                orderIndex: 3,
                prompt: "If you don't gain 10 yards in 4 downs, you lose possession.",
                options: ["True", "False"],
                correctAnswer: .boolean(true),
                explanation: "That's right! If the offense fails to gain 10 yards in 4 downs, possession goes to the other team (unless they punt).",
                xpValue: 10
            )
        ]
    )

    static let footballBasicsLesson6 = Lesson(
        id: UUID(uuidString: "00000001-0000-0000-0000-000000000006")!,
        moduleId: Module.footballBasics.id,
        title: "Game Clock & Quarters",
        description: "Understand how time works in football",
        orderIndex: 6,
        estimatedMinutes: 4,
        xpAward: 40,
        isLocked: false,
        items: [
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000006")!,
                type: .mcq,
                orderIndex: 1,
                prompt: "How many quarters are in a football game?",
                options: ["2", "3", "4", "5"],
                correctAnswer: .single(2),
                explanation: "A football game has 4 quarters.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000006")!,
                type: .slider,
                orderIndex: 2,
                prompt: "How many minutes is each quarter in the NFL?",
                options: nil,
                correctAnswer: .range(min: 13, max: 17),
                explanation: "Each quarter in the NFL is 15 minutes long.",
                xpValue: 10
            )
        ]
    )

    static let footballBasicsLesson7 = Lesson(
        id: UUID(uuidString: "00000001-0000-0000-0000-000000000007")!,
        moduleId: Module.footballBasics.id,
        title: "Turnovers",
        description: "Learn about fumbles and interceptions",
        orderIndex: 7,
        estimatedMinutes: 5,
        xpAward: 50,
        isLocked: false,
        items: [
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000007")!,
                type: .multiSelect,
                orderIndex: 1,
                prompt: "Which of these are types of turnovers? Select all that apply.",
                options: ["Fumble", "Touchdown", "Interception", "Field Goal", "Turnover on Downs"],
                correctAnswer: .multiple([0, 2, 4]),
                explanation: "Fumbles, Interceptions, and Turnovers on Downs are all ways the offense can lose possession. Touchdowns and Field Goals are scoring plays.",
                xpValue: 15
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000007")!,
                type: .binary,
                orderIndex: 2,
                prompt: "An interception occurs when the defense catches a pass.",
                options: ["True", "False"],
                correctAnswer: .boolean(true),
                explanation: "Correct! An interception happens when a defensive player catches a pass intended for an offensive player.",
                xpValue: 10
            )
        ]
    )

    static let footballBasicsLesson8 = Lesson(
        id: UUID(uuidString: "00000001-0000-0000-0000-000000000008")!,
        moduleId: Module.footballBasics.id,
        title: "Extra Points & 2-Point Conversions",
        description: "Learn about scoring after a touchdown",
        orderIndex: 8,
        estimatedMinutes: 4,
        xpAward: 40,
        isLocked: false,
        items: [
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000008")!,
                type: .mcq,
                orderIndex: 1,
                prompt: "How many points is an extra point kick worth?",
                options: ["1 point", "2 points", "3 points", "6 points"],
                correctAnswer: .single(0),
                explanation: "An extra point (PAT - Point After Touchdown) is worth 1 point when kicked.",
                xpValue: 10
            ),
            Item(
                id: UUID(),
                lessonId: UUID(uuidString: "00000001-0000-0000-0000-000000000008")!,
                type: .binary,
                orderIndex: 2,
                prompt: "A 2-point conversion requires getting the ball into the end zone.",
                options: ["True", "False"],
                correctAnswer: .boolean(true),
                explanation: "That's right! A 2-point conversion attempt requires running or passing the ball into the end zone from the 2-yard line.",
                xpValue: 10
            )
        ]
    )

    static let mockLessons = [
        footballBasicsLesson1,
        footballBasicsLesson2,
        footballBasicsLesson3,
        footballBasicsLesson4,
        footballBasicsLesson5,
        footballBasicsLesson6,
        footballBasicsLesson7,
        footballBasicsLesson8
    ]
}
