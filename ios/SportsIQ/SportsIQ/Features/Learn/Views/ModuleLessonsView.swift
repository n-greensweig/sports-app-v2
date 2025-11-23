//
//  ModuleLessonsView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct ModuleLessonsView: View {
    let module: Module
    let sport: Sport
    let coordinator: AppCoordinator
    @State private var lessons: [Lesson] = []
    @State private var isLoading = false

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
                                sport: sport
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
        }
    }

    private func loadLessons() async {
        isLoading = true
        do {
            lessons = try await coordinator.learningRepository.getLessons(moduleId: module.id)
        } catch {
            print("Error loading lessons: \(error)")
        }
        isLoading = false
    }
}

// MARK: - Lesson Card
struct LessonCard: View {
    let lesson: Lesson
    let lessonNumber: Int
    let sport: Sport

    var body: some View {
        HStack(spacing: .spacingM) {
            // Lesson Number
            ZStack {
                Circle()
                    .fill(lesson.isLocked ? Color.backgroundTertiary : sport.accentColor.opacity(0.2))
                    .frame(width: 44, height: 44)

                if lesson.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(Color.textTertiary)
                } else {
                    Text("\(lessonNumber)")
                        .font(.heading4)
                        .foregroundStyle(sport.accentColor)
                }
            }

            VStack(alignment: .leading, spacing: .spacingXS) {
                Text(lesson.title)
                    .font(.heading4)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)

                Text(lesson.description)
                    .font(.bodySmall)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                HStack(spacing: .spacingM) {
                    Label("\(lesson.estimatedMinutes) min", systemImage: "clock.fill")
                    Label("\(lesson.xpAward) XP", systemImage: "star.fill")
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
