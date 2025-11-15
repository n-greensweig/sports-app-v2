//
//  GameRepository.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Represents a live game
struct LiveGame: Identifiable, Codable, Hashable {
    let id: UUID
    let sportId: UUID
    let homeTeam: String
    let awayTeam: String
    let scheduledAt: Date
    let status: GameStatus
}

enum GameStatus: String, Codable, Hashable {
    case scheduled = "scheduled"
    case inProgress = "in_progress"
    case halftime = "halftime"
    case completed = "completed"
}

/// Protocol for game-related data operations (Live Mode)
protocol GameRepository {
    /// Get games for a specific date
    func getGames(date: Date, sportId: UUID) async throws -> [LiveGame]

    /// Get a specific game by ID
    func getGame(id: UUID) async throws -> LiveGame?

    /// Connect to live game updates (returns async stream)
    func connectToLiveGame(gameId: UUID) -> AsyncThrowingStream<Item, Error>

    /// Submit answer for a live game prompt
    func submitLiveAnswer(
        userId: UUID,
        gameId: UUID,
        itemId: UUID,
        answer: UserAnswer
    ) async throws -> Submission
}
