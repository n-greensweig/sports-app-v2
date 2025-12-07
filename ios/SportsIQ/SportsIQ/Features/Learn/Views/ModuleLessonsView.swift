//
//  ModuleLessonsView.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import SwiftUI

struct ModuleLessonsView: View {
    let module: Module
    let sport: Sport
    let coordinator: AppCoordinator
    @State private var lessons: [Lesson] = []
    @State private var completions: [UUID: Int] = [:]  // lessonId -> completionCount
    @State private var isLoading = false

    // Test-out state
    @State private var testOut: TestOut?
    @State private var testOutEligibility: TestOutEligibility?
    @State private var showTestOutPrompt = false
    @State private var showTestOutView = false

    /// The index of the current lesson (first unlocked, incomplete lesson)
    private var currentLessonIndex: Int? {
        lessons.firstIndex { lesson in
            !lesson.isLocked && (completions[lesson.id] ?? 0) < lesson.requiredCompletions
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacingM) {
                // Module Header
                VStack(alignment: .leading, spacing: .spacingS) {
                    Text(module.description)
                        .font(.body)
                        .foregroundStyle(Color.textSecondary)

                    HStack(spacing: .spacingM) {
                        Label("\(module.totalLessons) lessons", systemImage: "book.fill")
                        Label("\(module.estimatedMinutes) min total", systemImage: "clock.fill")
                    }
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                }
                .padding(.bottom, .spacingS)

                // Test-Out Button (if available)
                if let testOut = testOut, let eligibility = testOutEligibility {
                    testOutCard(testOut: testOut, eligibility: eligibility)
                        .padding(.bottom, .spacingS)
                }

                Divider()

                // Lessons List
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.spacingXL)
                } else {
                    ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                        NavigationLink {
                            LessonView(
                                lesson: lesson,
                                sport: sport,
                                coordinator: coordinator
                            )
                        } label: {
                            LessonCard(
                                lesson: lesson,
                                lessonNumber: index + 1,
                                sport: sport,
                                completionCount: completions[lesson.id] ?? 0,
                                isCurrentLesson: index == currentLessonIndex
                            )
                        }
                        .disabled(lesson.isLocked)
                    }
                }
            }
            .padding(.spacingM)
        }
        .navigationTitle(module.title)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await loadLessons()
            await loadTestOutInfo()
        }
        .sheet(isPresented: $showTestOutPrompt) {
            if let testOut = testOut, let eligibility = testOutEligibility {
                TestOutPromptView(
                    testOut: testOut,
                    module: module,
                    eligibility: eligibility,
                    onStartTest: { showTestOutView = true },
                    onSkip: { /* Just dismiss */ }
                )
                .presentationDetents([.medium])
            }
        }
        .fullScreenCover(isPresented: $showTestOutView) {
            if let testOut = testOut {
                NavigationStack {
                    TestOutView(
                        testOut: testOut,
                        module: module,
                        sport: sport,
                        coordinator: coordinator,
                        onComplete: { passed in
                            showTestOutView = false
                            if passed {
                                // Refresh eligibility after passing
                                Task { await loadTestOutInfo() }
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Test-Out Card

    @ViewBuilder
    private func testOutCard(testOut: TestOut, eligibility: TestOutEligibility) -> some View {
        Button {
            showTestOutPrompt = true
        } label: {
            HStack(spacing: .spacingM) {
                // Icon
                ZStack {
                    Circle()
                        .fill(testOutCardColor(eligibility).opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: testOutIcon(eligibility))
                        .font(.title3)
                        .foregroundStyle(testOutCardColor(eligibility))
                }

                // Text
                VStack(alignment: .leading, spacing: .spacingXS) {
                    Text("Test Out of \(module.title)")
                        .font(.body.bold())
                        .foregroundStyle(Color.textPrimary)

                    Text(testOutStatusText(eligibility, testOut: testOut))
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.spacingM)
            .background(testOutCardColor(eligibility).opacity(0.08))
            .cornerRadius(.radiusL)
            .overlay(
                RoundedRectangle(cornerRadius: .radiusL)
                    .stroke(testOutCardColor(eligibility).opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func testOutCardColor(_ eligibility: TestOutEligibility) -> Color {
        if eligibility.hasPassed {
            return .correct
        } else if eligibility.canAttempt {
            return .brandPrimary
        } else {
            return .warning
        }
    }

    private func testOutIcon(_ eligibility: TestOutEligibility) -> String {
        if eligibility.hasPassed {
            return "checkmark.seal.fill"
        } else if eligibility.canAttempt {
            return "graduationcap.fill"
        } else {
            return "clock.badge.exclamationmark"
        }
    }

    private func testOutStatusText(_ eligibility: TestOutEligibility, testOut: TestOut) -> String {
        if eligibility.hasPassed {
            return "Passed! Next module unlocked"
        } else if eligibility.canAttempt {
            return "Score \(testOut.passingScore)/\(testOut.totalQuestions) to skip ahead"
        } else {
            return eligibility.statusMessage
        }
    }

    // MARK: - Loading

    private func loadLessons() async {
        isLoading = true
        do {
            lessons = try await coordinator.learningRepository.getLessons(moduleId: module.id)
            // Load completion counts
            if let userId = coordinator.currentUser?.id {
                completions = try await coordinator.learningRepository.getLessonCompletions(
                    userId: userId,
                    sportId: sport.id
                )
            }
        } catch {
            print("Error loading lessons: \(error)")
        }
        isLoading = false
    }

    private func loadTestOutInfo() async {
        guard let userId = coordinator.currentUser?.id else { return }

        do {
            testOut = try await coordinator.learningRepository.getTestOut(moduleId: module.id)
            if testOut != nil {
                testOutEligibility = try await coordinator.learningRepository.getTestOutEligibility(
                    userId: userId,
                    moduleId: module.id
                )
            }
        } catch {
            print("Error loading test-out info: \(error)")
        }
    }
}

// MARK: - Lesson Card
struct LessonCard: View {
    let lesson: Lesson
    let lessonNumber: Int
    let sport: Sport
    let completionCount: Int  // How many times user has completed this lesson
    var isCurrentLesson: Bool = false

    // Icons to cycle through for different lessons
    private static let lessonIcons = [
        "star.fill",
        "scalemass.fill",
        "football.fill",
        "figure.american.football",
        "trophy.fill"
    ]

    private var lessonIcon: String {
        LessonCard.lessonIcons[(lessonNumber - 1) % LessonCard.lessonIcons.count]
    }

    var body: some View {
        HStack(spacing: .spacingM) {
            // Progress Ring
            LessonProgressRing(
                completedSegments: completionCount,
                totalSegments: lesson.requiredCompletions,
                isLocked: lesson.isLocked,
                icon: lessonIcon,
                accentColor: sport.accentColor,
                size: 56,
                isCurrentLesson: isCurrentLesson
            )

            VStack(alignment: .leading, spacing: .spacingXS) {
                HStack(spacing: .spacingS) {
                    // Show lesson code if available
                    if let code = lesson.code {
                        Text(code)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(sport.accentColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(sport.accentColor.opacity(0.15))
                            .cornerRadius(4)
                    }

                    Text(lesson.title)
                        .font(.heading4)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.leading)
                }

                Text(lesson.description)
                    .font(.bodySmall)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                HStack(spacing: .spacingM) {
                    Label("\(lesson.estimatedMinutes) min", systemImage: "clock.fill")
                    Label("\(lesson.xpAward) XP", systemImage: "star.fill")

                    // Show completion progress
                    if !lesson.isLocked && completionCount < lesson.requiredCompletions {
                        Text("\(completionCount)/\(lesson.requiredCompletions)")
                            .fontWeight(.medium)
                            .foregroundStyle(sport.accentColor)
                    } else if completionCount >= lesson.requiredCompletions {
                        Label("Mastered", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(Color.correct)
                    }
                }
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            Image(systemName: lesson.isLocked ? "lock.fill" : "chevron.right")
                .foregroundStyle(lesson.isLocked ? Color.textTertiary : Color.textSecondary)
        }
        .padding(.spacingM)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
        .opacity(lesson.isLocked ? 0.6 : 1.0)
    }
}

#Preview("Module Lessons View") {
    NavigationStack {
        ModuleLessonsView(
            module: .footballBasics,
            sport: .football,
            coordinator: AppCoordinator(
                learningRepository: MockLearningRepository(),
                userRepository: MockUserRepository(),
                gameRepository: MockGameRepository()
            )
        )
    }
}

#Preview("Lesson Cards") {
    VStack(spacing: 16) {
        LessonCard(
            lesson: .footballBasicsLesson1,
            lessonNumber: 1,
            sport: .football,
            completionCount: 0
        )

        LessonCard(
            lesson: .footballBasicsLesson2,
            lessonNumber: 2,
            sport: .football,
            completionCount: 1
        )

        LessonCard(
            lesson: .footballBasicsLesson3,
            lessonNumber: 3,
            sport: .football,
            completionCount: 2
        )

        LessonCard(
            lesson: .footballBasicsLesson4,
            lessonNumber: 4,
            sport: .football,
            completionCount: 3
        )

        LessonCard(
            lesson: Lesson(
                id: UUID(),
                moduleId: Module.footballBasics.id,
                title: "Locked Lesson",
                description: "This lesson is locked",
                orderIndex: 5,
                estimatedMinutes: 5,
                xpAward: 50,
                isLocked: true,
                code: "TF2"
            ),
            lessonNumber: 5,
            sport: .football,
            completionCount: 0
        )
    }
    .padding()
}
