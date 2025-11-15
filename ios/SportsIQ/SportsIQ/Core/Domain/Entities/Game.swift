//
//  Game.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Status of a live game
enum GameStatus: String, Codable {
    case scheduled
    case inProgress = "in_progress"
    case halftime
    case final
    case postponed
    case cancelled
}

/// Live game entity
struct Game: Identifiable, Codable, Hashable {
    let id: UUID
    let sportId: UUID
    let homeTeam: Team
    let awayTeam: Team
    let scheduledTime: Date
    let status: GameStatus
    let currentQuarter: Int?
    let timeRemaining: String?
    let homeScore: Int
    let awayScore: Int
    let venue: String

    var isLive: Bool {
        status == .inProgress || status == .halftime
    }

    var canAskQuestions: Bool {
        isLive
    }
}

/// Team information
struct Team: Codable, Hashable {
    let id: UUID
    let name: String
    let shortName: String
    let logoURL: String?
    let primaryColorHex: String

    init(id: UUID, name: String, shortName: String, logoURL: String? = nil, primaryColorHex: String) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.logoURL = logoURL
        self.primaryColorHex = primaryColorHex
    }
}

/// Live prompt shown during a game
struct LivePrompt: Identifiable, Codable {
    let id: UUID
    let gameId: UUID
    let prompt: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let timestamp: Date
    let gameContext: String // e.g., "After QB sacked"
    let difficulty: PromptDifficulty
    let xpValue: Int

    enum PromptDifficulty: String, Codable {
        case beginner
        case intermediate
        case advanced
    }

    init(
        id: UUID = UUID(),
        gameId: UUID,
        prompt: String,
        options: [String],
        correctAnswer: Int,
        explanation: String,
        timestamp: Date = Date(),
        gameContext: String,
        difficulty: PromptDifficulty = .intermediate,
        xpValue: Int? = nil
    ) {
        self.id = id
        self.gameId = gameId
        self.prompt = prompt
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.timestamp = timestamp
        self.gameContext = gameContext
        self.difficulty = difficulty
        self.xpValue = xpValue ?? difficulty.baseXP
    }
}

extension LivePrompt.PromptDifficulty {
    var baseXP: Int {
        switch self {
        case .beginner: return 10
        case .intermediate: return 15
        case .advanced: return 25
        }
    }
}

// MARK: - Mock Data
extension Team {
    static let chiefs = Team(
        id: UUID(),
        name: "Kansas City Chiefs",
        shortName: "KC",
        primaryColorHex: "#E31837"
    )

    static let bills = Team(
        id: UUID(),
        name: "Buffalo Bills",
        shortName: "BUF",
        primaryColorHex: "#00338D"
    )

    static let eagles = Team(
        id: UUID(),
        name: "Philadelphia Eagles",
        shortName: "PHI",
        primaryColorHex: "#004C54"
    )

    static let cowboys = Team(
        id: UUID(),
        name: "Dallas Cowboys",
        shortName: "DAL",
        primaryColorHex: "#041E42"
    )
}

extension Game {
    static let mockLiveGame = Game(
        id: UUID(),
        sportId: Sport.football.id,
        homeTeam: .chiefs,
        awayTeam: .bills,
        scheduledTime: Date(),
        status: .inProgress,
        currentQuarter: 2,
        timeRemaining: "8:47",
        homeScore: 17,
        awayScore: 14,
        venue: "Arrowhead Stadium"
    )

    static let mockScheduledGame = Game(
        id: UUID(),
        sportId: Sport.football.id,
        homeTeam: .eagles,
        awayTeam: .cowboys,
        scheduledTime: Date().addingTimeInterval(3600 * 4),
        status: .scheduled,
        currentQuarter: nil,
        timeRemaining: nil,
        homeScore: 0,
        awayScore: 0,
        venue: "Lincoln Financial Field"
    )

    static let mockGames = [mockLiveGame, mockScheduledGame]
}

extension LivePrompt {
    static let mockPrompt = LivePrompt(
        gameId: Game.mockLiveGame.id,
        prompt: "The offense just got a first down. What happens next?",
        options: [
            "They get 4 more downs to go 10 yards",
            "They automatically score points",
            "The other team gets the ball",
            "The game clock stops"
        ],
        correctAnswer: 0,
        explanation: "When a team gets a first down, the down counter resets and they get 4 new downs to try to advance another 10 yards.",
        gameContext: "1st & 10 from the 35-yard line",
        difficulty: .beginner
    )

    static let mockAdvancedPrompt = LivePrompt(
        gameId: Game.mockLiveGame.id,
        prompt: "The quarterback is in the shotgun formation. What does this tell you?",
        options: [
            "It's likely a running play",
            "It's likely a passing play",
            "They're going for a field goal",
            "They're punting"
        ],
        correctAnswer: 1,
        explanation: "Shotgun formation (QB stands 5-7 yards behind center) is typically used for passing plays because it gives the QB more time to read the defense and throw.",
        gameContext: "2nd & 7 from the 42-yard line",
        difficulty: .advanced,
        xpValue: 25
    )
}
