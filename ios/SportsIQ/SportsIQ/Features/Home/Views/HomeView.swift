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

                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            VStack(spacing: .spacingM) {
                                Text("⚠️ Error")
                                    .font(.heading3)
                                    .foregroundStyle(Color.incorrect)

                                Text(errorMessage)
                                    .font(.body)
                                    .foregroundStyle(Color.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.spacingL)
                            .background(Color.incorrect.opacity(0.1))
                            .cornerRadius(.radiusL)
                        }

                        // Continue Learning
                        if !viewModel.sports.isEmpty {
                            VStack(alignment: .leading, spacing: .spacingM) {
                                Text("Continue Learning")
                                    .font(.heading3)
                                    .foregroundStyle(Color.textPrimary)

                                ForEach(viewModel.sports) { sport in
                                    if sport.id == Sport.football.id {
                                        NavigationLink {
                                            LessonView(
                                                lesson: .footballBasicsLesson1,
                                                sport: sport,
                                                coordinator: coordinator
                                            )
                                        } label: {
                                            SportCardContent(sport: sport)
                                        }
                                    } else {
                                        NavigationLink {
                                            SportModulesView(
                                                sport: sport,
                                                coordinator: coordinator
                                            )
                                        } label: {
                                            SportCardContent(sport: sport)
                                        }
                                    }
                                }
                            }
                        } else if viewModel.errorMessage == nil {
                            // No sports loaded but no error - show debug info
                            VStack(spacing: .spacingM) {
                                Text("🔍 Debug Info")
                                    .font(.heading3)
                                    .foregroundStyle(Color.warning)

                                Text("Sports array is empty. This could mean:\n• Supabase query returned no results\n• Database has no active sports\n• Silent error occurred")
                                    .font(.caption)
                                    .foregroundStyle(Color.textSecondary)
                                    .multilineTextAlignment(.center)

                                Text("Check Xcode console for errors")
                                    .font(.caption)
                                    .foregroundStyle(Color.brandPrimary)
                            }
                            .padding(.spacingL)
                            .background(Color.warning.opacity(0.1))
                            .cornerRadius(.radiusL)
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

// MARK: - Sport Card Content (for NavigationLink)
struct SportCardContent: View {
    let sport: Sport

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingS) {
            HStack {
                Image(systemName: sport.iconName)
                    .font(.system(size: 32))
                    .foregroundStyle(sport.accentColor)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.textSecondary)
            }

            Text(sport.name)
                .font(.heading3)
                .foregroundStyle(Color.textPrimary)

            Text(sport.description)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(2)
        }
        .padding(.spacingM)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
    }
}

#Preview("Home View") {
    HomeView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository()
    ))
}
