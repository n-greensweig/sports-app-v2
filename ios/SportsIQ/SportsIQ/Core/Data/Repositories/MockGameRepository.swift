//
//  MockGameRepository.swift
//  SportsIQ
//
//  Created on 2025-11-17.
//

import Foundation

/// Mock implementation of GameRepository for development and testing
class MockGameRepository: GameRepository {

    func getGames(date: Date, sportId: UUID) async throws -> [Game] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Return empty array for now (can add mock games later if needed)
        return []
    }

    func getGame(id: UUID) async throws -> Game? {
        try await Task.sleep(nanoseconds: 300_000_000)

        // Return nil for now (can add mock game later if needed)
        return nil
    }

    func connectToLiveGame(gameId: UUID) -> AsyncThrowingStream<LivePrompt, Error> {
        // Return an empty stream for mock
        return AsyncThrowingStream { continuation in
            // No prompts emitted in mock
        }
    }

    func submitLiveAnswer(
        userId: UUID,
        gameId: UUID,
        itemId: UUID,
        answer: UserAnswer
    ) async throws -> Submission {
        try await Task.sleep(nanoseconds: 500_000_000)

        // Return a mock submission
        return Submission(
            id: UUID(),
            userId: userId,
            itemId: itemId,
            context: .liveGame,
            userAnswer: answer,
            isCorrect: true, // Mock always correct
            timeSpentSeconds: 5,
            xpAwarded: 15,
            submittedAt: Date()
        )
    }
}
