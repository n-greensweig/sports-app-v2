//
//  Lesson.swift
//  Ola Ball
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

    // New fields for multi-completion system
    let code: String?                // Short code like "TF1", "OT1"
    let itemsPerSession: Int         // Questions shown per completion (default 5)
    let requiredCompletions: Int     // Completions needed to master (default 5)

    init(
        id: UUID,
        moduleId: UUID,
        title: String,
        description: String,
        orderIndex: Int,
        estimatedMinutes: Int,
        xpAward: Int,
        isLocked: Bool = false,
        items: [Item] = [],
        code: String? = nil,
        itemsPerSession: Int = 5,
        requiredCompletions: Int = 5
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
        self.code = code
        self.itemsPerSession = itemsPerSession
        self.requiredCompletions = requiredCompletions
    }
}

// MARK: - Mock Data
extension Lesson {
    // MARK: - Rookie Section: The Field 1 (TF1)
    // Topics: Dimensions, markings (yard lines), goal lines, end zones
    // 13 questions total, 5 shown per session for variety

    private static let tf1LessonId = UUID(uuidString: "00000001-0000-0000-0000-000000000001")!

    static let theField1 = Lesson(
        id: tf1LessonId,
        moduleId: Module.footballBasics.id,
        title: "The Field 1",
        description: "Learn about field dimensions, yard lines, goal lines, and end zones",
        orderIndex: 1,
        estimatedMinutes: 4,
        xpAward: 50,
        isLocked: false,
        items: tf1Items,
        code: "TF1",
        itemsPerSession: 5,
        requiredCompletions: 5
    )

    private static let tf1Items: [Item] = [
        // Q1: Field length (Dimensions)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000001")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 1,
            prompt: "How long is a football field from goal line to goal line?",
            options: ["80 yards", "100 yards", "120 yards", "150 yards"],
            correctAnswer: .single(1),
            explanation: "A football field is exactly 100 yards (300 feet) from goal line to goal line. The end zones add another 10 yards on each side.",
            xpValue: 10
        ),

        // Q2: Field width (Dimensions)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000002")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 2,
            prompt: "How wide is a regulation football field?",
            options: ["40 yards", "53⅓ yards", "60 yards", "75 yards"],
            correctAnswer: .single(1),
            explanation: "A regulation football field is 53⅓ yards (160 feet) wide. This width is the same for both NFL and college football.",
            xpValue: 10
        ),

        // Q3: End zone depth (End zones)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000003")!,
            lessonId: tf1LessonId,
            type: .binary,
            orderIndex: 3,
            prompt: "Each end zone is 10 yards deep.",
            options: ["True", "False"],
            correctAnswer: .boolean(true),
            explanation: "Correct! Each end zone extends 10 yards beyond the goal line, adding 20 total yards to the field's overall length of 120 yards.",
            xpValue: 10
        ),

        // Q4: Yard line markings (Markings)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000004")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 4,
            prompt: "Yard lines are marked on the field every how many yards?",
            options: ["1 yard", "5 yards", "10 yards", "20 yards"],
            correctAnswer: .single(1),
            explanation: "Yard lines are painted across the field every 5 yards. Numbers are displayed every 10 yards to help players and fans track field position.",
            xpValue: 10
        ),

        // Q5: Goal line definition (Goal lines)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000005")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 5,
            prompt: "What does a player need to do to score a touchdown?",
            options: [
                "Touch the goal line",
                "Cross the goal line with the ball",
                "Throw the ball over the goal line",
                "Kick the ball through the uprights"
            ],
            correctAnswer: .single(1),
            explanation: "To score a touchdown, the ball must cross (or \"break the plane of\") the goal line while in a player's possession. The goal line is the front edge of the end zone.",
            xpValue: 10
        ),

        // Q6: Total field length including end zones (Dimensions)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000006")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 6,
            prompt: "Including both end zones, how long is a football field in total?",
            options: ["100 yards", "110 yards", "120 yards", "130 yards"],
            correctAnswer: .single(2),
            explanation: "The total length is 120 yards: 100 yards of playing field plus two 10-yard end zones (one at each end).",
            xpValue: 10
        ),

        // Q7: Numbered yard lines (Markings)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000007")!,
            lessonId: tf1LessonId,
            type: .binary,
            orderIndex: 7,
            prompt: "The 50-yard line is at the exact center of the field.",
            options: ["True", "False"],
            correctAnswer: .boolean(true),
            explanation: "The 50-yard line marks the midfield point, exactly halfway between both goal lines. Yard numbers count down from 50 toward each end zone (50, 40, 30, 20, 10).",
            xpValue: 10
        ),

        // Q8: End zone purpose (End zones)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000008")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 8,
            prompt: "What is the primary purpose of the end zone?",
            options: [
                "A rest area for tired players",
                "The scoring area for touchdowns",
                "Where the coaches stand",
                "A warmup area before plays"
            ],
            correctAnswer: .single(1),
            explanation: "The end zone is the scoring area! When an offensive player carries or catches the ball in the end zone, their team scores a touchdown (6 points).",
            xpValue: 10
        ),

        // Q9: Goal line location (Goal lines)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000009")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 9,
            prompt: "Where is the goal line located?",
            options: [
                "In the middle of the end zone",
                "At the back of the end zone",
                "At the front edge of the end zone",
                "Behind the goalposts"
            ],
            correctAnswer: .single(2),
            explanation: "The goal line is at the front edge of the end zone, separating the 100-yard playing field from the end zone. It's the line a player must cross to score a touchdown.",
            xpValue: 10
        ),

        // Q10: Hash marks (Markings)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000010")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 10,
            prompt: "What are the short lines between the yard line numbers called?",
            options: ["Sidelines", "Hash marks", "Goal markers", "Field stripes"],
            correctAnswer: .single(1),
            explanation: "Hash marks are the short lines that run parallel to the sidelines. They mark where the ball is placed for each play and help players and officials align properly.",
            xpValue: 10
        ),

        // Q11: Goal line color (Goal lines)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000011")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 11,
            prompt: "What color is the goal line typically painted?",
            options: ["Yellow", "Blue", "White", "Red"],
            correctAnswer: .single(2),
            explanation: "The goal line is painted white, like most field markings. It marks the boundary between the playing field and the end zone.",
            xpValue: 10
        ),

        // Q12: End zone location (End zones)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000012")!,
            lessonId: tf1LessonId,
            type: .mcq,
            orderIndex: 12,
            prompt: "Where are the end zones located on a football field?",
            options: [
                "In the middle of the field",
                "On the sidelines",
                "At each end of the 100-yard field",
                "Behind the bleachers"
            ],
            correctAnswer: .single(2),
            explanation: "The end zones are the 10-yard areas at each end of the 100-yard playing field. A team scores a touchdown by getting the ball into their opponent's end zone.",
            xpValue: 10
        ),

        // Q13: Yard numbers direction (Markings)
        Item(
            id: UUID(uuidString: "00000001-0001-0000-0000-000000000013")!,
            lessonId: tf1LessonId,
            type: .binary,
            orderIndex: 13,
            prompt: "From the 50-yard line, yard numbers count down toward each end zone.",
            options: ["True", "False"],
            correctAnswer: .boolean(true),
            explanation: "Correct! The yard numbers go 50, 40, 30, 20, 10 as you move from midfield toward either end zone. This helps players and fans quickly understand field position.",
            xpValue: 10
        )
    ]

    // Keep legacy reference for backwards compatibility
    static let footballBasicsLesson1 = theField1

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

    // MARK: - Rookie Section: Offensive Terms 1 (OT1)
    // Topics: Run, pass, catch, first down
    // 10 questions total, 5 shown per session for variety

    private static let ot1LessonId = UUID(uuidString: "00000001-0000-0000-0000-000000000003")!

    static let offensiveTerms1 = Lesson(
        id: ot1LessonId,
        moduleId: Module.footballBasics.id,
        title: "Offensive Terms 1",
        description: "Learn the basic offensive plays: running, passing, catching, and what a first down means",
        orderIndex: 3,
        estimatedMinutes: 4,
        xpAward: 50,
        isLocked: true,
        items: ot1Items,
        code: "OT1",
        itemsPerSession: 5,
        requiredCompletions: 5
    )

    private static let ot1Items: [Item] = [
        // Q1: What is a run play? (Run)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000001")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 1,
            prompt: "What is a \"run play\" in football?",
            options: [
                "When a player kicks the ball downfield",
                "When a player carries the ball and runs with it",
                "When the quarterback throws the ball to a receiver",
                "When the defense tackles the quarterback"
            ],
            correctAnswer: .single(1),
            explanation: "A run play is when a player (usually a running back) carries the ball and runs with it, trying to gain yards by advancing down the field on foot rather than through a pass.",
            xpValue: 10
        ),

        // Q2: What is a pass play? (Pass)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000002")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 2,
            prompt: "What is a \"pass play\" in football?",
            options: [
                "When a player runs with the ball",
                "When the ball is kicked through the uprights",
                "When the quarterback throws the ball to a teammate",
                "When the defense intercepts the ball"
            ],
            correctAnswer: .single(2),
            explanation: "A pass play is when the quarterback throws the ball to a teammate (usually a wide receiver or tight end) who attempts to catch it and gain yards.",
            xpValue: 10
        ),

        // Q3: What is a catch? (Catch)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000003")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 3,
            prompt: "What must happen for a receiver to be credited with a \"catch\"?",
            options: [
                "Secure the ball with control and get both feet inbounds",
                "Touch the ball with one hand",
                "Have the ball hit their body",
                "Run a route downfield"
            ],
            correctAnswer: .single(0),
            explanation: "For a legal catch, the receiver must secure control of the ball and get both feet (NFL) or one foot (college) inbounds. If the ball touches the ground or the receiver goes out of bounds before establishing possession, it's incomplete.",
            xpValue: 10
        ),

        // Q4: What is a first down? (First Down)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000004")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 4,
            prompt: "What is a \"first down\" in football?",
            options: [
                "The first play of the game",
                "When the offense gains 10 yards and gets a new set of 4 downs",
                "When the defense stops the offense",
                "The first quarter of the game"
            ],
            correctAnswer: .single(1),
            explanation: "A first down occurs when the offense advances the ball at least 10 yards from where the previous set of downs started. This gives the team a new set of 4 downs to try to gain another 10 yards.",
            xpValue: 10
        ),

        // Q5: How many downs to get a first down? (First Down)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000005")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 5,
            prompt: "How many attempts (downs) does an offense have to gain 10 yards for a first down?",
            options: ["2 downs", "3 downs", "5 downs", "4 downs"],
            correctAnswer: .single(3),
            explanation: "The offense has 4 downs (attempts) to gain 10 yards. If they succeed, they get a new first down. If they fail, the other team gets the ball.",
            xpValue: 10
        ),

        // Q6: True/False - Run vs Pass (Run/Pass)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000006")!,
            lessonId: ot1LessonId,
            type: .binary,
            orderIndex: 6,
            prompt: "On a run play, the quarterback always carries the ball himself.",
            options: ["True", "False"],
            correctAnswer: .boolean(false),
            explanation: "False! While quarterbacks can run with the ball, most run plays involve a handoff to a running back who then carries the ball. The running back is typically the primary ball carrier on run plays.",
            xpValue: 10
        ),

        // Q7: Who typically throws passes? (Pass)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000007")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 7,
            prompt: "Which player typically throws the ball on a pass play?",
            options: ["Quarterback", "Wide receiver", "Running back", "Linebacker"],
            correctAnswer: .single(0),
            explanation: "The quarterback is the primary passer on the team. They take the snap and throw the ball to receivers downfield. Occasionally other players throw passes on trick plays, but this is rare.",
            xpValue: 10
        ),

        // Q8: Situational - First down scenario (First Down)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000008")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 8,
            prompt: "The Dallas Cowboys have the ball at their own 30-yard line. It's 1st and 10. The running back gains 6 yards. What down is it now?",
            options: ["1st and 4", "2nd and 4", "2nd and 10", "1st and 10"],
            correctAnswer: .single(1),
            explanation: "After gaining 6 yards on 1st down, it's now 2nd down with 4 yards to go for a first down (10 - 6 = 4). The offense still needs 4 more yards to earn a new set of downs.",
            xpValue: 10
        ),

        // Q9: Situational - First down achieved (First Down)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000009")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 9,
            prompt: "The Kansas City Chiefs have the ball at the 50-yard line. It's 2nd and 8. Patrick Mahomes throws a 15-yard pass to Travis Kelce. What happens next?",
            options: [
                "First down! New set of 4 downs at the opponent's 35",
                "3rd and 7 at the opponent's 35",
                "2nd and 8 at the 50",
                "Touchdown"
            ],
            correctAnswer: .single(0),
            explanation: "The 15-yard gain exceeds the 8 yards needed for a first down, so the Chiefs get a new set of 4 downs. The ball is now at the opponent's 35-yard line (50 - 15 = 35).",
            xpValue: 10
        ),

        // Q10: Situational - Run play result (Run/First Down)
        Item(
            id: UUID(uuidString: "00000003-0001-0000-0000-000000000010")!,
            lessonId: ot1LessonId,
            type: .mcq,
            orderIndex: 10,
            prompt: "The Philadelphia Eagles are on 3rd down with 2 yards to go for a first down. The running back takes a handoff and runs for 3 yards. What is the result?",
            options: [
                "4th and short",
                "Incomplete pass",
                "First down! New set of 4 downs",
                "Turnover on downs"
            ],
            correctAnswer: .single(2),
            explanation: "The Eagles gained 3 yards on a run play, which is more than the 2 yards they needed for a first down. They now have a fresh set of 4 downs to continue their drive.",
            xpValue: 10
        )
    ]

    // Keep legacy reference for backwards compatibility
    static let footballBasicsLesson3 = offensiveTerms1

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
