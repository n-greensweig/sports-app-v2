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
    @State private var selectedLesson: Lesson?
    @State private var showProfile = false

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

                    VStack(spacing: 0) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.spacingXL)
                                .padding(.top, 100)
                        } else {
                            // Error Message
                            if let errorMessage = viewModel.errorMessage {
                                errorView(message: errorMessage)
                                    .padding(.spacingM)
                            }

                            // Lesson Path
                            lessonPathSection
                        }
                    }
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showProfile = true
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                            .foregroundStyle(Color.brandPrimary)
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileView(coordinator: coordinator)
            }
            .task {
                await viewModel.loadData()
            }
            .navigationDestination(item: $selectedLesson) { lesson in
                if let sport = viewModel.selectedSport {
                    LessonView(
                        lesson: lesson,
                        sport: sport,
                        coordinator: coordinator
                    )
                }
            }
            .onChange(of: selectedLesson) { oldValue, newValue in
                // Refresh data when returning from a lesson (lesson was selected, now nil)
                if oldValue != nil && newValue == nil {
                    Task {
                        await viewModel.loadData()
                    }
                }
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

    // MARK: - Lesson Path Section
    @ViewBuilder
    private var lessonPathSection: some View {
        if let sport = viewModel.selectedSport {
            VStack(spacing: 0) {
                // Section Header
                SectionHeader(
                    title: sport.name,
                    subtitle: "Section 1, Unit 1",
                    sport: sport
                )
                .padding(.top, .spacingM)

                if viewModel.isLoadingLessons {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.spacingXL)
                } else if viewModel.lessons.isEmpty {
                    emptyLessonsView(sport: sport)
                        .padding(.spacingM)
                } else {
                    // Duolingo-style lesson path
                    LessonPathView(
                        lessons: viewModel.lessons,
                        completions: viewModel.lessonCompletions,
                        sport: sport
                    ) { lesson in
                        selectedLesson = lesson
                    }
                }
            }
        }
    }

    // MARK: - Empty Lessons View
    private func emptyLessonsView(sport: Sport) -> some View {
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

#Preview("Home View") {
    HomeView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository(),
        gameRepository: MockGameRepository()
    ))
}
