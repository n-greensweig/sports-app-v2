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
    @State private var selectedLesson: Lesson?
    @State private var showProfile = false
    @State private var showSportPicker = false
    @State private var selectedLessonNodeIndex: Int? = nil
    @State private var currentSection: LessonSection = LessonSection.defaultSection
    @State private var scrollProgress: CGFloat = 0.0

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
            ZStack(alignment: .top) {
                // Main layout with sticky header
                VStack(spacing: 0) {
                    // Sticky Section Header - always visible below nav bar
                    if viewModel.selectedSport != nil {
                        SectionHeader(section: currentSection)
                            .padding(.top, .spacingS)
                            .padding(.bottom, .spacingS)
                            .background(Color(UIColor.systemBackground))
                            .animation(.easeInOut(duration: 0.25), value: currentSection.id)
                    }

                    // Scrollable content
                    ScrollView {
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

                                // Streak Card (only show if streak > 0)
                                if let streak = viewModel.currentStreak, streak.currentStreak > 0 {
                                    StreakCard(
                                        currentStreak: streak.currentStreak,
                                        longestStreak: streak.longestStreak
                                    )
                                    .padding(.horizontal, .spacingM)
                                    .padding(.bottom, .spacingM)
                                }

                                // Lesson Path (without the header, which is now sticky)
                                lessonPathContent
                            }
                        }
                        .contentShape(Rectangle()) // Make entire scroll area tappable
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: geo.frame(in: .named("scroll")).minY
                                    )
                            }
                        )
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                        // Calculate scroll progress based on content height
                        let lessonCount = CGFloat(viewModel.lessons.count)
                        guard lessonCount > 0 else { return }

                        // Estimate total scrollable height
                        let rowHeight: CGFloat = 94 + 24 // nodeSize + 30 + verticalSpacing
                        let totalHeight = lessonCount * rowHeight
                        let screenHeight = UIScreen.main.bounds.height

                        // Progress: 0 at top, 1 when fully scrolled
                        let maxScroll = max(1, totalHeight - screenHeight + 200)
                        let currentScroll = -offset
                        scrollProgress = min(1, max(0, currentScroll / maxScroll))
                    }
                    .onTapGesture {
                        // Dismiss popup when tapping anywhere outside the nodes
                        if selectedLessonNodeIndex != nil {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                selectedLessonNodeIndex = nil
                            }
                        }
                    }
                }

                // Sport picker dropdown overlay (appears below nav bar)
                if showSportPicker {
                    // Dimmed background to dismiss
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showSportPicker = false
                            }
                        }

                    VStack(spacing: 0) {
                        SportPickerDropdown(
                            sports: viewModel.sports,
                            selectedSport: viewModel.selectedSport,
                            onSportSelected: { sport in
                                Task {
                                    await viewModel.selectSport(sport)
                                }
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showSportPicker = false
                                }
                            },
                            onDismiss: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showSportPicker = false
                                }
                            }
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))

                        Spacer()
                    }
                }
            }
            .animation(.easeInOut(duration: 0.2), value: showSportPicker)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Sport Picker (top-left)
                ToolbarItem(placement: .topBarLeading) {
                    SportPickerButton(
                        sports: viewModel.sports,
                        selectedSport: Binding(
                            get: { viewModel.selectedSport },
                            set: { _ in }
                        ),
                        showPicker: $showSportPicker,
                        onSportSelected: { sport in
                            Task {
                                await viewModel.selectSport(sport)
                            }
                        }
                    )
                }

                // Profile button (top-right)
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
                // Set initial section based on selected sport
                if let sport = viewModel.selectedSport {
                    currentSection = LessonSection.defaultSection(forSport: sport.slug)
                }
            }
            .onChange(of: viewModel.selectedSport?.slug) { _, newSlug in
                // Update section when sport changes
                if let slug = newSlug {
                    currentSection = LessonSection.defaultSection(forSport: slug)
                }
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

    // MARK: - Lesson Path Content (scrollable area below sticky header)
    @ViewBuilder
    private var lessonPathContent: some View {
        if let sport = viewModel.selectedSport {
            if viewModel.isLoadingLessons {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.spacingXL)
            } else if viewModel.lessons.isEmpty {
                emptyLessonsView(sport: sport)
                    .padding(.spacingM)
            } else {
                // Gamified lesson path with popup
                LessonPathView(
                    lessons: viewModel.lessons,
                    completions: viewModel.lessonCompletions,
                    sport: sport,
                    onLessonStart: { lesson in
                        selectedLesson = lesson
                    },
                    selectedLessonIndex: $selectedLessonNodeIndex,
                    onVisibleSectionChange: { section in
                        // Update section with haptic feedback
                        if currentSection.id != section.id {
                            currentSection = section
                            HapticManager.shared.playSectionChangeFeedback()
                        }
                    },
                    scrollProgress: scrollProgress
                )
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
private struct ScrollOffsetPreferenceKey: PreferenceKey {
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
