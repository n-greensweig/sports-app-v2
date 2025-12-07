//
//  MockLearningRepository.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import Foundation

/// Mock implementation of LearningRepository for development and testing
class MockLearningRepository: LearningRepository {
    private var sports: [Sport] = Sport.mockSports
    private var modules: [Module] = Module.mockModules
    private var lessons: [Lesson] = Lesson.mockLessons
    private var lessonCompletionCounts: [UUID: Int] = [:]  // Track completions in memory

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
        // Increment completion count
        let currentCount = lessonCompletionCounts[lessonId] ?? 0
        lessonCompletionCounts[lessonId] = currentCount + 1
        print("Lesson \(lessonId) completed with score \(score). Completion count: \(currentCount + 1)")
    }

    func getLessonCompletions(userId: UUID, sportId: UUID) async throws -> [UUID: Int] {
        try await Task.sleep(nanoseconds: 300_000_000)
        // Return all tracked completions (mock doesn't filter by sport)
        return lessonCompletionCounts
    }

    // MARK: - Test-Out Methods

    private var testOutAttempts: [TestOutAttempt] = []

    func getTestOut(moduleId: UUID) async throws -> TestOut? {
        try await Task.sleep(nanoseconds: 300_000_000)
        // Mock: Return test-out for Rookie module
        if moduleId == Module.rookie.id {
            return TestOut.rookieTestOut
        }
        return nil
    }

    func getTestOutEligibility(userId: UUID, moduleId: UUID) async throws -> TestOutEligibility {
        try await Task.sleep(nanoseconds: 300_000_000)

        // Check if already passed
        if testOutAttempts.contains(where: { $0.moduleId == moduleId && $0.passed }) {
            return .alreadyPassed
        }

        // Count recent attempts (last 24h)
        let recentAttempts = testOutAttempts.filter {
            $0.moduleId == moduleId &&
            $0.attemptedAt > Date().addingTimeInterval(-24 * 60 * 60)
        }

        if recentAttempts.count >= 2 {
            let cooldownEnds = recentAttempts.first!.attemptedAt.addingTimeInterval(24 * 60 * 60)
            return .inCooldown(until: cooldownEnds)
        }

        return TestOutEligibility(
            canAttempt: true,
            attemptsRemaining: 2 - recentAttempts.count,
            cooldownEndsAt: nil,
            hasPassed: false
        )
    }

    func getTestOutItems(moduleId: UUID) async throws -> [Item] {
        try await Task.sleep(nanoseconds: 500_000_000)
        // Return mock items from the first lesson for testing
        return Array(Lesson.theField1.items.prefix(25))
    }

    func submitTestOutAttempt(userId: UUID, moduleId: UUID, score: Int, totalQuestions: Int) async throws -> TestOutAttempt {
        try await Task.sleep(nanoseconds: 300_000_000)

        let passed = score >= 20 // 20/25 to pass
        let attempt = TestOutAttempt(
            id: UUID(),
            userId: userId,
            moduleId: moduleId,
            score: score,
            passed: passed,
            attemptedAt: Date()
        )

        testOutAttempts.append(attempt)
        return attempt
    }
}
