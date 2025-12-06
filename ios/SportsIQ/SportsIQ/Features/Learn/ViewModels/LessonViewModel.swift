//
//  LessonViewModel.swift
//  Ola Ball
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

    // MARK: - Internal State
    /// The subset of items selected for this session (from the larger pool)
    private var lessonItems: [Item]
    /// IDs of items shown in this session (to track for variety in future sessions)
    private(set) var sessionItemIds: [UUID] = []

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

    // MARK: - Accuracy Tracking
    /// Number of questions answered correctly on the first attempt (no retries)
    var firstAttemptCorrectCount = 0

    // MARK: - Shuffling State
    var currentShuffledOptions: [String]?
    var currentOptionIndices: [Int]? // Maps shuffled index -> original index

    // MARK: - SRS State
    var reviewQueue: [Item] = [] // Items that were answered incorrectly
    var answeredCorrectly: Set<UUID> = [] // IDs of items answered correctly
    private var isInReviewMode = false // Track if we're presenting review items
    private var reviewIndex = 0 // Current index in review queue

    // MARK: - Submission State
    var isSubmitting = false // Prevents rapid double-clicks on Check Answer

    var totalUniqueItems: Int {
        lessonItems.count
    }

    var currentItem: Item? {
        // If completion screen is showing, return the last item to keep the view stable
        if showCompletionScreen {
            return lessonItems.last
        }

        if isInReviewMode {
            guard reviewIndex < reviewQueue.count else { return nil }
            return reviewQueue[reviewIndex]
        } else {
            guard currentItemIndex < lessonItems.count else { return nil }
            return lessonItems[currentItemIndex]
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
            return currentItemIndex == lessonItems.count - 1
        }
    }

    /// Initialize with previously seen items (for variety in question selection)
    /// - Parameters:
    ///   - lesson: The lesson to present
    ///   - userId: The current user's ID
    ///   - previouslySeenItemIds: IDs of items the user has seen in previous sessions
    ///   - learningRepository: Repository for submitting answers
    ///   - audioManager: Audio feedback manager
    ///   - hapticManager: Haptic feedback manager
    init(
        lesson: Lesson,
        userId: UUID,
        previouslySeenItemIds: Set<UUID> = [],
        learningRepository: LearningRepository,
        audioManager: AudioManager,
        hapticManager: HapticManager
    ) {
        self.lesson = lesson
        self.userId = userId
        self.learningRepository = learningRepository
        self.audioManager = audioManager
        self.hapticManager = hapticManager

        // Select items for this session with variety
        self.lessonItems = Self.selectItemsForSession(
            from: lesson.items,
            itemsPerSession: lesson.itemsPerSession,
            previouslySeenItemIds: previouslySeenItemIds
        )

        // Track which items we're showing this session
        self.sessionItemIds = lessonItems.map { $0.id }

        // Prepare first item
        prepareCurrentItem()
    }

    /// Legacy initializer for backwards compatibility
    convenience init(
        lesson: Lesson,
        userId: UUID,
        learningRepository: LearningRepository,
        audioManager: AudioManager,
        hapticManager: HapticManager
    ) {
        self.init(
            lesson: lesson,
            userId: userId,
            previouslySeenItemIds: [],
            learningRepository: learningRepository,
            audioManager: audioManager,
            hapticManager: hapticManager
        )
    }

    /// Selects items for a lesson session, prioritizing unseen items for variety
    /// - Parameters:
    ///   - items: All items in the lesson pool
    ///   - itemsPerSession: How many items to show per session
    ///   - previouslySeenItemIds: Items the user has seen before
    /// - Returns: A shuffled array of items to show this session
    private static func selectItemsForSession(
        from items: [Item],
        itemsPerSession: Int,
        previouslySeenItemIds: Set<UUID>
    ) -> [Item] {
        // If we have fewer items than needed, just shuffle and return all
        guard items.count > itemsPerSession else {
            return items.shuffled()
        }

        // Split items into unseen and seen
        let unseenItems = items.filter { !previouslySeenItemIds.contains($0.id) }
        let seenItems = items.filter { previouslySeenItemIds.contains($0.id) }

        var selectedItems: [Item] = []

        // First, add unseen items (up to itemsPerSession)
        let unseenToAdd = Array(unseenItems.shuffled().prefix(itemsPerSession))
        selectedItems.append(contentsOf: unseenToAdd)

        // If we need more items, fill with seen items
        let remaining = itemsPerSession - selectedItems.count
        if remaining > 0 {
            let seenToAdd = Array(seenItems.shuffled().prefix(remaining))
            selectedItems.append(contentsOf: seenToAdd)
        }

        // Shuffle the final selection so unseen items aren't always first
        return selectedItems.shuffled()
    }
    
    private func prepareCurrentItem() {
        guard let item = currentItem else {
            currentShuffledOptions = nil
            currentOptionIndices = nil
            return
        }
        
        if let options = item.options {
            // Create indices array [0, 1, 2, ...]
            let indices = Array(0..<options.count)
            
            // Shuffle indices
            let shuffledIndices = indices.shuffled()
            
            // Store mapping and shuffled options
            currentOptionIndices = shuffledIndices
            currentShuffledOptions = shuffledIndices.map { options[$0] }
        } else {
            currentShuffledOptions = nil
            currentOptionIndices = nil
        }
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
        guard !isSubmitting else { return }
        guard let currentItem = currentItem else { return }

        isSubmitting = true
        defer { isSubmitting = false }

        // Determine user's answer based on item type
        let userAnswer: UserAnswer
        switch currentItem.type {
        case .mcq, .binary:
            guard let selectedAnswer = selectedAnswer else { return }
            // Map shuffled index back to original index
            let originalIndex = currentOptionIndices?[selectedAnswer] ?? selectedAnswer
            userAnswer = .single(originalIndex)
        case .multiSelect:
            // Map shuffled indices back to original indices
            let originalIndices = selectedAnswers.compactMap { currentOptionIndices?[$0] }.sorted()
            userAnswer = .multiple(originalIndices)
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

            // Track first-attempt correct answers (only during initial pass, not review)
            if !isInReviewMode {
                firstAttemptCorrectCount += 1
            }

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

        // Show feedback immediately (before async network call)
        showFeedback = true

        // Submit to repository in background (don't block UI)
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

    /// XP earned = 10 points per question answered correctly on the first attempt
    var totalXPEarned: Int {
        return firstAttemptCorrectCount * 10
    }

    /// Accuracy percentage based on first-attempt correct answers vs total questions in session
    var accuracyPercentage: Int {
        guard totalUniqueItems > 0 else { return 0 }
        return Int(round(Double(firstAttemptCorrectCount) / Double(totalUniqueItems) * 100))
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
        
        // Prepare the new item (shuffle options)
        prepareCurrentItem()
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
