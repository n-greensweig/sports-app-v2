//
//  HomeView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct HomeView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: HomeViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = State(initialValue: HomeViewModel(
            learningRepository: coordinator.learningRepository,
            userRepository: coordinator.userRepository,
            userId: coordinator.currentUser?.id ?? UUID()
        ))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .spacingL) {
                    // Welcome Header
                    VStack(alignment: .leading, spacing: .spacingS) {
                        Text("Welcome back!")
                            .font(.heading2)
                            .foregroundStyle(Color.textSecondary)

                        if let user = coordinator.currentUser {
                            Text(user.displayName ?? user.username)
                                .font(.heading1)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }

                    // Stats Overview
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.spacingXL)
                    } else {
                        StatsOverviewCard(
                            totalXP: viewModel.userProgress?.totalXP ?? 0,
                            overallRating: viewModel.userProgress?.overallRating ?? 0,
                            currentStreak: viewModel.userProgress?.currentStreak ?? 0
                        )

                        // Continue Learning
                        if !viewModel.sports.isEmpty {
                            VStack(alignment: .leading, spacing: .spacingM) {
                                Text("Continue Learning")
                                    .font(.heading3)
                                    .foregroundStyle(Color.textPrimary)

                                ForEach(viewModel.sports) { sport in
                                    SportCard(sport: sport) {
                                        // Navigate to sport
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.spacingM)
            }
            .navigationTitle("Home")
            .task {
                await viewModel.loadData()
            }
        }
    }
}

// MARK: - Stats Overview Card
struct StatsOverviewCard: View {
    let totalXP: Int
    let overallRating: Int
    let currentStreak: Int

    var body: some View {
        HStack(spacing: .spacingM) {
            StatItem(title: "XP", value: "\(totalXP)", color: .brandPrimary)
            Divider()
            StatItem(title: "Rating", value: "\(overallRating)", color: .footballAccent)
            Divider()
            StatItem(title: "Streak", value: "\(currentStreak)🔥", color: .warning)
        }
        .padding(.spacingM)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: .spacingS) {
            Text(value)
                .font(.heading2)
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Home View") {
    HomeView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository()
    ))
}
