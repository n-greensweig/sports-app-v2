//
//  GameRepository.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Protocol for game-related data operations (Live Mode)
protocol GameRepository {
    /// Get games for a specific date
    func getGames(date: Date, sportId: UUID) async throws -> [Game]

    /// Get a specific game by ID
    func getGame(id: UUID) async throws -> Game?

    /// Connect to live game updates (returns async stream)
    func connectToLiveGame(gameId: UUID) -> AsyncThrowingStream<LivePrompt, Error>

    /// Submit answer for a live game prompt
    func submitLiveAnswer(
        userId: UUID,
        gameId: UUID,
        itemId: UUID,
        answer: UserAnswer
    ) async throws -> Submission
}
