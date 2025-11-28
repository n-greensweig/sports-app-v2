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
                // Main content
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

                            // Lesson Path
                            lessonPathSection
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
                    // Duolingo-style lesson path with popup
                    LessonPathView(
                        lessons: viewModel.lessons,
                        completions: viewModel.lessonCompletions,
                        sport: sport,
                        onLessonStart: { lesson in
                            selectedLesson = lesson
                        }
                    )
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

#Preview("Home View") {
    HomeView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository(),
        gameRepository: MockGameRepository()
    ))
}
