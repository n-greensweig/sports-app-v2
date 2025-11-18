//
//  LiveModeView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct LiveModeView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: LiveModeViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = State(initialValue: LiveModeViewModel())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .spacingL) {
                    // Header
                    VStack(alignment: .leading, spacing: .spacingS) {
                        Text("Live Games")
                            .font(.heading1)
                            .foregroundStyle(Color.textPrimary)

                        Text("Answer questions during live games to earn bonus XP")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                    }

                    // Live Games Section
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.spacingXL)
                    } else if viewModel.liveGames.isEmpty {
                        NoLiveGamesCard()
                    } else {
                        VStack(alignment: .leading, spacing: .spacingM) {
                            Text("Live Now")
                                .font(.heading3)
                                .foregroundStyle(Color.textPrimary)

                            ForEach(viewModel.liveGames) { game in
                                LiveGameCard(game: game) {
                                    // Navigate to live game detail
                                }
                            }
                        }
                    }

                    // Upcoming Games Section
                    if !viewModel.upcomingGames.isEmpty {
                        VStack(alignment: .leading, spacing: .spacingM) {
                            Text("Upcoming Games")
                                .font(.heading3)
                                .foregroundStyle(Color.textPrimary)

                            ForEach(viewModel.upcomingGames) { game in
                                UpcomingGameCard(game: game)
                            }
                        }
                    }
                }
                .padding(.spacingM)
            }
            .navigationTitle("Live Mode")
            .task {
                await viewModel.loadGames()
            }
        }
    }
}

// MARK: - Live Game Card
struct LiveGameCard: View {
    let game: Game
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: .spacingM) {
                // Live Indicator
                HStack {
                    HStack(spacing: .spacingS) {
                        Circle()
                            .fill(Color.incorrect)
                            .frame(width: 8, height: 8)
                        Text("LIVE")
                            .font(.small)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.incorrect)
                    }

                    Spacer()

                    if let quarter = game.currentQuarter, let time = game.timeRemaining {
                        Text("Q\(quarter) • \(time)")
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                // Teams and Scores
                VStack(spacing: .spacingM) {
                    // Away Team
                    HStack {
                        Text(game.awayTeam.shortName)
                            .font(.bodyLarge)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.textPrimary)

                        Spacer()

                        Text("\(game.awayScore)")
                            .font(.heading2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.textPrimary)
                    }

                    Divider()

                    // Home Team
                    HStack {
                        Text(game.homeTeam.shortName)
                            .font(.bodyLarge)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.textPrimary)

                        Spacer()

                        Text("\(game.homeScore)")
                            .font(.heading2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.textPrimary)
                    }
                }

                // Join Button
                HStack {
                    Image(systemName: "play.circle.fill")
                    Text("Watch & Learn")
                        .fontWeight(.semibold)
                }
                .font(.button)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.spacingM)
                .background(Color.footballAccent)
                .cornerRadius(.radiusM)
            }
            .padding(.spacingM)
            .background(Color.backgroundSecondary)
            .cornerRadius(.radiusL)
            .overlay(
                RoundedRectangle(cornerRadius: .radiusL)
                    .stroke(Color.footballAccent, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Upcoming Game Card
struct UpcomingGameCard: View {
    let game: Game

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: game.scheduledTime)
    }

    var body: some View {
        VStack(spacing: .spacingM) {
            // Time
            HStack {
                Image(systemName: "clock")
                    .foregroundStyle(Color.textSecondary)
                Text(formattedTime)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)

                Spacer()
            }

            // Teams
            VStack(spacing: .spacingS) {
                HStack {
                    Text(game.awayTeam.shortName)
                        .font(.body)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Text("@")
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }

                HStack {
                    Text(game.homeTeam.shortName)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                }
            }
        }
        .padding(.spacingM)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusM)
    }
}

// MARK: - No Live Games Card
struct NoLiveGamesCard: View {
    var body: some View {
        VStack(spacing: .spacingM) {
            Image(systemName: "sportscourt")
                .font(.system(size: 48))
                .foregroundStyle(Color.textSecondary)

            VStack(spacing: .spacingS) {
                Text("No Live Games")
                    .font(.heading3)
                    .foregroundStyle(Color.textPrimary)

                Text("Check back later for live games and real-time learning opportunities")
                    .font(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.spacingXL)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
    }
}

#Preview("Live Mode") {
    LiveModeView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository(),
        gameRepository: MockGameRepository()
    ))
}
