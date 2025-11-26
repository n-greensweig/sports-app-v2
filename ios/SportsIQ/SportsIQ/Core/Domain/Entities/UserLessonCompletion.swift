//
//  UserLessonCompletion.swift
//  Ola Ball
//
//  Tracks how many times a user has completed each lesson
//

import Foundation

/// Tracks lesson completion count for multi-completion mastery system
struct UserLessonCompletion: Identifiable, Codable, Hashable {
    let id: UUID
    let userId: UUID
    let lessonId: UUID
    let completionCount: Int
    let lastCompletedAt: Date?
    let seenItemIds: [UUID]
    let createdAt: Date
    let updatedAt: Date

    init(
        id: UUID = UUID(),
        userId: UUID,
        lessonId: UUID,
        completionCount: Int = 0,
        lastCompletedAt: Date? = nil,
        seenItemIds: [UUID] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.lessonId = lessonId
        self.completionCount = completionCount
        self.lastCompletedAt = lastCompletedAt
        self.seenItemIds = seenItemIds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    /// Returns true if the lesson has been completed enough times
    func isMastered(requiredCompletions: Int) -> Bool {
        completionCount >= requiredCompletions
    }

    /// Returns the progress as a fraction (0.0 to 1.0)
    func progress(requiredCompletions: Int) -> Double {
        guard requiredCompletions > 0 else { return 0 }
        return min(1.0, Double(completionCount) / Double(requiredCompletions))
    }

    /// Returns the number of segments to fill (for ring UI)
    /// e.g., for 3 required completions: 0, 1, 2, or 3 segments
    func completedSegments(requiredCompletions: Int) -> Int {
        min(completionCount, requiredCompletions)
    }
}

// MARK: - Mock Data
extension UserLessonCompletion {
    static let mockNoProgress = UserLessonCompletion(
        userId: UUID(),
        lessonId: Lesson.footballBasicsLesson1.id,
        completionCount: 0
    )

    static let mockOneCompletion = UserLessonCompletion(
        userId: UUID(),
        lessonId: Lesson.footballBasicsLesson1.id,
        completionCount: 1,
        lastCompletedAt: Date()
    )

    static let mockTwoCompletions = UserLessonCompletion(
        userId: UUID(),
        lessonId: Lesson.footballBasicsLesson1.id,
        completionCount: 2,
        lastCompletedAt: Date()
    )

    static let mockMastered = UserLessonCompletion(
        userId: UUID(),
        lessonId: Lesson.footballBasicsLesson1.id,
        completionCount: 3,
        lastCompletedAt: Date()
    )
}
