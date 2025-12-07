//
//  TestOutView.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import SwiftUI

/// Main view for the test-out assessment flow
/// Shows all 25 questions in sequence with no review queue
struct TestOutView: View {
    let testOut: TestOut
    let module: Module
    let sport: Sport
    let coordinator: AppCoordinator
    let onComplete: (Bool) -> Void // Called with pass/fail result

    @State private var viewModel: TestOutViewModel
    @Environment(\.dismiss) private var dismiss

    init(
        testOut: TestOut,
        module: Module,
        sport: Sport,
        coordinator: AppCoordinator,
        onComplete: @escaping (Bool) -> Void
    ) {
        self.testOut = testOut
        self.module = module
        self.sport = sport
        self.coordinator = coordinator
        self.onComplete = onComplete
        self._viewModel = State(initialValue: TestOutViewModel(
            testOut: testOut,
            module: module,
            userId: coordinator.currentUser?.id ?? UUID(),
            learningRepository: coordinator.learningRepository,
            audioManager: coordinator.audioManager,
            hapticManager: coordinator.hapticManager
        ))
    }

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.loadError {
                errorView(error)
            } else {
                questionView
            }
        }
        .navigationTitle("Test Out: \(module.title)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadItems()
        }
        .fullScreenCover(isPresented: $viewModel.showCompletionScreen) {
            TestOutResultView(
                score: viewModel.correctAnswersCount,
                totalQuestions: viewModel.totalQuestions,
                passingScore: viewModel.passingScore,
                passed: viewModel.attempt?.passed ?? false,
                moduleName: module.title,
                nextModuleName: "Veteran", // TODO: Get from next module
                onDismiss: {
                    let passed = viewModel.attempt?.passed ?? false
                    onComplete(passed)
                    dismiss()
                }
            )
        }
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack(spacing: .spacingL) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading test questions...")
                .font(.body)
                .foregroundStyle(Color.textSecondary)
        }
    }

    // MARK: - Error View

    private func errorView(_ error: Error) -> some View {
        VStack(spacing: .spacingL) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(Color.incorrect)

            Text("Unable to Load Test")
                .font(.heading2)
                .foregroundStyle(Color.textPrimary)

            Text(error.localizedDescription)
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            PrimaryButton(
                title: "Go Back",
                action: { dismiss() },
                color: sport.accentColor
            )
            .padding(.horizontal, .spacingXL)
        }
    }

    // MARK: - Question View

    private var questionView: some View {
        VStack(spacing: 0) {
            // Progress header
            testProgressHeader

            // Question content
            if let currentItem = viewModel.currentItem {
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingL) {
                        // Question prompt
                        Text(currentItem.prompt)
                            .font(.heading3)
                            .foregroundStyle(Color.textPrimary)
                            .padding(.top, .spacingL)

                        // Answer options based on type
                        answerOptions(for: currentItem)

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

                // Bottom action button
                bottomActionButton
            }
        }
    }

    // MARK: - Progress Header

    private var testProgressHeader: some View {
        VStack(spacing: .spacingS) {
            // Progress bar
            ProgressBar(
                progress: viewModel.progress,
                color: sport.accentColor,
                height: 6
            )
            .padding(.horizontal, .spacingM)

            // Question counter and score
            HStack {
                Text("Question \(viewModel.currentItemIndex + 1) of \(viewModel.totalQuestions)")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)

                Spacer()

                // Current score indicator
                HStack(spacing: .spacingXS) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.correct)
                    Text("\(viewModel.correctAnswersCount)/\(viewModel.passingScore) to pass")
                        .font(.caption)
                        .foregroundStyle(viewModel.canStillPass ? Color.textSecondary : Color.incorrect)
                }
            }
            .padding(.horizontal, .spacingM)
            .padding(.bottom, .spacingS)
        }
        .padding(.top, .spacingS)
    }

    // MARK: - Answer Options

    @ViewBuilder
    private func answerOptions(for item: Item) -> some View {
        switch item.type {
        case .mcq, .binary:
            if let options = viewModel.currentShuffledOptions {
                VStack(spacing: .spacingM) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        AnswerOptionButton(
                            text: option,
                            isSelected: viewModel.selectedAnswer == index,
                            feedbackState: viewModel.showFeedback ? getAnswerFeedbackState(index: index, item: item) : nil,
                            action: { viewModel.selectAnswer(index) }
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
                            isCorrect: viewModel.showFeedback ? getMultiSelectCorrectness(index: index, correctAnswer: item.correctAnswer) : nil,
                            action: { viewModel.toggleMultiSelectAnswer(index) }
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
            Text("Clip labeling coming soon...")
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .padding(.spacingL)
        }
    }

    // MARK: - Bottom Action Button

    private var bottomActionButton: some View {
        VStack {
            Divider()

            if viewModel.showFeedback {
                PrimaryButton(
                    title: viewModel.isLastItem ? "See Results" : "Next Question",
                    action: { viewModel.nextItem() },
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
                        Task { await viewModel.submitAnswer() }
                    },
                    color: sport.accentColor,
                    isEnabled: viewModel.hasAnswer && !viewModel.isSubmitting
                )
                .padding(.spacingM)
                .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.showFeedback)
    }

    // MARK: - Helpers

    private func getAnswerFeedbackState(index: Int, item: Item) -> AnswerFeedbackState {
        let isSelected = viewModel.selectedAnswer == index
        let originalIndex = viewModel.currentOptionIndices?[index] ?? index

        let isCorrectOption: Bool
        switch item.correctAnswer {
        case .single(let correctIndex):
            isCorrectOption = originalIndex == correctIndex
        case .boolean(let correctBool):
            isCorrectOption = (originalIndex == 0 && correctBool) || (originalIndex == 1 && !correctBool)
        default:
            isCorrectOption = false
        }

        if isSelected {
            return viewModel.isCurrentAnswerCorrect ? .correct : .incorrect
        } else if isCorrectOption && !viewModel.isCurrentAnswerCorrect {
            return .correctAnswer
        }

        return .neutral
    }

    private func getMultiSelectCorrectness(index: Int, correctAnswer: ItemAnswer) -> Bool? {
        guard case .multiple(let correctIndices) = correctAnswer else { return nil }

        let originalIndex = viewModel.currentOptionIndices?[index] ?? index
        let isCorrectOption = correctIndices.contains(originalIndex)
        let wasSelected = viewModel.selectedAnswers.contains(index)

        if wasSelected {
            return isCorrectOption
        } else if isCorrectOption {
            return true
        }
        return nil
    }
}
