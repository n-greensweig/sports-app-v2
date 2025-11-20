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
    private let audioManager: AudioManager
    private let hapticManager: HapticManager

    // MARK: - State
    var currentItemIndex = 0
    var selectedAnswer: Int?
    var selectedAnswers: Set<Int> = [] // For multi-select
    var sliderValue: Double = 50 // For slider
    var textAnswer: String = "" // For free text
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

    init(
        lesson: Lesson,
        userId: UUID,
        learningRepository: LearningRepository,
        audioManager: AudioManager,
        hapticManager: HapticManager
    ) {
        self.lesson = lesson
        self.userId = userId
        self.learningRepository = learningRepository
        self.audioManager = audioManager
        self.hapticManager = hapticManager
    }

    func selectAnswer(_ index: Int) {
        selectedAnswer = index
    }

    func toggleMultiSelectAnswer(_ index: Int) {
        if selectedAnswers.contains(index) {
            selectedAnswers.remove(index)
        } else {
            selectedAnswers.insert(index)
        }
    }

    func updateSliderValue(_ value: Double) {
        sliderValue = value
    }

    func updateTextAnswer(_ text: String) {
        textAnswer = text
    }

    @MainActor
    func submitAnswer() async {
        guard let currentItem = currentItem else { return }

        // Determine user's answer based on item type
        let userAnswer: UserAnswer
        switch currentItem.type {
        case .mcq, .binary:
            guard let selectedAnswer = selectedAnswer else { return }
            userAnswer = .single(selectedAnswer)
        case .multiSelect:
            userAnswer = .multiple(Array(selectedAnswers).sorted())
        case .slider:
            userAnswer = .slider(sliderValue)
        case .freeText:
            userAnswer = .text(textAnswer.trimmingCharacters(in: .whitespacesAndNewlines))
        case .clipLabel:
            // TODO: Implement clip label
            return
        }

        // Check if answer is correct
        isCurrentAnswerCorrect = checkAnswer(userAnswer: userAnswer, correctAnswer: currentItem.correctAnswer)

        if isCurrentAnswerCorrect {
            correctAnswersCount += 1
            audioManager.playCorrectSound()
            hapticManager.playCorrectFeedback()
        } else {
            audioManager.playIncorrectSound()
            hapticManager.playIncorrectFeedback()
        }

        // Submit to repository
        do {
            let submission = try await learningRepository.submitAnswer(
                userId: userId,
                itemId: currentItem.id,
                answer: userAnswer,
                context: .lesson,
                timeSpentSeconds: 10 // TODO: Track actual time
            )
            submissions.append(submission)
        } catch {
            print("Error submitting answer: \(error)")
        }

        showFeedback = true
    }

    private func checkAnswer(userAnswer: UserAnswer, correctAnswer: ItemAnswer) -> Bool {
        switch (userAnswer, correctAnswer) {
        case (.single(let userIndex), .single(let correctIndex)):
            return userIndex == correctIndex
        case (.single(let userIndex), .boolean(let correctBool)):
            return (userIndex == 0 && correctBool) || (userIndex == 1 && !correctBool)
        case (.multiple(let userIndices), .multiple(let correctIndices)):
            return Set(userIndices) == Set(correctIndices)
        case (.slider(let userValue), .range(let min, let max)):
            return userValue >= min && userValue <= max
        case (.text(let userText), .text(let correctText)):
            return userText.lowercased() == correctText.lowercased()
        default:
            return false
        }
    }

    var showCompletionScreen = false
    
    var totalXPEarned: Int {
        // Base XP + Bonus for correct answers
        let baseXP = 10
        return baseXP + (correctAnswersCount * 10)
    }

    func nextItem() {
        if isLastItem {
            audioManager.playLessonCompleteSound()
            hapticManager.playLevelUpPattern()
            showCompletionScreen = true
            return
        }

        currentItemIndex += 1
        selectedAnswer = nil
        selectedAnswers = []
        sliderValue = 50
        textAnswer = ""
        showFeedback = false
        isCurrentAnswerCorrect = false
    }

    var hasAnswer: Bool {
        guard let currentItem = currentItem else { return false }
        switch currentItem.type {
        case .mcq, .binary:
            return selectedAnswer != nil
        case .multiSelect:
            return !selectedAnswers.isEmpty
        case .slider:
            return true // Slider always has a value
        case .freeText:
            return !textAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .clipLabel:
            return false // TODO: Implement
        }
    }
}
