//
//  LessonView.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import SwiftUI

// MARK: - Shake Effect for Incorrect Answers
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 6
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX: amount * sin(animatableData * .pi * shakesPerUnit),
            y: 0
        ))
    }
}

struct LessonView: View {
    let lesson: Lesson
    let sport: Sport
    let coordinator: AppCoordinator
    @State private var viewModel: LessonViewModel
    @Environment(\.dismiss) private var dismiss

    init(lesson: Lesson, sport: Sport, coordinator: AppCoordinator) {
        self.lesson = lesson
        self.sport = sport
        self.coordinator = coordinator
        self._viewModel = State(initialValue: LessonViewModel(
            lesson: lesson,
            userId: coordinator.currentUser?.id ?? UUID(),
            sportId: sport.id,
            learningRepository: coordinator.learningRepository,
            userRepository: coordinator.userRepository,
            audioManager: coordinator.audioManager,
            hapticManager: coordinator.hapticManager
        ))
    }

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress Bar
                ProgressBar(
                    progress: viewModel.progress,
                    color: sport.accentColor,
                    height: 6
                )
                .padding(.horizontal, .spacingM)
                .padding(.top, .spacingS)

                // Content
                if let currentItem = viewModel.currentItem {
                    ScrollView {
                        VStack(alignment: .leading, spacing: .spacingL) {
                            // Question
                            Text(currentItem.prompt)
                                .font(.heading3)
                                .foregroundStyle(Color.textPrimary)
                                .padding(.top, .spacingL)

                            // Answer Input (based on item type)
                            switch currentItem.type {
                            case .mcq, .binary:
                                if let options = viewModel.currentShuffledOptions {
                                    VStack(spacing: .spacingM) {
                                        ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                                            AnswerOptionButton(
                                                text: option,
                                                isSelected: viewModel.selectedAnswer == index,
                                                feedbackState: viewModel.showFeedback ? getAnswerFeedbackState(index: index, item: currentItem) : nil,
                                                action: {
                                                    viewModel.selectAnswer(index)
                                                }
                                            )
                                            .disabled(viewModel.showFeedback)
                                        }
                                    }
                                }

                            case .multiSelect:
                                if let options = viewModel.currentShuffledOptions {
                                    VStack(spacing: .spacingM) {
                                        ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                                            MultiSelectOptionButton(
                                                text: option,
                                                isSelected: viewModel.selectedAnswers.contains(index),
                                                isCorrect: viewModel.showFeedback ? getMultiSelectCorrectness(index: index, correctAnswer: currentItem.correctAnswer) : nil,
                                                action: {
                                                    viewModel.toggleMultiSelectAnswer(index)
                                                }
                                            )
                                            .disabled(viewModel.showFeedback)
                                        }
                                    }
                                }

                            case .slider:
                                VStack(alignment: .leading, spacing: .spacingM) {
                                    HStack {
                                        Text("Your answer:")
                                            .font(.label)
                                            .foregroundStyle(Color.textSecondary)
                                        Spacer()
                                        Text("\(Int(viewModel.sliderValue))")
                                            .font(.heading3)
                                            .foregroundStyle(sport.accentColor)
                                    }

                                    Slider(value: $viewModel.sliderValue, in: 0...200, step: 1)
                                        .tint(sport.accentColor)
                                        .disabled(viewModel.showFeedback)
                                }
                                .padding(.vertical, .spacingS)

                            case .freeText:
                                VStack(alignment: .leading, spacing: .spacingS) {
                                    Text("Type your answer:")
                                        .font(.label)
                                        .foregroundStyle(Color.textSecondary)

                                    TextField("Your answer", text: $viewModel.textAnswer)
                                        .textFieldStyle(.roundedBorder)
                                        .font(.body)
                                        .disabled(viewModel.showFeedback)
                                        .autocorrectionDisabled()
                                }

                            case .clipLabel:
                                // TODO: Implement clip labeling
                                Text("Clip labeling coming soon...")
                                    .font(.body)
                                    .foregroundStyle(Color.textSecondary)
                                    .padding(.spacingL)
                            }

                            // Feedback
                            if viewModel.showFeedback {
                                FeedbackCard(isCorrect: viewModel.isCurrentAnswerCorrect)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                            }

                            Spacer()
                        }
                        .padding(.spacingM)
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.showFeedback)
                    }

                    // Bottom Action Button
                    VStack {
                        Divider()

                        if viewModel.showFeedback {
                            PrimaryButton(
                                title: "Continue",
                                action: {
                                    viewModel.nextItem()
                                },
                                color: sport.accentColor
                            )
                            .padding(.spacingM)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.9).combined(with: .opacity),
                                removal: .opacity
                            ))
                        } else {
                            PrimaryButton(
                                title: "Check Answer",
                                action: {
                                    Task {
                                        await viewModel.submitAnswer()
                                    }
                                },
                                color: sport.accentColor,
                                isEnabled: viewModel.hasAnswer && !viewModel.isSubmitting
                            )
                            .padding(.spacingM)
                            .transition(.opacity)
                        }
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.showFeedback)
                } else {
                    // Show error state when no items are available
                    VStack(spacing: .spacingL) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.textTertiary)

                        Text("Unable to load lesson content")
                            .font(.heading4)
                            .foregroundStyle(Color.textPrimary)

                        Text("Please try again later")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)

                        Button("Go Back") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $viewModel.showCompletionScreen) {
            LessonCompleteView(
                lesson: lesson,
                accuracyPercentage: viewModel.accuracyPercentage,
                xpEarned: viewModel.totalXPEarned,
                currentStreak: viewModel.updatedStreak?.currentStreak ?? 0,
                streakMilestone: viewModel.streakMilestoneReached,
                onDismiss: {
                    Task {
                        await viewModel.completeLesson()
                        viewModel.isDismissing = true
                        viewModel.showCompletionScreen = false
                        dismiss()
                    }
                }
            )
        }
    }

    private func getMultiSelectCorrectness(index: Int, correctAnswer: ItemAnswer) -> Bool? {
        guard case .multiple(let correctIndices) = correctAnswer else { return nil }

        // Map shuffled index to original index to check correctness
        let originalIndex = viewModel.currentOptionIndices?[index] ?? index
        let isCorrectOption = correctIndices.contains(originalIndex)
        let wasSelected = viewModel.selectedAnswers.contains(index)

        if wasSelected {
            return isCorrectOption // Green if correct, red if wrong
        } else if isCorrectOption {
            return true // Show which ones should have been selected
        }
        return nil
    }

    /// Determines the feedback state for a single-choice answer option
    private func getAnswerFeedbackState(index: Int, item: Item) -> AnswerFeedbackState {
        let isSelected = viewModel.selectedAnswer == index
        let originalIndex = viewModel.currentOptionIndices?[index] ?? index

        // Check if this option is the correct answer
        let isCorrectOption: Bool
        switch item.correctAnswer {
        case .single(let correctIndex):
            isCorrectOption = originalIndex == correctIndex
        case .boolean(let correctBool):
            // For binary questions: index 0 = true, index 1 = false
            isCorrectOption = (originalIndex == 0 && correctBool) || (originalIndex == 1 && !correctBool)
        default:
            isCorrectOption = false
        }

        if isSelected {
            // This is the user's selected answer
            return viewModel.isCurrentAnswerCorrect ? .correct : .incorrect
        } else if isCorrectOption && !viewModel.isCurrentAnswerCorrect {
            // This is the correct answer, and user got it wrong - show it in green
            return .correctAnswer
        }

        return .neutral
    }
}

// MARK: - Answer Feedback State
enum AnswerFeedbackState {
    case correct      // User selected this and it's correct (green)
    case incorrect    // User selected this and it's wrong (red)
    case correctAnswer // User didn't select this, but it's the correct answer (green, shown when user is wrong)
    case neutral      // Not selected, not the correct answer
}

// MARK: - Answer Option Button
struct AnswerOptionButton: View {
    let text: String
    let isSelected: Bool
    let feedbackState: AnswerFeedbackState?
    let action: () -> Void

    // Animation states
    @State private var bounceValue: CGFloat = 0
    @State private var shakeValue: CGFloat = 0
    @State private var showSparkle = false
    @State private var pulseOpacity: Double = 1.0

    private var backgroundColor: Color {
        guard let state = feedbackState else {
            return isSelected ? .brandPrimary.opacity(0.1) : .backgroundSecondary
        }
        switch state {
        case .correct, .correctAnswer:
            return .correct.opacity(0.2)
        case .incorrect:
            return .incorrect.opacity(0.2)
        case .neutral:
            return .backgroundSecondary
        }
    }

    private var borderColor: Color {
        guard let state = feedbackState else {
            return isSelected ? .brandPrimary : .clear
        }
        switch state {
        case .correct, .correctAnswer:
            return .correct
        case .incorrect:
            return .incorrect
        case .neutral:
            return .clear
        }
    }

    private var trailingIcon: (name: String, color: Color)? {
        guard let state = feedbackState else { return nil }
        switch state {
        case .correct:
            return ("checkmark.circle.fill", .correct)
        case .incorrect:
            return ("xmark.circle.fill", .incorrect)
        case .correctAnswer:
            return ("checkmark.circle.fill", .correct)
        case .neutral:
            return nil
        }
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if let icon = trailingIcon {
                    Image(systemName: icon.name)
                        .foregroundStyle(icon.color)
                        .scaleEffect(feedbackState == .correct ? 1.0 + bounceValue * 0.3 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.4), value: bounceValue)
                        .overlay {
                            // Sparkle effect for correct answers
                            if showSparkle {
                                SparkleView(color: .correct)
                                    .allowsHitTesting(false)
                            }
                        }
                }
            }
            .padding(.spacingM)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(.radiusM)
            .overlay(
                RoundedRectangle(cornerRadius: .radiusM)
                    .stroke(borderColor, lineWidth: feedbackState == .correctAnswer ? 3 : 2)
                    .opacity(feedbackState == .correctAnswer ? pulseOpacity : 1.0)
            )
        }
        .buttonStyle(.plain)
        .modifier(ShakeEffect(animatableData: shakeValue))
        .onChange(of: feedbackState) { _, newValue in
            guard let state = newValue else { return }
            switch state {
            case .correct:
                // Immediate bounce + sparkle
                bounceValue = 1.0
                showSparkle = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    bounceValue = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSparkle = false
                }
            case .incorrect:
                // Immediate shake
                shakeValue = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    shakeValue = 0
                }
            case .correctAnswer:
                // Pulse the correct answer
                withAnimation(.easeInOut(duration: 0.3).repeatCount(2, autoreverses: true)) {
                    pulseOpacity = 0.4
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    pulseOpacity = 1.0
                }
            case .neutral:
                break
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.4), value: bounceValue)
        .animation(.linear(duration: 0.4), value: shakeValue)
    }
}

// MARK: - Multi-Select Option Button
struct MultiSelectOptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void

    // Animation states
    @State private var bounceValue: CGFloat = 0
    @State private var shakeValue: CGFloat = 0
    @State private var showSparkle = false

    private var backgroundColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? .correct.opacity(0.2) : .incorrect.opacity(0.2)
        }
        return isSelected ? .brandPrimary.opacity(0.1) : .backgroundSecondary
    }

    private var borderColor: Color {
        if let isCorrect = isCorrect {
            return isCorrect ? .correct : .incorrect
        }
        return isSelected ? .brandPrimary : .clear
    }

    // Determine if this option was a correct selection by the user
    private var isCorrectSelection: Bool {
        isSelected && isCorrect == true
    }

    // Determine if this option was an incorrect selection by the user
    private var isIncorrectSelection: Bool {
        isSelected && isCorrect == false
    }

    var body: some View {
        Button(action: action) {
            HStack {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isSelected ? (isCorrect != nil ? (isCorrect! ? Color.correct : Color.incorrect) : Color.brandPrimary) : Color.textTertiary, lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(isCorrect != nil ? (isCorrect! ? Color.correct : Color.incorrect) : Color.brandPrimary)
                    }
                }

                Text(text)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(isCorrect ? Color.correct : Color.incorrect)
                        .scaleEffect(isCorrectSelection ? 1.0 + bounceValue * 0.3 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.4), value: bounceValue)
                        .overlay {
                            // Sparkle effect for correct selections
                            if showSparkle && isCorrectSelection {
                                SparkleView(color: .correct)
                                    .allowsHitTesting(false)
                            }
                        }
                }
            }
            .padding(.spacingM)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(.radiusM)
            .overlay(
                RoundedRectangle(cornerRadius: .radiusM)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .modifier(ShakeEffect(animatableData: shakeValue))
        .onChange(of: isCorrect) { _, newValue in
            guard newValue != nil else { return }
            if isCorrectSelection {
                // Immediate bounce + sparkle
                bounceValue = 1.0
                showSparkle = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    bounceValue = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showSparkle = false
                }
            } else if isIncorrectSelection {
                // Immediate shake
                shakeValue = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    shakeValue = 0
                }
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.4), value: bounceValue)
        .animation(.linear(duration: 0.4), value: shakeValue)
    }
}

// MARK: - Feedback Card
struct FeedbackCard: View {
    let isCorrect: Bool

    // Pool of encouraging phrases for correct answers
    private static let correctPhrases = [
        "Great!", "Fantastic!", "Wow!", "Nice work!", "You got it!",
        "Correct!", "Awesome!", "Perfect!", "Well done!", "Nailed it!",
        "Excellent!", "Amazing!", "Brilliant!", "Keep it up!", "You're on fire!",
        "Crushing it!", "Superb!", "Outstanding!", "Way to go!", "That's right!"
    ]

    // Pool of phrases for incorrect answers
    private static let incorrectPhrases = [
        "Not quite", "Almost!"
    ]

    private var feedbackText: String {
        if isCorrect {
            return Self.correctPhrases.randomElement() ?? "Correct!"
        } else {
            return Self.incorrectPhrases.randomElement() ?? "Not quite"
        }
    }

    var body: some View {
        HStack(spacing: .spacingM) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(isCorrect ? Color.correct : Color.incorrect)

            Text(feedbackText)
                .font(.heading4)
                .foregroundStyle(isCorrect ? Color.correct : Color.incorrect)

            Spacer()
        }
        .padding(.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background((isCorrect ? Color.correct : Color.incorrect).opacity(0.1))
        .cornerRadius(.radiusM)
    }
}

#Preview("Lesson View") {
    NavigationStack {
        LessonView(
            lesson: .footballBasicsLesson1,
            sport: .football,
            coordinator: AppCoordinator(
                learningRepository: MockLearningRepository(),
                userRepository: MockUserRepository(),
                gameRepository: MockGameRepository()
            )
        )
    }
}
