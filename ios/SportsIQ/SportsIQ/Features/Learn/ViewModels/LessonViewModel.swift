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
    
    // MARK: - SRS State
    var reviewQueue: [Item] = [] // Items that were answered incorrectly
    var answeredCorrectly: Set<UUID> = [] // IDs of items answered correctly
    private var isInReviewMode = false // Track if we're presenting review items
    private var reviewIndex = 0 // Current index in review queue
    
    var totalUniqueItems: Int {
        lesson.items.count
    }

    var currentItem: Item? {
        // If completion screen is showing, return the last item to keep the view stable
        if showCompletionScreen {
            return lesson.items.last
        }
        
        if isInReviewMode {
            guard reviewIndex < reviewQueue.count else { return nil }
            return reviewQueue[reviewIndex]
        } else {
            guard currentItemIndex < lesson.items.count else { return nil }
            return lesson.items[currentItemIndex]
        }
    }

    var progress: Double {
        guard totalUniqueItems > 0 else { return 0 }
        return Double(answeredCorrectly.count) / Double(totalUniqueItems)
    }

    var isLastItem: Bool {
        if isInReviewMode {
            return reviewIndex == reviewQueue.count - 1
        } else {
            return currentItemIndex == lesson.items.count - 1
        }
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
            
            // Track this item as answered correctly
            answeredCorrectly.insert(currentItem.id)
            
            // If this was in review queue, remove it
            if isInReviewMode {
                reviewQueue.remove(at: reviewIndex)
                
                // Check if we just completed the lesson
                if reviewQueue.isEmpty {
                    audioManager.playLessonCompleteSound()
                    hapticManager.playLevelUpPattern()
                    showCompletionScreen = true
                }
            }
        } else {
            audioManager.playIncorrectSound()
            hapticManager.playIncorrectFeedback()
            
            // Add to review queue if not already there and not in review mode
            if !isInReviewMode && !reviewQueue.contains(where: { $0.id == currentItem.id }) {
                reviewQueue.append(currentItem)
            } else if isInReviewMode {
                // If wrong again during review, keep it in the queue (don't remove)
                // We'll just move to the next review item
            }
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
    
    @MainActor
    func completeLesson() async {
        do {
            try await learningRepository.completeLesson(
                userId: userId,
                lessonId: lesson.id,
                score: totalXPEarned
            )
            print("✅ Lesson completed successfully")
        } catch {
            print("❌ Error completing lesson: \(error)")
        }
    }

    func nextItem() {
        // Store the current answer correctness before resetting
        let wasCorrect = isCurrentAnswerCorrect
        
        // Reset answer state
        selectedAnswer = nil
        selectedAnswers = []
        sliderValue = 50
        textAnswer = ""
        showFeedback = false
        isCurrentAnswerCorrect = false
        
        if isInReviewMode {
            // In review mode
            if wasCorrect {
                // Item was removed from queue, don't increment index
                // Just check if we're done
            } else {
                // Item is still in queue, move to next
                reviewIndex += 1
            }
            
            // Check if review is complete
            if reviewQueue.isEmpty {
                // All items answered correctly!
                // Only trigger completion if not already showing completion screen
                if !showCompletionScreen {
                    audioManager.playLessonCompleteSound()
                    hapticManager.playLevelUpPattern()
                    showCompletionScreen = true
                }
                return
            } else if reviewIndex >= reviewQueue.count {
                // Reached end of review queue, but still have items
                // Loop back to start of review queue
                reviewIndex = 0
            }
        } else {
            // In normal mode
            if isLastItem {
                // Finished all original items
                if reviewQueue.isEmpty {
                    // No wrong answers, lesson complete!
                    audioManager.playLessonCompleteSound()
                    hapticManager.playLevelUpPattern()
                    showCompletionScreen = true
                    return
                } else {
                    // Switch to review mode
                    isInReviewMode = true
                    reviewIndex = 0
                }
            } else {
                // Move to next item
                currentItemIndex += 1
            }
        }
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
