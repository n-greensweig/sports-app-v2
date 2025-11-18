//
//  LeaderboardView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct LeaderboardView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: LeaderboardViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = State(initialValue: LeaderboardViewModel(
            userId: coordinator.currentUser?.id ?? UUID()
        ))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Time Period Selector
                Picker("Period", selection: $viewModel.selectedPeriod) {
                    Text("Daily").tag(LeaderboardPeriod.daily)
                    Text("Weekly").tag(LeaderboardPeriod.weekly)
                    Text("All Time").tag(LeaderboardPeriod.allTime)
                }
                .pickerStyle(.segmented)
                .padding(.spacingM)

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: .spacingM) {
                            // Top 3 Podium
                            if viewModel.entries.count >= 3 {
                                PodiumView(entries: Array(viewModel.entries.prefix(3)))
                                    .padding(.spacingL)
                            }

                            // Remaining entries
                            VStack(spacing: .spacingS) {
                                ForEach(Array(viewModel.entries.enumerated()), id: \.element.id) { index, entry in
                                    LeaderboardEntryRow(
                                        entry: entry,
                                        rank: index + 1,
                                        isCurrentUser: entry.userId == coordinator.currentUser?.id
                                    )
                                }
                            }
                            .padding(.horizontal, .spacingM)
                        }
                        .padding(.bottom, .spacingXL)
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .task {
                await viewModel.loadLeaderboard()
            }
            .onChange(of: viewModel.selectedPeriod) {
                Task {
                    await viewModel.loadLeaderboard()
                }
            }
        }
    }
}

// MARK: - Leaderboard Period
enum LeaderboardPeriod {
    case daily
    case weekly
    case allTime
}

// MARK: - Leaderboard Entry
struct LeaderboardEntry: Identifiable {
    let id: UUID
    let userId: UUID
    let username: String
    let xp: Int
    let overallRating: Int
}

// MARK: - Podium View
struct PodiumView: View {
    let entries: [LeaderboardEntry]

    var body: some View {
        HStack(alignment: .bottom, spacing: .spacingM) {
            // 2nd Place
            if entries.count > 1 {
                PodiumCard(entry: entries[1], place: 2, height: 100)
            }

            // 1st Place
            if entries.count > 0 {
                PodiumCard(entry: entries[0], place: 1, height: 130)
            }

            // 3rd Place
            if entries.count > 2 {
                PodiumCard(entry: entries[2], place: 3, height: 80)
            }
        }
    }
}

// MARK: - Podium Card
struct PodiumCard: View {
    let entry: LeaderboardEntry
    let place: Int
    let height: CGFloat

    private var medalColor: Color {
        switch place {
        case 1: return Color(hex: "#FFD700") // Gold
        case 2: return Color(hex: "#C0C0C0") // Silver
        case 3: return Color(hex: "#CD7F32") // Bronze
        default: return Color.textSecondary
        }
    }

    var body: some View {
        VStack(spacing: .spacingS) {
            // Medal
            Image(systemName: "medal.fill")
                .font(.system(size: place == 1 ? 32 : 24))
                .foregroundStyle(medalColor)

            // Username
            Text(entry.username)
                .font(place == 1 ? .bodyLarge : .body)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)

            // XP
            Text("\(entry.xp) XP")
                .font(.caption)
                .foregroundStyle(Color.textSecondary)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .padding(.spacingM)
        .background(medalColor.opacity(0.1))
        .cornerRadius(.radiusL)
        .overlay(
            RoundedRectangle(cornerRadius: .radiusL)
                .stroke(medalColor, lineWidth: 2)
        )
    }
}

// MARK: - Leaderboard Entry Row
struct LeaderboardEntryRow: View {
    let entry: LeaderboardEntry
    let rank: Int
    let isCurrentUser: Bool

    var body: some View {
        HStack(spacing: .spacingM) {
            // Rank
            Text("#\(rank)")
                .font(.bodyLarge)
                .fontWeight(.bold)
                .foregroundStyle(Color.textSecondary)
                .frame(width: 40, alignment: .leading)

            // User info
            VStack(alignment: .leading, spacing: .spacingXS) {
                Text(entry.username)
                    .font(.body)
                    .fontWeight(isCurrentUser ? .semibold : .regular)
                    .foregroundStyle(Color.textPrimary)

                Text("Rating: \(entry.overallRating)")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            // XP
            Text("\(entry.xp)")
                .font(.bodyLarge)
                .fontWeight(.semibold)
                .foregroundStyle(Color.footballAccent)
        }
        .padding(.spacingM)
        .background(isCurrentUser ? Color.footballAccent.opacity(0.1) : Color.backgroundSecondary)
        .cornerRadius(.radiusM)
        .overlay(
            RoundedRectangle(cornerRadius: .radiusM)
                .stroke(isCurrentUser ? Color.footballAccent : Color.clear, lineWidth: 2)
        )
    }
}

#Preview("Leaderboard") {
    LeaderboardView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository(),
        gameRepository: MockGameRepository()
    ))
}
