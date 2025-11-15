//
//  ReviewViewModel.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

@Observable
class ReviewViewModel {
    private let sportId: UUID
    private let userId: UUID

    var isLoading = false
    var dueCards: [ReviewCard] = []
    var currentCardIndex = 0
    var reviewSession: ReviewSession?
    var showFeedback = false
    var lastAnswerCorrect = false

    var currentCard: ReviewCard? {
        guard currentCardIndex < dueCards.count else { return nil }
        return dueCards[currentCardIndex]
    }

    var progress: Double {
        guard !dueCards.isEmpty else { return 0 }
        return Double(currentCardIndex) / Double(dueCards.count)
    }

    var cardsRemaining: Int {
        max(0, dueCards.count - currentCardIndex)
    }

    init(sportId: UUID, userId: UUID) {
        self.sportId = sportId
        self.userId = userId
    }

    @MainActor
    func loadDueCards() async {
        isLoading = true

        // Simulate loading
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Mock data - in real app, fetch from repository
        dueCards = ReviewCard.mockCards.filter { $0.isDue }

        // Start review session
        reviewSession = ReviewSession(
            id: UUID(),
            userId: userId,
            sportId: sportId,
            startedAt: Date(),
            completedAt: nil,
            cardsReviewed: 0,
            correctAnswers: 0,
            xpEarned: 0
        )

        isLoading = false
    }

    func submitReview(isCorrect: Bool, timeSpent: TimeInterval = 10) {
        guard var card = currentCard else { return }

        let quality = ReviewCard.qualityFromCorrectness(
            isCorrect: isCorrect,
            timeSpent: timeSpent
        )

        card.recordReview(quality: quality)
        dueCards[currentCardIndex] = card

        lastAnswerCorrect = isCorrect
        showFeedback = true

        // Update session
        reviewSession?.cardsReviewed += 1
        if isCorrect {
            reviewSession?.correctAnswers += 1
            reviewSession?.xpEarned += 5
        }
    }

    func nextCard() {
        currentCardIndex += 1
        showFeedback = false
        lastAnswerCorrect = false

        if currentCardIndex >= dueCards.count {
            completeSession()
        }
    }

    private func completeSession() {
        reviewSession?.completedAt = Date()
    }
}
