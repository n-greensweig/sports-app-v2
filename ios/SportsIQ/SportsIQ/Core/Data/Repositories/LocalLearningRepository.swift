//
//  LocalLearningRepository.swift
//  Ola Ball
//
//  Created on 2025-12-18.
//  Guest Mode Implementation - Local storage implementation of LearningRepository
//

import Foundation
import Supabase

/// Local storage implementation of LearningRepository for guest users
/// Read operations (sports, modules, lessons) delegate to Supabase (content is public)
/// Write operations (submissions, completions) store locally
final class LocalLearningRepository: LearningRepository {
    // MARK: - Properties

    private let supabaseClient: SupabaseClient
    private let localDataStore: LocalDataStore
    private let localUserRepository: LocalUserRepository
    private let guestUserId: UUID

    // Cache for content (same as SupabaseLearningRepository)
    private var sportsCache: [Sport]?
    private var modulesCache: [UUID: [Module]] = [:]
    private var lessonsCache: [UUID: [Lesson]] = [:]
    private var lessonDetailsCache: [UUID: Lesson] = [:]
    private var moduleSportLookup: [UUID: UUID] = [:]

    private let cacheLock = NSLock()

    // MARK: - Initialization

    init(
        guestUserId: UUID,
        supabaseClient: SupabaseClient = SupabaseService.shared.client,
        localDataStore: LocalDataStore = .shared,
        localUserRepository: LocalUserRepository
    ) {
        self.guestUserId = guestUserId
        self.supabaseClient = supabaseClient
        self.localDataStore = localDataStore
        self.localUserRepository = localUserRepository
    }

    // MARK: - Read Operations (Delegate to Supabase - Content is Public)

    func getSports() async throws -> [Sport] {
        if let cached = sportsCache {
            return cached
        }

        let response = try await supabaseClient
            .from("sports")
            .select()
            .eq("is_active", value: true)
            .order("order_index", ascending: true)
            .execute()

        let dtos: [SportDTO] = try ResponseParser.decode([SportDTO].self, from: response.data)
        let sports = try dtos.map { try $0.toDomain() }

        sportsCache = sports
        return sports
    }

    func getSport(id: UUID) async throws -> Sport? {
        let sports = try await getSports()
        return sports.first { $0.id == id }
    }

    func getModules(sportId: UUID) async throws -> [Module] {
        if let cached = modulesCache[sportId] {
            return cached
        }

        let response = try await supabaseClient
            .from("modules")
            .select()
            .eq("sport_id", value: sportId.uuidString)
            .order("order_index", ascending: true)
            .execute()

        let dtos: [ModuleDTO] = try ResponseParser.decode([ModuleDTO].self, from: response.data)
        let moduleIds = dtos.compactMap { UUID(uuidString: $0.id) }

        // Fetch lesson summary
        let lessonSummary = try await fetchLessonSummaries(for: moduleIds)

        var modules: [Module] = []
        for dto in dtos {
            guard let moduleId = UUID(uuidString: dto.id),
                  let moduleSportId = UUID(uuidString: dto.sport_id) else { continue }

            let summary = lessonSummary[moduleId] ?? (0, 0, 0)
            let isLocked = summary.totalLessons == 0 ? dto.order_index > 0 : summary.lockedLessons == summary.totalLessons

            let module = try dto.toDomain(totalLessons: summary.totalLessons, isLocked: isLocked)

            cacheLock.withLock {
                moduleSportLookup[moduleId] = moduleSportId
            }

            let enrichedModule = Module(
                id: module.id,
                sportId: module.sportId,
                title: module.title,
                description: module.description,
                orderIndex: module.orderIndex,
                estimatedMinutes: summary.totalMinutes,
                totalLessons: summary.totalLessons,
                isLocked: module.isLocked
            )

            modules.append(enrichedModule)
        }

        modulesCache[sportId] = modules
        return modules
    }

    func getLessons(moduleId: UUID) async throws -> [Lesson] {
        if let cached = lessonsCache[moduleId] {
            return cached
        }

        let response = try await supabaseClient
            .from("lessons")
            .select()
            .eq("module_id", value: moduleId.uuidString)
            .order("order_index", ascending: true)
            .execute()

        let dtos: [LessonDTO] = try ResponseParser.decode([LessonDTO].self, from: response.data)
        let lessonIds = dtos.compactMap { UUID(uuidString: $0.id) }
        let itemsByLesson = try await fetchItems(forLessonIds: lessonIds)

        var lessons: [Lesson] = []
        for dto in dtos {
            guard let lessonId = UUID(uuidString: dto.id) else { continue }
            let items = itemsByLesson[lessonId] ?? []
            let lesson = try dto.toDomain(items: items)
            lessons.append(lesson)
            lessonDetailsCache[lessonId] = lesson
        }

        lessonsCache[moduleId] = lessons
        return lessons
    }

    func getLesson(id: UUID) async throws -> Lesson? {
        if let cached = lessonDetailsCache[id] {
            return cached
        }

        let response = try await supabaseClient
            .from("lessons")
            .select()
            .eq("id", value: id.uuidString)
            .limit(1)
            .execute()

        let dtos: [LessonDTO] = try ResponseParser.decode([LessonDTO].self, from: response.data)
        guard let dto = dtos.first else { return nil }

        let itemsMap = try await fetchItems(forLessonIds: [id])
        let lesson = try dto.toDomain(items: itemsMap[id] ?? [])

        lessonDetailsCache[id] = lesson
        return lesson
    }

    // MARK: - Write Operations (Store Locally)

    func submitAnswer(
        userId: UUID,
        itemId: UUID,
        answer: UserAnswer,
        context: SubmissionContext,
        timeSpentSeconds: Int
    ) async throws -> Submission {
        // Get item details to evaluate answer
        let lessonId = try await resolveLessonId(for: itemId)
        guard let lesson = try await getLesson(id: lessonId),
              let item = lesson.items.first(where: { $0.id == itemId }) else {
            throw NetworkError.notFound
        }

        let sportId = try await resolveSportId(forLesson: lessonId, moduleId: lesson.moduleId)
        let isCorrect = evaluate(answer: answer, against: item.correctAnswer)
        let xpAwarded = isCorrect ? item.xpValue : 0

        // Update local progress
        try await localUserRepository.updateAnswerStats(correct: isCorrect, sportId: sportId)

        if xpAwarded > 0 {
            try await localUserRepository.addXP(xpAwarded, sportId: sportId)
        }

        // Record seen item
        var completions = localDataStore.load(forKey: .lessonCompletions, as: LocalLessonCompletionsContainer.self)
            ?? LocalLessonCompletionsContainer()

        var lessonCompletion = completions.getCompletion(for: lessonId)
            ?? LocalLessonCompletion(lessonId: lessonId)

        if !lessonCompletion.seenItemIds.contains(itemId) {
            lessonCompletion.seenItemIds.append(itemId)
            completions.setCompletion(lessonCompletion)
            localDataStore.save(completions, forKey: .lessonCompletions)
        }

        return Submission(
            id: UUID(),
            userId: userId,
            itemId: itemId,
            context: context,
            userAnswer: answer,
            isCorrect: isCorrect,
            timeSpentSeconds: timeSpentSeconds,
            xpAwarded: xpAwarded,
            submittedAt: Date()
        )
    }

    func completeLesson(userId: UUID, lessonId: UUID, score: Int) async throws {
        guard let lesson = try await getLesson(id: lessonId) else {
            throw NetworkError.notFound
        }

        let sportId = try await resolveSportId(forLesson: lessonId, moduleId: lesson.moduleId)

        // Add XP
        if score > 0 {
            try await localUserRepository.addXP(score, sportId: sportId)
        }

        // Update lesson completion count
        var completions = localDataStore.load(forKey: .lessonCompletions, as: LocalLessonCompletionsContainer.self)
            ?? LocalLessonCompletionsContainer()

        var lessonCompletion = completions.getCompletion(for: lessonId)
            ?? LocalLessonCompletion(lessonId: lessonId)

        lessonCompletion.completionCount += 1
        lessonCompletion.lastCompletedAt = Date()
        completions.setCompletion(lessonCompletion)

        try localDataStore.saveSync(completions, forKey: .lessonCompletions)

        // Increment lessons completed if this is the first time reaching required completions
        if lessonCompletion.completionCount == lesson.requiredCompletions {
            try await localUserRepository.incrementLessonsCompleted(sportId: sportId)
        }

        // Update streak
        _ = try await localUserRepository.updateStreak(userId: userId, sportId: sportId)

        print("✅ [Guest] Lesson completed - count: \(lessonCompletion.completionCount)")
    }

    func getLessonCompletions(userId: UUID, sportId: UUID) async throws -> [UUID: Int] {
        guard userId == guestUserId else { return [:] }

        let completions = localDataStore.load(forKey: .lessonCompletions, as: LocalLessonCompletionsContainer.self)
            ?? LocalLessonCompletionsContainer()

        return completions.toCompletionCountDict()
    }

    // MARK: - Test-Out Methods

    func getTestOut(moduleId: UUID) async throws -> TestOut? {
        // Fetch from Supabase (read-only)
        let response = try await supabaseClient
            .from("module_test_outs")
            .select()
            .eq("module_id", value: moduleId.uuidString)
            .eq("is_active", value: true)
            .limit(1)
            .execute()

        let dtos: [TestOutDTO] = try ResponseParser.decode([TestOutDTO].self, from: response.data)
        guard let dto = dtos.first else { return nil }
        return try dto.toDomain()
    }

    func getTestOutEligibility(userId: UUID, moduleId: UUID) async throws -> TestOutEligibility {
        // For guest mode, simplified eligibility - always allow 2 attempts per day
        // We don't track this locally for simplicity
        return TestOutEligibility(
            canAttempt: true,
            attemptsRemaining: 2,
            cooldownEndsAt: nil,
            hasPassed: false
        )
    }

    func getTestOutItems(moduleId: UUID) async throws -> [Item] {
        // Fetch from Supabase (read-only)
        let response = try await supabaseClient
            .from("test_out_items")
            .select("item_id")
            .eq("module_id", value: moduleId.uuidString)
            .order("order_index", ascending: true)
            .execute()

        struct TestOutItemRow: Decodable {
            let item_id: String
        }
        let rows: [TestOutItemRow] = try ResponseParser.decode([TestOutItemRow].self, from: response.data)
        let itemIds = rows.compactMap { UUID(uuidString: $0.item_id) }

        guard !itemIds.isEmpty else { return [] }

        let itemsResponse = try await supabaseClient
            .from("items")
            .select()
            .in("id", values: itemIds.map { $0.uuidString })
            .execute()

        let itemDTOs: [ItemDTO] = try ResponseParser.decode([ItemDTO].self, from: itemsResponse.data)
        let variantMap = try await fetchActiveVariants(forItemIds: itemIds)

        var itemMap: [UUID: Item] = [:]
        for (index, dto) in itemDTOs.enumerated() {
            let variant = variantMap[dto.id]
            let item = try dto.toDomain(variant: variant, orderIndex: index)
            itemMap[item.id] = item
        }

        return itemIds.compactMap { itemMap[$0] }
    }

    func submitTestOutAttempt(userId: UUID, moduleId: UUID, score: Int, totalQuestions: Int) async throws -> TestOutAttempt {
        guard let testOut = try await getTestOut(moduleId: moduleId) else {
            throw NetworkError.notFound
        }

        let passed = score >= testOut.passingScore

        // For guest mode, we just return the result without persisting
        // The user won't have module unlocking benefits in guest mode
        return TestOutAttempt(
            id: UUID(),
            userId: userId,
            moduleId: moduleId,
            score: score,
            passed: passed,
            attemptedAt: Date()
        )
    }

    // MARK: - Private Helpers

    private func fetchLessonSummaries(for moduleIds: [UUID]) async throws -> [UUID: (totalLessons: Int, totalMinutes: Int, lockedLessons: Int)] {
        guard !moduleIds.isEmpty else { return [:] }

        struct LessonSummaryRow: Decodable {
            let module_id: String
            let est_minutes: Int
            let is_locked: Bool
        }

        let response = try await supabaseClient
            .from("lessons")
            .select("module_id, est_minutes, is_locked")
            .in("module_id", values: moduleIds.map { $0.uuidString })
            .execute()

        let rows: [LessonSummaryRow] = try ResponseParser.decode([LessonSummaryRow].self, from: response.data)
        var summary: [UUID: (totalLessons: Int, totalMinutes: Int, lockedLessons: Int)] = [:]

        for row in rows {
            guard let moduleId = UUID(uuidString: row.module_id) else { continue }
            var current = summary[moduleId] ?? (0, 0, 0)
            current.totalLessons += 1
            current.totalMinutes += row.est_minutes
            if row.is_locked { current.lockedLessons += 1 }
            summary[moduleId] = current
        }

        return summary
    }

    private func fetchItems(forLessonIds lessonIds: [UUID]) async throws -> [UUID: [Item]] {
        guard !lessonIds.isEmpty else { return [:] }

        let response = try await supabaseClient
            .from("items")
            .select()
            .in("lesson_id", values: lessonIds.map { $0.uuidString })
            .order("created_at", ascending: true)
            .execute()

        let dtos: [ItemDTO] = try ResponseParser.decode([ItemDTO].self, from: response.data)
        let itemIds = dtos.compactMap { UUID(uuidString: $0.id) }
        let variantMap = try await fetchActiveVariants(forItemIds: itemIds)

        var grouped: [UUID: [Item]] = [:]
        var orderTracker: [UUID: Int] = [:]

        for dto in dtos {
            guard let lessonIdString = dto.lesson_id,
                  let lessonId = UUID(uuidString: lessonIdString) else { continue }

            let nextOrder = orderTracker[lessonId, default: 0]
            let variant = variantMap[dto.id]
            let item = try dto.toDomain(variant: variant, orderIndex: nextOrder)
            grouped[lessonId, default: []].append(item)
            orderTracker[lessonId] = nextOrder + 1
        }

        return grouped
    }

    private func fetchActiveVariants(forItemIds itemIds: [UUID]) async throws -> [String: ItemVariantDTO] {
        guard !itemIds.isEmpty else { return [:] }

        let response = try await supabaseClient
            .from("item_variants")
            .select()
            .in("item_id", values: itemIds.map { $0.uuidString })
            .eq("active", value: true)
            .order("version", ascending: false)
            .execute()

        let variants: [ItemVariantDTO] = try ResponseParser.decode([ItemVariantDTO].self, from: response.data)
        var map: [String: ItemVariantDTO] = [:]
        for variant in variants {
            if map[variant.item_id] == nil {
                map[variant.item_id] = variant
            }
        }
        return map
    }

    private func resolveLessonId(for itemId: UUID) async throws -> UUID {
        struct ItemLessonRow: Decodable {
            let id: String
            let lesson_id: String?
        }

        let response = try await supabaseClient
            .from("items")
            .select("id, lesson_id")
            .eq("id", value: itemId.uuidString)
            .limit(1)
            .execute()

        let rows: [ItemLessonRow] = try ResponseParser.decode([ItemLessonRow].self, from: response.data)
        guard let row = rows.first,
              let lessonIdString = row.lesson_id,
              let lessonId = UUID(uuidString: lessonIdString) else {
            throw NetworkError.notFound
        }

        return lessonId
    }

    private func resolveSportId(forLesson lessonId: UUID, moduleId: UUID) async throws -> UUID {
        if let cached = cacheLock.withLock({ moduleSportLookup[moduleId] }) {
            return cached
        }

        struct ModuleSportRow: Decodable {
            let id: String
            let sport_id: String
        }

        let response = try await supabaseClient
            .from("modules")
            .select("id, sport_id")
            .eq("id", value: moduleId.uuidString)
            .limit(1)
            .execute()

        let rows: [ModuleSportRow] = try ResponseParser.decode([ModuleSportRow].self, from: response.data)
        guard let row = rows.first,
              let sportId = UUID(uuidString: row.sport_id) else {
            throw NetworkError.notFound
        }

        cacheLock.withLock {
            moduleSportLookup[moduleId] = sportId
        }

        return sportId
    }

    private func evaluate(answer: UserAnswer, against correct: ItemAnswer) -> Bool {
        switch (answer, correct) {
        case (.single(let lhs), .single(let rhs)):
            return lhs == rhs
        case (.single(let lhs), .boolean(let rhs)):
            return (lhs == 0 && rhs) || (lhs == 1 && !rhs)
        case (.multiple(let lhs), .multiple(let rhs)):
            return Set(lhs) == Set(rhs)
        case (.slider(let value), .range(let min, let max)):
            return value >= min && value <= max
        case (.text(let lhs), .text(let rhs)):
            return lhs.lowercased() == rhs.lowercased()
        case (.boolean(let lhs), .boolean(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

// MARK: - NSLock Convenience

private extension NSLock {
    func withLock<T>(_ block: () -> T) -> T {
        lock()
        defer { unlock() }
        return block()
    }
}
