//
//  TestOutViewModel.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import Foundation

/// ViewModel for the test-out assessment flow
/// Unlike regular lessons, test-out:
/// - Shows all 25 questions in a single pass
/// - No review queue (incorrect answers are NOT retried)
/// - Submits final score at the end
/// - 20/25 required to pass
@Observable
class TestOutViewModel {
    // MARK: - Dependencies
    private let testOut: TestOut
    private let module: Module
    private let userId: UUID
    private let learningRepository: LearningRepository
    private let audioManager: AudioManager
    private let hapticManager: HapticManager

    // MARK: - Items
    private var items: [Item] = []

    // MARK: - State
    var currentItemIndex = 0
    var selectedAnswer: Int?
    var selectedAnswers: Set<Int> = []
    var sliderValue: Double = 50
    var textAnswer: String = ""
    var showFeedback = false
    var isCurrentAnswerCorrect = false
    var correctAnswersCount = 0

    // MARK: - Shuffling State
    var currentShuffledOptions: [String]?
    var currentOptionIndices: [Int]?

    // MARK: - Loading State
    var isLoading = true
    var loadError: Error?
    var isSubmitting = false

    // MARK: - Completion State
    var showCompletionScreen = false
    var attempt: TestOutAttempt?

    var totalQuestions: Int {
        testOut.totalQuestions
    }

    var passingScore: Int {
        testOut.passingScore
    }

    var currentItem: Item? {
        guard currentItemIndex < items.count else { return nil }
        return items[currentItemIndex]
    }

    var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentItemIndex + 1) / Double(totalQuestions)
    }

    var isLastItem: Bool {
        currentItemIndex == items.count - 1
    }

    var isPassing: Bool {
        correctAnswersCount >= passingScore
    }

    var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int(round(Double(correctAnswersCount) / Double(totalQuestions) * 100))
    }

    var questionsRemaining: Int {
        items.count - currentItemIndex - 1
    }

    var canStillPass: Bool {
        // Calculate maximum possible score
        let maxPossibleScore = correctAnswersCount + questionsRemaining + 1
        return maxPossibleScore >= passingScore
    }

    // MARK: - Initialization

    init(
        testOut: TestOut,
        module: Module,
        userId: UUID,
        learningRepository: LearningRepository,
        audioManager: AudioManager,
        hapticManager: HapticManager
    ) {
        self.testOut = testOut
        self.module = module
        self.userId = userId
        self.learningRepository = learningRepository
        self.audioManager = audioManager
        self.hapticManager = hapticManager
    }

    // MARK: - Loading

    @MainActor
    func loadItems() async {
        isLoading = true
        loadError = nil

        do {
            let fetchedItems = try await learningRepository.getTestOutItems(moduleId: module.id)

            // Shuffle and take up to totalQuestions
            items = Array(fetchedItems.shuffled().prefix(testOut.totalQuestions))

            if items.isEmpty {
                loadError = TestOutError.noItems
            } else {
                prepareCurrentItem()
            }
        } catch {
            loadError = error
        }

        isLoading = false
    }

    // MARK: - Answer Selection

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

    // MARK: - Submit Answer

    @MainActor
    func submitAnswer() async {
        guard !isSubmitting else { return }
        guard let currentItem = currentItem else { return }

        isSubmitting = true
        defer { isSubmitting = false }

        // Determine user's answer based on item type
        let userAnswer: UserAnswer
        switch currentItem.type {
        case .mcq, .binary:
            guard let selectedAnswer = selectedAnswer else { return }
            let originalIndex = currentOptionIndices?[selectedAnswer] ?? selectedAnswer
            userAnswer = .single(originalIndex)
        case .multiSelect:
            let originalIndices = selectedAnswers.compactMap { currentOptionIndices?[$0] }.sorted()
            userAnswer = .multiple(originalIndices)
        case .slider:
            userAnswer = .slider(sliderValue)
        case .freeText:
            userAnswer = .text(textAnswer.trimmingCharacters(in: .whitespacesAndNewlines))
        case .clipLabel:
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

        showFeedback = true

        // Check if this was the last question
        if isLastItem {
            await completeTestOut()
        }
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

    // MARK: - Navigation

    func nextItem() {
        // Reset answer state
        selectedAnswer = nil
        selectedAnswers = []
        sliderValue = 50
        textAnswer = ""
        showFeedback = false
        isCurrentAnswerCorrect = false

        // Move to next item
        if !isLastItem {
            currentItemIndex += 1
            prepareCurrentItem()
        }
    }

    private func prepareCurrentItem() {
        guard let item = currentItem else {
            currentShuffledOptions = nil
            currentOptionIndices = nil
            return
        }

        if let options = item.options {
            let indices = Array(0..<options.count)
            let shuffledIndices = indices.shuffled()
            currentOptionIndices = shuffledIndices
            currentShuffledOptions = shuffledIndices.map { options[$0] }
        } else {
            currentShuffledOptions = nil
            currentOptionIndices = nil
        }
    }

    // MARK: - Completion

    @MainActor
    private func completeTestOut() async {
        do {
            attempt = try await learningRepository.submitTestOutAttempt(
                userId: userId,
                moduleId: module.id,
                score: correctAnswersCount,
                totalQuestions: items.count
            )

            if attempt?.passed == true {
                audioManager.playLessonCompleteSound()
                hapticManager.playLevelUpPattern()
            }

            showCompletionScreen = true
            print("✅ Test-out completed: \(correctAnswersCount)/\(items.count), passed: \(attempt?.passed ?? false)")
        } catch {
            print("❌ Error submitting test-out: \(error)")
            // Still show completion screen even if submission failed
            showCompletionScreen = true
        }
    }

    // MARK: - Helpers

    var hasAnswer: Bool {
        guard let currentItem = currentItem else { return false }
        switch currentItem.type {
        case .mcq, .binary:
            return selectedAnswer != nil
        case .multiSelect:
            return !selectedAnswers.isEmpty
        case .slider:
            return true
        case .freeText:
            return !textAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .clipLabel:
            return false
        }
    }
}

// MARK: - Errors

enum TestOutError: LocalizedError {
    case noItems

    var errorDescription: String? {
        switch self {
        case .noItems:
            return "No questions available for this test-out."
        }
    }
}
