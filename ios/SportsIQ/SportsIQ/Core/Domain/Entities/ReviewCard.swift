//
//  ReviewCard.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Spaced Repetition System (SRS) card for reviewing learned content
struct ReviewCard: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let itemId: UUID
    let sportId: UUID
    var dueDate: Date
    var interval: TimeInterval // in seconds
    var easeFactor: Double // 1.3 to 2.5 (SM-2 algorithm)
    var repetitions: Int
    let createdAt: Date
    var lastReviewedAt: Date?

    var isDue: Bool {
        dueDate <= Date()
    }

    /// Update card based on review quality (SM-2 algorithm)
    /// - Parameter quality: 0 (complete blackout) to 5 (perfect response)
    mutating func recordReview(quality: Int) {
        let q = max(0, min(5, quality)) // Clamp to 0-5

        // Update ease factor (SM-2 algorithm)
        let qualityDiff = Double(5 - q)
        let innerCalc = 0.08 + qualityDiff * 0.02
        let adjustment = 0.1 - qualityDiff * innerCalc
        let newEaseFactor = easeFactor + adjustment
        easeFactor = max(1.3, newEaseFactor)

        // Update repetitions and interval
        if q < 3 {
            // Incorrect answer: reset
            repetitions = 0
            interval = 600 // 10 minutes
        } else {
            // Correct answer: increase interval
            if repetitions == 0 {
                interval = 86400 // 1 day
            } else if repetitions == 1 {
                interval = 86400 * 6 // 6 days
            } else {
                interval = interval * easeFactor
            }
            repetitions += 1
        }

        // Update due date
        dueDate = Date().addingTimeInterval(interval)
        lastReviewedAt = Date()
    }

    /// Convert answer correctness to quality score
    static func qualityFromCorrectness(isCorrect: Bool, timeSpent: TimeInterval, difficulty: Int = 3) -> Int {
        if !isCorrect {
            return 0
        }

        // Fast correct answer = higher quality
        if timeSpent < 5 {
            return 5
        } else if timeSpent < 10 {
            return 4
        } else {
            return 3
        }
    }
}

/// Review session tracking
struct ReviewSession: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let sportId: UUID
    let startedAt: Date
    var completedAt: Date?
    var cardsReviewed: Int
    var correctAnswers: Int
    var xpEarned: Int

    var accuracy: Double {
        guard cardsReviewed > 0 else { return 0 }
        return Double(correctAnswers) / Double(cardsReviewed)
    }

    var duration: TimeInterval {
        let end = completedAt ?? Date()
        return end.timeIntervalSince(startedAt)
    }
}

// MARK: - Mock Data
extension ReviewCard {
    static let mockCard1 = ReviewCard(
        id: UUID(),
        userId: UUID(),
        itemId: UUID(),
        sportId: Sport.football.id,
        dueDate: Date().addingTimeInterval(-3600), // Due 1 hour ago
        interval: 86400,
        easeFactor: 2.5,
        repetitions: 2,
        createdAt: Date().addingTimeInterval(-86400 * 7), // Created 7 days ago
        lastReviewedAt: Date().addingTimeInterval(-3600)
    )

    static let mockCard2 = ReviewCard(
        id: UUID(),
        userId: UUID(),
        itemId: UUID(),
        sportId: Sport.football.id,
        dueDate: Date(), // Due now
        interval: 86400 * 6,
        easeFactor: 2.3,
        repetitions: 3,
        createdAt: Date().addingTimeInterval(-86400 * 30), // Created 30 days ago
        lastReviewedAt: Date().addingTimeInterval(-86400 * 6)
    )

    static let mockCards = [mockCard1, mockCard2]
}
