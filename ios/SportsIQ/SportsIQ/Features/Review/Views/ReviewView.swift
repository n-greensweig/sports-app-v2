//
//  ReviewView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct ReviewView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: ReviewViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = State(initialValue: ReviewViewModel(
            sportId: Sport.football.id,
            userId: coordinator.currentUser?.id ?? UUID()
        ))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.dueCards.isEmpty {
                    NoReviewsView()
                } else if let currentCard = viewModel.currentCard {
                    // Progress Bar
                    VStack(spacing: .spacingS) {
                        HStack {
                            Text("\(viewModel.cardsRemaining) cards left")
                                .font(.caption)
                                .foregroundStyle(Color.textSecondary)

                            Spacer()

                            if let session = viewModel.reviewSession {
                                Text("\(session.correctAnswers)/\(session.cardsReviewed)")
                                    .font(.caption)
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }

                        ProgressBar(
                            progress: viewModel.progress,
                            color: Color.footballAccent,
                            height: 6
                        )
                    }
                    .padding(.horizontal, .spacingM)
                    .padding(.top, .spacingS)

                    // Card content would go here
                    // For now, placeholder
                    VStack {
                        Text("Review Card #\(viewModel.currentCardIndex + 1)")
                            .font(.heading2)
                            .padding(.spacingXL)

                        Spacer()

                        // Mock buttons for demo
                        HStack(spacing: .spacingM) {
                            Button("Incorrect") {
                                viewModel.submitReview(isCorrect: false)
                            }
                            .buttonStyle(.bordered)

                            Button("Correct") {
                                viewModel.submitReview(isCorrect: true)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.spacingM)
                    }
                } else {
                    ReviewCompleteView(session: viewModel.reviewSession!)
                }
            }
            .navigationTitle("Review")
            .task {
                await viewModel.loadDueCards()
            }
        }
    }
}

// MARK: - No Reviews View
struct NoReviewsView: View {
    var body: some View {
        VStack(spacing: .spacingL) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.correct)

            VStack(spacing: .spacingS) {
                Text("All Caught Up!")
                    .font(.heading2)
                    .foregroundStyle(Color.textPrimary)

                Text("No cards due for review right now.\nCome back later to reinforce your learning.")
                    .font(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.spacingXL)
    }
}

// MARK: - Review Complete View
struct ReviewCompleteView: View {
    let session: ReviewSession

    var body: some View {
        VStack(spacing: .spacingXL) {
            Image(systemName: "star.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.warning)

            VStack(spacing: .spacingM) {
                Text("Review Complete!")
                    .font(.heading1)
                    .foregroundStyle(Color.textPrimary)

                VStack(spacing: .spacingS) {
                    Text("\(session.cardsReviewed) cards reviewed")
                        .font(.body)
                        .foregroundStyle(Color.textSecondary)

                    Text("\(Int(session.accuracy * 100))% accuracy")
                        .font(.heading3)
                        .foregroundStyle(Color.correct)

                    Text("+\(session.xpEarned) XP")
                        .font(.heading2)
                        .foregroundStyle(Color.warning)
                        .fontWeight(.bold)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.spacingXL)
    }
}

#Preview("Review View") {
    ReviewView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository()
    ))
}
