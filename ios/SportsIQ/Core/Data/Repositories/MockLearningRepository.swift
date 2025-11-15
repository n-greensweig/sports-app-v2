//
//  MockLearningRepository.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Mock implementation of LearningRepository for development and testing
class MockLearningRepository: LearningRepository {
    private var sports: [Sport] = Sport.mockSports
    private var modules: [Module] = Module.mockModules
    private var lessons: [Lesson] = Lesson.mockLessons

    func getSports() async throws -> [Sport] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return sports.sorted { $0.displayOrder < $1.displayOrder }
    }

    func getSport(id: UUID) async throws -> Sport? {
        try await Task.sleep(nanoseconds: 300_000_000)
        return sports.first { $0.id == id }
    }

    func getModules(sportId: UUID) async throws -> [Module] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return modules
            .filter { $0.sportId == sportId }
            .sorted { $0.orderIndex < $1.orderIndex }
    }

    func getLessons(moduleId: UUID) async throws -> [Lesson] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return lessons
            .filter { $0.moduleId == moduleId }
            .sorted { $0.orderIndex < $1.orderIndex }
    }

    func getLesson(id: UUID) async throws -> Lesson? {
        try await Task.sleep(nanoseconds: 500_000_000)
        return lessons.first { $0.id == id }
    }

    func submitAnswer(
        userId: UUID,
        itemId: UUID,
        answer: UserAnswer,
        context: SubmissionContext,
        timeSpentSeconds: Int
    ) async throws -> Submission {
        try await Task.sleep(nanoseconds: 300_000_000)

        // For mock, just return a submission
        // In real implementation, this would validate the answer
        let isCorrect = Bool.random() // Mock: random result
        let xpAwarded = isCorrect ? 10 : 0

        return Submission(
            userId: userId,
            itemId: itemId,
            context: context,
            userAnswer: answer,
            isCorrect: isCorrect,
            timeSpentSeconds: timeSpentSeconds,
            xpAwarded: xpAwarded
        )
    }

    func completeLesson(userId: UUID, lessonId: UUID, score: Int) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        // Mock: In real implementation, this would unlock next lesson
        print("Lesson \(lessonId) completed with score \(score)")
    }
}
