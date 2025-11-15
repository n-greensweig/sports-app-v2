//
//  LessonView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

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
            learningRepository: coordinator.learningRepository
        ))
    }

    var body: some View {
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
                            if let options = currentItem.options {
                                VStack(spacing: .spacingM) {
                                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                                        AnswerOptionButton(
                                            text: option,
                                            isSelected: viewModel.selectedAnswer == index,
                                            isCorrect: viewModel.showFeedback ? (viewModel.selectedAnswer == index ? viewModel.isCurrentAnswerCorrect : nil) : nil,
                                            action: {
                                                viewModel.selectAnswer(index)
                                            }
                                        )
                                        .disabled(viewModel.showFeedback)
                                    }
                                }
                            }

                        case .multiSelect:
                            if let options = currentItem.options {
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
                        if viewModel.showFeedback, let explanation = currentItem.explanation {
                            FeedbackCard(
                                isCorrect: viewModel.isCurrentAnswerCorrect,
                                explanation: explanation
                            )
                        }

                        Spacer()
                    }
                    .padding(.spacingM)
                }

                // Bottom Action Button
                VStack {
                    Divider()

                    if viewModel.showFeedback {
                        PrimaryButton(
                            title: viewModel.isLastItem ? "Complete Lesson" : "Continue",
                            action: {
                                if viewModel.isLastItem {
                                    dismiss()
                                } else {
                                    viewModel.nextItem()
                                }
                            },
                            color: sport.accentColor
                        )
                        .padding(.spacingM)
                    } else {
                        PrimaryButton(
                            title: "Check Answer",
                            action: {
                                Task {
                                    await viewModel.submitAnswer()
                                }
                            },
                            color: sport.accentColor,
                            isEnabled: viewModel.hasAnswer
                        )
                        .padding(.spacingM)
                    }
                }
            }
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func getMultiSelectCorrectness(index: Int, correctAnswer: ItemAnswer) -> Bool? {
        guard case .multiple(let correctIndices) = correctAnswer else { return nil }
        let isCorrectOption = correctIndices.contains(index)
        let wasSelected = viewModel.selectedAnswers.contains(index)

        if wasSelected {
            return isCorrectOption // Green if correct, red if wrong
        } else if isCorrectOption {
            return true // Show which ones should have been selected
        }
        return nil
    }
}

// MARK: - Answer Option Button
struct AnswerOptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void

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

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(isCorrect ? Color.correct : Color.incorrect)
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
    }
}

// MARK: - Multi-Select Option Button
struct MultiSelectOptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void

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
    }
}

// MARK: - Feedback Card
struct FeedbackCard: View {
    let isCorrect: Bool
    let explanation: String

    var body: some View {
        HStack(alignment: .top, spacing: .spacingM) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "info.circle.fill")
                .font(.title2)
                .foregroundStyle(isCorrect ? Color.correct : Color.info)

            VStack(alignment: .leading, spacing: .spacingXS) {
                Text(isCorrect ? "Correct!" : "Not quite")
                    .font(.heading4)
                    .foregroundStyle(isCorrect ? Color.correct : Color.info)

                Text(explanation)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
            }
        }
        .padding(.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background((isCorrect ? Color.correct : Color.info).opacity(0.1))
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
                userRepository: MockUserRepository()
            )
        )
    }
}
