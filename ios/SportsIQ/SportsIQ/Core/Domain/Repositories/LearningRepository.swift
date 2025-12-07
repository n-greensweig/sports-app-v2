//
//  LearningRepository.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import Foundation

/// Protocol for learning-related data operations
protocol LearningRepository {
    /// Get all available sports
    func getSports() async throws -> [Sport]

    /// Get a specific sport by ID
    func getSport(id: UUID) async throws -> Sport?

    /// Get all modules for a sport
    func getModules(sportId: UUID) async throws -> [Module]

    /// Get lessons for a module
    func getLessons(moduleId: UUID) async throws -> [Lesson]

    /// Get a specific lesson with all items
    func getLesson(id: UUID) async throws -> Lesson?

    /// Submit an answer to an item
    func submitAnswer(
        userId: UUID,
        itemId: UUID,
        answer: UserAnswer,
        context: SubmissionContext,
        timeSpentSeconds: Int
    ) async throws -> Submission

    /// Mark a lesson as completed and increment completion count
    func completeLesson(userId: UUID, lessonId: UUID, score: Int) async throws

    /// Get lesson completion counts for a user's lessons in a sport
    /// Returns a dictionary mapping lessonId -> completionCount
    func getLessonCompletions(userId: UUID, sportId: UUID) async throws -> [UUID: Int]

    // MARK: - Test-Out Methods

    /// Get the test-out configuration for a module (nil if not available)
    func getTestOut(moduleId: UUID) async throws -> TestOut?

    /// Get user's eligibility to attempt a module test-out
    func getTestOutEligibility(userId: UUID, moduleId: UUID) async throws -> TestOutEligibility

    /// Get the items (questions) for a module test-out
    func getTestOutItems(moduleId: UUID) async throws -> [Item]

    /// Submit a test-out attempt and record the result
    /// Returns the attempt record, and if passed, unlocks the next module
    func submitTestOutAttempt(userId: UUID, moduleId: UUID, score: Int, totalQuestions: Int) async throws -> TestOutAttempt
}
