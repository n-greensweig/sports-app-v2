//
//  LearningRepository.swift
//  SportsIQ
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

    /// Mark a lesson as completed
    func completeLesson(userId: UUID, lessonId: UUID, score: Int) async throws
}
