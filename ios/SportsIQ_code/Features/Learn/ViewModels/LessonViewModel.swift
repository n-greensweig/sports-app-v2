//
//  LessonViewModel.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

@Observable
class LessonViewModel {
    // MARK: - Dependencies
    private let lesson: Lesson
    private let userId: UUID
    private let learningRepository: LearningRepository

    // MARK: - State
    var currentItemIndex = 0
    var selectedAnswer: Int?
    var showFeedback = false
    var isCurrentAnswerCorrect = false
    var correctAnswersCount = 0
    var submissions: [Submission] = []

    var currentItem: Item? {
        guard currentItemIndex < lesson.items.count else { return nil }
        return lesson.items[currentItemIndex]
    }

    var progress: Double {
        guard !lesson.items.isEmpty else { return 0 }
        return Double(currentItemIndex) / Double(lesson.items.count)
    }

    var isLastItem: Bool {
        currentItemIndex == lesson.items.count - 1
    }

    init(lesson: Lesson, userId: UUID, learningRepository: LearningRepository) {
        self.lesson = lesson
        self.userId = userId
        self.learningRepository = learningRepository
    }

    func selectAnswer(_ index: Int) {
        selectedAnswer = index
    }

    @MainActor
    func submitAnswer() async {
        guard let selectedAnswer = selectedAnswer,
              let currentItem = currentItem else { return }

        // Check if answer is correct
        switch currentItem.correctAnswer {
        case .single(let correctIndex):
            isCurrentAnswerCorrect = selectedAnswer == correctIndex
        case .boolean(let correctBool):
            isCurrentAnswerCorrect = (selectedAnswer == 0 && correctBool) || (selectedAnswer == 1 && !correctBool)
        default:
            isCurrentAnswerCorrect = false
        }

        if isCurrentAnswerCorrect {
            correctAnswersCount += 1
        }

        // Submit to repository
        do {
            let submission = try await learningRepository.submitAnswer(
                userId: userId,
                itemId: currentItem.id,
                answer: .single(selectedAnswer),
                context: .lesson,
                timeSpentSeconds: 10 // TODO: Track actual time
            )
            submissions.append(submission)
        } catch {
            print("Error submitting answer: \(error)")
        }

        showFeedback = true
    }

    func nextItem() {
        currentItemIndex += 1
        selectedAnswer = nil
        showFeedback = false
        isCurrentAnswerCorrect = false
    }
}
