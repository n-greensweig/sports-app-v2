//
//  HomeView.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import SwiftUI

struct HomeView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: HomeViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var showSportSelector = true

    // Threshold for hiding/showing sport selector
    private let scrollThreshold: CGFloat = 50

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
            VStack(spacing: 0) {
                // Collapsible Sport Selector Header
                if !viewModel.sports.isEmpty {
                    sportSelectorHeader
                        .frame(height: showSportSelector ? nil : 0)
                        .opacity(showSportSelector ? 1 : 0)
                        .clipped()
                }

                // Main Content
                ScrollView {
                    scrollOffsetReader

                    VStack(alignment: .leading, spacing: .spacingL) {
                        // Stats Overview
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.spacingXL)
                        } else {
                            // Current Sport Header
                            if let sport = viewModel.selectedSport {
                                currentSportHeader(sport: sport)
                            }

                            StatsOverviewCard(
                                totalXP: viewModel.userProgress?.totalXP ?? 0,
                                overallRating: viewModel.userProgress?.overallRating ?? 0,
                                currentStreak: viewModel.userProgress?.currentStreak ?? 0
                            )

                            // Error Message
                            if let errorMessage = viewModel.errorMessage {
                                errorView(message: errorMessage)
                            }

                            // Learning Path
                            learningPathSection
                        }
                    }
                    .padding(.spacingM)
                }
                .coordinateSpace(name: "scroll")
                .onChange(of: scrollOffset) { _, newValue in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        if newValue > scrollThreshold {
                            showSportSelector = false
                        } else if newValue < scrollThreshold / 2 {
                            showSportSelector = true
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadData()
            }
        }
    }

    // MARK: - Sport Selector Header
    private var sportSelectorHeader: some View {
        VStack(spacing: 0) {
            SportSelectorView(
                sports: viewModel.sports,
                selectedSport: Binding(
                    get: { viewModel.selectedSport },
                    set: { newSport in
                        if let sport = newSport {
                            Task {
                                await viewModel.selectSport(sport)
                            }
                        }
                    }
                )
            )
            .padding(.vertical, .spacingS)
            .background(Color.backgroundPrimary)

            Divider()
        }
        .animation(.easeInOut(duration: 0.25), value: showSportSelector)
    }

    // MARK: - Scroll Offset Reader
    private var scrollOffsetReader: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: -geometry.frame(in: .named("scroll")).origin.y
                )
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
    }

    // MARK: - Current Sport Header
    private func currentSportHeader(sport: Sport) -> some View {
        HStack(spacing: .spacingS) {
            Text(sport.emoji)
                .font(.title2)

            Text(sport.name)
                .font(.heading2)
                .foregroundStyle(Color.textPrimary)

            Spacer()
        }
    }

    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: .spacingM) {
            Text("Error")
                .font(.heading3)
                .foregroundStyle(Color.incorrect)

            Text(message)
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.spacingL)
        .background(Color.incorrect.opacity(0.1))
        .cornerRadius(.radiusL)
    }

    // MARK: - Learning Path Section
    @ViewBuilder
    private var learningPathSection: some View {
        if let sport = viewModel.selectedSport {
            VStack(alignment: .leading, spacing: .spacingM) {
                Text("Learning Path")
                    .font(.heading3)
                    .foregroundStyle(Color.textPrimary)

                if viewModel.isLoadingModules {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.spacingL)
                } else if viewModel.modules.isEmpty {
                    emptyModulesView(sport: sport)
                } else {
                    ForEach(viewModel.modules) { module in
                        NavigationLink {
                            ModuleLessonsView(
                                module: module,
                                sport: sport,
                                coordinator: coordinator
                            )
                        } label: {
                            ModuleCard(module: module, sport: sport)
                        }
                        .disabled(module.isLocked)
                    }
                }
            }
        }
    }

    // MARK: - Empty Modules View
    private func emptyModulesView(sport: Sport) -> some View {
        VStack(spacing: .spacingM) {
            Text(sport.emoji)
                .font(.system(size: 48))

            Text("Coming Soon!")
                .font(.heading3)
                .foregroundStyle(Color.textPrimary)

            Text("\(sport.name) lessons are being prepared. Check back soon!")
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.spacingXL)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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
            StatItem(title: "Streak", value: "\(currentStreak)", color: .warning)
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
        userRepository: MockUserRepository(),
        gameRepository: MockGameRepository()
    ))
}
