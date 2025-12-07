//
//  SupabaseLearningRepository.swift
//  Ola Ball
//
//  Created for Database Setup Task 5
//

import Foundation
import Supabase
#if canImport(PostgrestKit)
import PostgrestKit
#endif

/// Concrete implementation of `LearningRepository` backed by Supabase/Postgrest
///
/// This repository is responsible for loading learning content (sports, modules,
/// lessons, and lesson items) from the Supabase database, as well as recording
/// learning activity such as submissions and lesson completions.
final class SupabaseLearningRepository: LearningRepository {
    // MARK: - Nested Types

    private struct CacheEntry<Value> {
        let value: Value
        let expiration: Date

        var isExpired: Bool { Date() > expiration }
    }

    private struct LessonSummaryRow: Decodable {
        let module_id: String
        let est_minutes: Int
        let is_locked: Bool
    }

    private struct ModuleSportRow: Decodable {
        let id: String
        let sport_id: String
    }

    private struct LessonMetadataRow: Decodable {
        let id: String
        let module_id: String
    }

    private struct ItemLessonRow: Decodable {
        let id: String
        let lesson_id: String?
    }

    private struct VariantIdRow: Decodable {
        let id: String
        let item_id: String
    }

    private struct SubmissionInsertPayload: Encodable {
        let user_id: String
        let context: String
        let item_variant_id: String
        let response_json: [String: AnyCodable]
        let latency_ms: Int
        let device_platform: String
    }

    private struct SubmissionJudgmentInsertPayload: Encodable {
        let submission_id: String
        let submission_submitted_at: String
        let is_correct: Bool
        let judged_by: String
        let explanation: String?
        let confidence: Double?
    }



    private struct XPEventInsertPayload: Encodable {
        let user_id: String
        let sport_id: String
        let source: String
        let amount: Int
        let meta_json: [String: AnyCodable]?
    }

    private struct UserProgressInsertPayload: Encodable {
        let user_id: String
        let sport_id: String
        let level: Int
        let overall_rating: Int
        let current_module_id: String?
        let current_lesson_id: String?
        let total_xp: Int
        let lessons_completed: Int
        let live_answers: Int
        let concepts_mastered: Int
        let last_active_at: String
    }

    private struct UserProgressUpdatePayload: Encodable {
        let total_xp: Int
        let lessons_completed: Int
        let current_module_id: String?
        let current_lesson_id: String?
        let last_active_at: String
    }

    // MARK: - Properties

    private let client: SupabaseClient
    private let cacheTTL: TimeInterval = 60 * 5
    private let maxRetries = 2
    private let initialRetryDelay: TimeInterval = 0.5

    private var sportsCache: CacheEntry<[Sport]>?
    private var modulesCache: [UUID: CacheEntry<[Module]>] = [:]
    private var lessonsByModule: [UUID: [Lesson]] = [:]
    private var lessonDetails: [UUID: Lesson] = [:]
    private var moduleSportLookup: [UUID: UUID] = [:]
    private var lessonSportLookup: [UUID: UUID] = [:]
    private var itemLessonLookup: [UUID: UUID] = [:]
    private var itemVariantLookup: [UUID: UUID] = [:]
    private let userRepository: UserRepository?

    private let cacheLock = NSLock()

    // MARK: - Initialization

    init(client: SupabaseClient = SupabaseService.shared.client, userRepository: UserRepository? = nil) {
        self.client = client
        self.userRepository = userRepository
    }

    // MARK: - LearningRepository

    func getSports() async throws -> [Sport] {
        #if DEBUG
        print("🔄 SupabaseLearningRepository.getSports() - Checking cache...")
        #endif

        if let cached = cachedSports() {
            #if DEBUG
            print("✅ Returning \(cached.count) sports from cache")
            #endif
            return cached
        }

        #if DEBUG
        print("🌐 Fetching sports from Supabase...")
        #endif

        let sports: [Sport] = try await executeWithRetry {
            let response = try await self.client
                .from("sports")
                .select()
                .eq("is_active", value: true)
                .order("order_index", ascending: true)
                .execute()

            #if DEBUG
            print("📦 Received response from Supabase")
            print("   Response data size: \(response.data.count) bytes")
            #endif

            let dtos: [SportDTO] = try self.decode(response.data, as: [SportDTO].self)

            #if DEBUG
            print("✅ Decoded \(dtos.count) SportDTOs")
            dtos.forEach { print("   - \($0.name) (active: \($0.is_active))") }
            #endif

            return try dtos.map { try $0.toDomain() }
        }

        #if DEBUG
        print("✅ Successfully fetched \(sports.count) sports from Supabase")
        #endif

        storeSports(sports)
        return sports
    }

    func getSport(id: UUID) async throws -> Sport? {
        if let cached = cachedSports()?.first(where: { $0.id == id }) {
            return cached
        }

        return try await executeWithRetry {
            let response = try await self.client
                .from("sports")
                .select()
                .eq("id", value: id.uuidString)
                .limit(1)
                .execute()

            let dtos: [SportDTO] = try self.decode(response.data, as: [SportDTO].self)
            if let dto = dtos.first {
                let sport = try dto.toDomain()
                self.appendSportToCache(sport)
                return sport
            }
            return nil
        }
    }

    func getModules(sportId: UUID) async throws -> [Module] {
        if let cached = cachedModules(for: sportId) {
            return cached
        }

        let modules: [Module] = try await executeWithRetry {
            let response = try await self.client
                .from("modules")
                .select()
                .eq("sport_id", value: sportId.uuidString)
                .order("order_index", ascending: true)
                .execute()

            let dtos: [ModuleDTO] = try self.decode(response.data, as: [ModuleDTO].self)
            let moduleUUIDs = try dtos.map { try ResponseParser.requireUUID($0.id) }
            let lessonSummary = try await self.fetchLessonSummaries(for: moduleUUIDs)

            return try dtos.compactMap { dto -> Module? in
                guard let moduleId = UUID(uuidString: dto.id),
                      let moduleSportId = UUID(uuidString: dto.sport_id) else {
                    return nil
                }

                let summary = lessonSummary[moduleId] ?? (totalLessons: 0, totalMinutes: 0, lockedLessons: 0)
                let isLocked = summary.totalLessons == 0 ? dto.order_index > 0 : summary.lockedLessons == summary.totalLessons

                let module = try dto.toDomain(
                    totalLessons: summary.totalLessons,
                    isLocked: isLocked
                )

                self.cacheLock.withLock {
                    self.moduleSportLookup[moduleId] = moduleSportId
                }

                return Module(
                    id: module.id,
                    sportId: module.sportId,
                    title: module.title,
                    description: module.description,
                    orderIndex: module.orderIndex,
                    estimatedMinutes: summary.totalMinutes,
                    totalLessons: summary.totalLessons,
                    isLocked: module.isLocked
                )
            }
        }

        storeModules(modules, for: sportId)
        return modules
    }

    func getLessons(moduleId: UUID) async throws -> [Lesson] {
        if let cached = cachedLessons(for: moduleId) {
            return cached
        }

        let lessonsByModule = try await fetchLessons(for: [moduleId])
        if let lessons = lessonsByModule[moduleId] {
            storeLessons(lessons, for: moduleId)
            return lessons
        }
        return []
    }

    func getLesson(id: UUID) async throws -> Lesson? {
        if let cached = cachedLesson(id: id) {
            return cached
        }

        guard let lesson = try await fetchLessonDetail(id: id) else {
            return nil
        }

        cacheLesson(lesson)
        return lesson
    }

    func submitAnswer(
        userId: UUID,
        itemId: UUID,
        answer: UserAnswer,
        context: SubmissionContext,
        timeSpentSeconds: Int
    ) async throws -> Submission {
        let variantId = try await resolveVariantId(for: itemId)
        let lessonId = try await resolveLessonId(for: itemId)
        let lesson = try await resolveLesson(for: lessonId)
        let item = try await resolveItem(itemId, in: lesson)
        let sportId = try await resolveSportId(forLesson: lessonId, moduleId: lesson.moduleId)

        let isCorrect = evaluate(answer: answer, against: item.correctAnswer)
        let xpAwarded = isCorrect ? item.xpValue : 0

        let submissionDTO = try await executeWithRetry {
            let payload = SubmissionInsertPayload(
                user_id: userId.uuidString,
                context: self.contextString(context),
                item_variant_id: variantId.uuidString,
                response_json: self.encodeAnswer(answer),
                latency_ms: max(timeSpentSeconds, 0) * 1000,
                device_platform: "ios"
            )

            let response = try await self.client
                .from("submissions")
                .insert([payload])
                .select()
                .limit(1)
                .execute()

            print("📦 Submission response data size: \(response.data.count) bytes")
            if let jsonString = String(data: response.data, encoding: .utf8) {
                print("📄 Raw submission response: \(jsonString)")
            }

            let dtos: [SubmissionDTO] = try self.decode(response.data, as: [SubmissionDTO].self)
            guard let dto = dtos.first else {
                throw NetworkError.noData
            }
            print("✅ Decoded SubmissionDTO - ID: \(dto.id), submitted_at: \(dto.submitted_at)")
            return dto
        }

        try await executeWithRetry {
            let judgmentPayload = SubmissionJudgmentInsertPayload(
                submission_id: submissionDTO.id,
                submission_submitted_at: submissionDTO.submitted_at,
                is_correct: isCorrect,
                judged_by: "rules",
                explanation: nil,
                confidence: isCorrect ? 0.95 : 0.3
            )

            _ = try await self.client
                .from("submission_judgments")
                .insert([judgmentPayload])
                .execute()
        }

        if xpAwarded > 0 {
            try await logXPEvent(
                userId: userId,
                sportId: sportId,
                amount: xpAwarded,
                source: "lesson"
            )
        }

        try await upsertUserProgress(
            userId: userId,
            sportId: sportId,
            moduleId: lesson.moduleId,
            lessonId: lessonId,
            xpDelta: xpAwarded,
            incrementLessons: false
        )

        print("🔍 Parsing submission - ID: \(submissionDTO.id), submitted_at: \(submissionDTO.submitted_at)")
        guard let submissionId = UUID(uuidString: submissionDTO.id) else {
            print("❌ Failed to parse submission ID: \(submissionDTO.id)")
            throw NetworkError.decodingError(NSError(domain: "Supabase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid submission ID: \(submissionDTO.id)"]))
        }
        
        // Supabase returns timestamps with microseconds: "2025-11-20T21:43:54.938366+00:00"
        // We need a formatter that handles fractional seconds
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let submittedAt = dateFormatter.date(from: submissionDTO.submitted_at) else {
            print("❌ Failed to parse submitted_at: \(submissionDTO.submitted_at)")
            throw NetworkError.decodingError(NSError(domain: "Supabase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid submission timestamp: \(submissionDTO.submitted_at)"]))
        }

        return Submission(
            id: submissionId,
            userId: userId,
            itemId: itemId,
            context: context,
            userAnswer: answer,
            isCorrect: isCorrect,
            timeSpentSeconds: timeSpentSeconds,
            xpAwarded: xpAwarded,
            submittedAt: submittedAt
        )
    }

    func completeLesson(userId: UUID, lessonId: UUID, score: Int) async throws {
        guard let lesson = try await getLesson(id: lessonId) else {
            throw NetworkError.notFound
        }

        let sportId = try await resolveSportId(forLesson: lessonId, moduleId: lesson.moduleId)

        if score > 0 {
            try await logXPEvent(
                userId: userId,
                sportId: sportId,
                amount: score,
                source: "lesson"
            )
        }

        // Record the completion in user_lesson_completions table
        let newCompletionCount = try await recordLessonCompletion(userId: userId, lessonId: lessonId)
        print("✅ Lesson completion recorded - new count: \(newCompletionCount)")

        try await upsertUserProgress(
            userId: userId,
            sportId: sportId,
            moduleId: lesson.moduleId,
            lessonId: lessonId,
            xpDelta: score,
            incrementLessons: true
        )

        // Only unlock the next lesson if user has completed this lesson enough times
        if newCompletionCount >= lesson.requiredCompletions {
            try await unlockNextLesson(moduleId: lesson.moduleId, currentOrderIndex: lesson.orderIndex)
        }
    }

    func getLessonCompletions(userId: UUID, sportId: UUID) async throws -> [UUID: Int] {
        print("🔄 Fetching lesson completions for user: \(userId), sport: \(sportId)")

        // Get all lesson IDs for this sport by joining through modules
        let lessonIdsResponse = try await client
            .from("lessons")
            .select("id, modules!inner(sport_id)")
            .eq("modules.sport_id", value: sportId.uuidString)
            .execute()

        struct LessonIdRow: Decodable {
            let id: String
        }
        let lessonRows: [LessonIdRow] = try decode(lessonIdsResponse.data, as: [LessonIdRow].self)
        let lessonIds = lessonRows.compactMap { UUID(uuidString: $0.id) }

        guard !lessonIds.isEmpty else {
            print("⚠️ No lessons found for sport \(sportId)")
            return [:]
        }

        // Fetch completions for these lessons
        let completionsResponse = try await client
            .from("user_lesson_completions")
            .select("lesson_id, completion_count")
            .eq("user_id", value: userId.uuidString)
            .in("lesson_id", values: lessonIds.map { $0.uuidString })
            .execute()

        struct CompletionRow: Decodable {
            let lesson_id: String
            let completion_count: Int
        }
        let completionRows: [CompletionRow] = try decode(completionsResponse.data, as: [CompletionRow].self)

        var completions: [UUID: Int] = [:]
        for row in completionRows {
            if let lessonId = UUID(uuidString: row.lesson_id) {
                completions[lessonId] = row.completion_count
            }
        }

        print("✅ Found \(completions.count) lesson completions")
        return completions
    }

    // MARK: - Test-Out Methods

    func getTestOut(moduleId: UUID) async throws -> TestOut? {
        let response = try await executeWithRetry {
            try await self.client
                .from("module_test_outs")
                .select()
                .eq("module_id", value: moduleId.uuidString)
                .eq("is_active", value: true)
                .limit(1)
                .execute()
        }

        let dtos: [TestOutDTO] = try decode(response.data, as: [TestOutDTO].self)
        guard let dto = dtos.first else { return nil }
        return try dto.toDomain()
    }

    func getTestOutEligibility(userId: UUID, moduleId: UUID) async throws -> TestOutEligibility {
        // 1. Check if user has already passed
        let passedResponse = try await client
            .from("user_test_out_attempts")
            .select()
            .eq("user_id", value: userId.uuidString)
            .eq("module_id", value: moduleId.uuidString)
            .eq("passed", value: true)
            .limit(1)
            .execute()

        let passedAttempts: [TestOutAttemptDTO] = try decode(passedResponse.data, as: [TestOutAttemptDTO].self)
        if !passedAttempts.isEmpty {
            return TestOutEligibility(
                canAttempt: false,
                attemptsRemaining: 0,
                cooldownEndsAt: nil,
                hasPassed: true
            )
        }

        // 2. Count attempts in last 24 hours
        let twentyFourHoursAgo = Date().addingTimeInterval(-24 * 60 * 60)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let cutoffString = formatter.string(from: twentyFourHoursAgo)

        let recentResponse = try await client
            .from("user_test_out_attempts")
            .select()
            .eq("user_id", value: userId.uuidString)
            .eq("module_id", value: moduleId.uuidString)
            .gte("attempted_at", value: cutoffString)
            .order("attempted_at", ascending: true)
            .execute()

        let recentAttempts: [TestOutAttemptDTO] = try decode(recentResponse.data, as: [TestOutAttemptDTO].self)

        if recentAttempts.count >= 2 {
            // User has used both attempts - calculate when cooldown ends
            // Cooldown ends 24h after the FIRST of the two attempts
            if let firstAttempt = recentAttempts.first,
               let firstAttemptDate = formatter.date(from: firstAttempt.attempted_at) {
                let cooldownEndsAt = firstAttemptDate.addingTimeInterval(24 * 60 * 60)
                return TestOutEligibility(
                    canAttempt: false,
                    attemptsRemaining: 0,
                    cooldownEndsAt: cooldownEndsAt,
                    hasPassed: false
                )
            }
        }

        return TestOutEligibility(
            canAttempt: true,
            attemptsRemaining: 2 - recentAttempts.count,
            cooldownEndsAt: nil,
            hasPassed: false
        )
    }

    func getTestOutItems(moduleId: UUID) async throws -> [Item] {
        // Fetch item IDs linked to this module's test-out
        let response = try await client
            .from("test_out_items")
            .select("item_id")
            .eq("module_id", value: moduleId.uuidString)
            .order("order_index", ascending: true)
            .execute()

        struct TestOutItemRow: Decodable {
            let item_id: String
        }
        let rows: [TestOutItemRow] = try decode(response.data, as: [TestOutItemRow].self)
        let itemIds = rows.compactMap { UUID(uuidString: $0.item_id) }

        guard !itemIds.isEmpty else { return [] }

        // Fetch the actual items
        let itemsResponse = try await client
            .from("items")
            .select()
            .in("id", values: itemIds.map { $0.uuidString })
            .execute()

        let itemDTOs: [ItemDTO] = try decode(itemsResponse.data, as: [ItemDTO].self)
        let variantMap = try await fetchActiveVariants(forItemIds: itemIds)

        // Convert to domain items, preserving the order from test_out_items
        var itemMap: [UUID: Item] = [:]
        for (index, dto) in itemDTOs.enumerated() {
            let variant = variantMap[dto.id]
            let item = try dto.toDomain(variant: variant, orderIndex: index)
            itemMap[item.id] = item
        }

        // Return items in the order specified by test_out_items
        return itemIds.compactMap { itemMap[$0] }
    }

    func submitTestOutAttempt(userId: UUID, moduleId: UUID, score: Int, totalQuestions: Int) async throws -> TestOutAttempt {
        // Get test-out config to determine passing threshold
        guard let testOut = try await getTestOut(moduleId: moduleId) else {
            throw NetworkError.notFound
        }

        let passed = score >= testOut.passingScore
        let nowString = ISO8601DateFormatter().string(from: Date())

        // Insert the attempt
        struct AttemptInsertPayload: Encodable {
            let user_id: String
            let module_id: String
            let score: Int
            let passed: Bool
            let attempted_at: String
        }

        let payload = AttemptInsertPayload(
            user_id: userId.uuidString,
            module_id: moduleId.uuidString,
            score: score,
            passed: passed,
            attempted_at: nowString
        )

        let response = try await executeWithRetry {
            try await self.client
                .from("user_test_out_attempts")
                .insert([payload])
                .select()
                .limit(1)
                .execute()
        }

        let attemptDTOs: [TestOutAttemptDTO] = try decode(response.data, as: [TestOutAttemptDTO].self)
        guard let attemptDTO = attemptDTOs.first else {
            throw NetworkError.noData
        }

        let attempt = try attemptDTO.toDomain()

        // If passed, unlock all lessons in the NEXT module
        if passed {
            try await unlockNextModuleViaTestOut(currentModuleId: moduleId)

            // Also award XP for passing the test-out
            let sportId = try await resolveSportId(forModule: moduleId)
            let xpAward = score * 10 // 10 XP per correct answer
            try await logXPEvent(userId: userId, sportId: sportId, amount: xpAward, source: "lesson")
        }

        return attempt
    }

    /// Unlocks all lessons in the next module after a successful test-out
    private func unlockNextModuleViaTestOut(currentModuleId: UUID) async throws {
        // Get the current module's order index
        let currentModuleResponse = try await client
            .from("modules")
            .select("order_index, sport_id")
            .eq("id", value: currentModuleId.uuidString)
            .limit(1)
            .execute()

        struct ModuleOrderRow: Decodable {
            let order_index: Int
            let sport_id: String
        }
        let moduleRows: [ModuleOrderRow] = try decode(currentModuleResponse.data, as: [ModuleOrderRow].self)
        guard let currentModule = moduleRows.first else {
            throw NetworkError.notFound
        }

        // Find the next module
        let nextModuleResponse = try await client
            .from("modules")
            .select("id")
            .eq("sport_id", value: currentModule.sport_id)
            .eq("order_index", value: currentModule.order_index + 1)
            .limit(1)
            .execute()

        struct NextModuleRow: Decodable {
            let id: String
        }
        let nextModuleRows: [NextModuleRow] = try decode(nextModuleResponse.data, as: [NextModuleRow].self)
        guard let nextModule = nextModuleRows.first else {
            print("⚠️ No next module found to unlock (already at last module)")
            return
        }

        // Unlock ALL lessons in the next module
        _ = try await executeWithRetry {
            try await self.client
                .from("lessons")
                .update(["is_locked": false])
                .eq("module_id", value: nextModule.id)
                .execute()
        }

        print("✅ Unlocked all lessons in next module: \(nextModule.id)")

        // Clear caches so UI reflects the unlocked state
        if let nextModuleUUID = UUID(uuidString: nextModule.id) {
            cacheLock.withLock {
                lessonsByModule.removeValue(forKey: nextModuleUUID)
                modulesCache.removeAll() // Clear module cache to show updated lock state
            }
        }
    }

    // MARK: - Lesson Completion Types

    private struct LessonCompletionUpdatePayload: Encodable {
        let completion_count: Int
        let last_completed_at: String
        let updated_at: String
    }

    private struct LessonCompletionInsertPayload: Encodable {
        let user_id: String
        let lesson_id: String
        let completion_count: Int
        let last_completed_at: String
    }

    /// Records a lesson completion and returns the new completion count
    private func recordLessonCompletion(userId: UUID, lessonId: UUID) async throws -> Int {
        print("🔄 Recording lesson completion for user: \(userId), lesson: \(lessonId)")

        // Use direct upsert approach (more reliable across Supabase versions)
        return try await recordLessonCompletionDirect(userId: userId, lessonId: lessonId)
    }

    /// Direct upsert for recording lesson completion
    private func recordLessonCompletionDirect(userId: UUID, lessonId: UUID) async throws -> Int {
        // First, try to get existing record
        let existingResponse = try await client
            .from("user_lesson_completions")
            .select("id, completion_count")
            .eq("user_id", value: userId.uuidString)
            .eq("lesson_id", value: lessonId.uuidString)
            .limit(1)
            .execute()

        struct ExistingRow: Decodable {
            let id: String
            let completion_count: Int
        }
        let existingRows: [ExistingRow] = try decode(existingResponse.data, as: [ExistingRow].self)

        let nowString = ISO8601DateFormatter().string(from: Date())

        if let existing = existingRows.first {
            // Update existing record
            let newCount = existing.completion_count + 1
            let updatePayload = LessonCompletionUpdatePayload(
                completion_count: newCount,
                last_completed_at: nowString,
                updated_at: nowString
            )
            _ = try await client
                .from("user_lesson_completions")
                .update(updatePayload)
                .eq("id", value: existing.id)
                .execute()
            print("✅ Updated completion count to \(newCount)")
            return newCount
        } else {
            // Insert new record
            let insertPayload = LessonCompletionInsertPayload(
                user_id: userId.uuidString,
                lesson_id: lessonId.uuidString,
                completion_count: 1,
                last_completed_at: nowString
            )

            _ = try await client
                .from("user_lesson_completions")
                .insert([insertPayload])
                .execute()
            print("✅ Created new completion record with count 1")
            return 1
        }
    }

    private func unlockNextLesson(moduleId: UUID, currentOrderIndex: Int) async throws {
        // Find the next lesson in order
        let nextOrderIndex = currentOrderIndex + 1
        
        // Update the next lesson to be unlocked
        _ = try await executeWithRetry {
            try await self.client
                .from("lessons")
                .update(["is_locked": false])
                .eq("module_id", value: moduleId.uuidString)
                .eq("order_index", value: nextOrderIndex)
                .execute()
        }
        
        print("✅ Unlocked next lesson (order: \(nextOrderIndex)) in module \(moduleId)")
        
        // Clear the lessons cache for this module so it reloads with updated lock status
        cacheLock.withLock {
            lessonsByModule.removeValue(forKey: moduleId)
        }
    }

    // MARK: - Sports Cache Helpers

    private func cachedSports() -> [Sport]? {
        cacheLock.lock(); defer { cacheLock.unlock() }
        guard let cache = sportsCache else { return nil }
        if cache.isExpired {
            sportsCache = nil
            return nil
        }
        return cache.value
    }

    private func storeSports(_ sports: [Sport]) {
        cacheLock.lock(); defer { cacheLock.unlock() }
        sportsCache = CacheEntry(value: sports, expiration: Date().addingTimeInterval(cacheTTL))
    }

    private func appendSportToCache(_ sport: Sport) {
        cacheLock.lock(); defer { cacheLock.unlock() }
        if let cache = sportsCache, !cache.isExpired {
            var sports = cache.value.filter { $0.id != sport.id }
            sports.append(sport)
            sportsCache = CacheEntry(value: sports, expiration: Date().addingTimeInterval(cacheTTL))
        } else {
            sportsCache = CacheEntry(value: [sport], expiration: Date().addingTimeInterval(cacheTTL))
        }
    }

    private func cachedModules(for sportId: UUID) -> [Module]? {
        cacheLock.lock(); defer { cacheLock.unlock() }
        guard let cache = modulesCache[sportId] else { return nil }
        if cache.isExpired {
            modulesCache.removeValue(forKey: sportId)
            return nil
        }
        return cache.value
    }

    private func storeModules(_ modules: [Module], for sportId: UUID) {
        cacheLock.lock(); defer { cacheLock.unlock() }
        modulesCache[sportId] = CacheEntry(value: modules, expiration: Date().addingTimeInterval(cacheTTL))
    }

    private func cachedLessons(for moduleId: UUID) -> [Lesson]? {
        cacheLock.lock(); defer { cacheLock.unlock() }
        return lessonsByModule[moduleId]
    }

    private func storeLessons(_ lessons: [Lesson], for moduleId: UUID) {
        cacheLock.lock(); defer { cacheLock.unlock() }
        lessonsByModule[moduleId] = lessons
        lessons.forEach { lesson in
            lessonDetails[lesson.id] = lesson
            lessonSportLookup[lesson.id] = moduleSportLookup[lesson.moduleId]
            lesson.items.forEach { item in
                itemLessonLookup[item.id] = lesson.id
            }
        }
    }

    private func cachedLesson(id: UUID) -> Lesson? {
        cacheLock.lock(); defer { cacheLock.unlock() }
        return lessonDetails[id]
    }

    private func cacheLesson(_ lesson: Lesson) {
        cacheLock.lock(); defer { cacheLock.unlock() }
        lessonDetails[lesson.id] = lesson
        lessonSportLookup[lesson.id] = moduleSportLookup[lesson.moduleId]
        lessonsByModule[lesson.moduleId] = lessonDetails.values.filter { $0.moduleId == lesson.moduleId }
        lesson.items.forEach { item in
            itemLessonLookup[item.id] = lesson.id
        }
    }

    // MARK: - Fetch Helpers

    private func fetchLessonSummaries(for moduleIds: [UUID]) async throws -> [UUID: (totalLessons: Int, totalMinutes: Int, lockedLessons: Int)] {
        guard !moduleIds.isEmpty else { return [:] }

        let response = try await self.client
            .from("lessons")
            .select("module_id, est_minutes, is_locked")
            .in("module_id", values: moduleIds.map { $0.uuidString })
            .execute()

        let rows: [LessonSummaryRow] = try self.decode(response.data, as: [LessonSummaryRow].self)
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

    private func fetchLessons(for moduleIds: [UUID]) async throws -> [UUID: [Lesson]] {
        guard !moduleIds.isEmpty else { return [:] }

        let response = try await self.client
            .from("lessons")
            .select()
            .in("module_id", values: moduleIds.map { $0.uuidString })
            .order("order_index", ascending: true)
            .execute()

        let dtos: [LessonDTO] = try self.decode(response.data, as: [LessonDTO].self)
        let lessonIds = dtos.compactMap { UUID(uuidString: $0.id) }
        let itemsByLesson = try await fetchItems(forLessonIds: lessonIds)

        var grouped: [UUID: [Lesson]] = [:]
        for dto in dtos {
            guard let lessonId = UUID(uuidString: dto.id) else { continue }
            let items = itemsByLesson[lessonId] ?? []
            let lesson = try dto.toDomain(items: items)
            grouped[lesson.moduleId, default: []].append(lesson)
            cacheLock.withLock {
                lessonDetails[lesson.id] = lesson
                lessonSportLookup[lesson.id] = moduleSportLookup[lesson.moduleId]
            }
        }

        grouped.keys.forEach { moduleId in
            grouped[moduleId]?.sort { $0.orderIndex < $1.orderIndex }
        }

        cacheLock.withLock {
            grouped.forEach { lessonsByModule[$0.key] = $0.value }
        }

        return grouped
    }

    private func fetchLessonDetail(id: UUID) async throws -> Lesson? {
        let response = try await self.client
            .from("lessons")
            .select()
            .eq("id", value: id.uuidString)
            .limit(1)
            .execute()

        let dtos: [LessonDTO] = try self.decode(response.data, as: [LessonDTO].self)
        guard let dto = dtos.first else { return nil }
        let itemsMap = try await fetchItems(forLessonIds: [id])
        let lesson = try dto.toDomain(items: itemsMap[id] ?? [])
        return lesson
    }

    private func fetchItems(forLessonIds lessonIds: [UUID]) async throws -> [UUID: [Item]] {
        guard !lessonIds.isEmpty else { return [:] }

        let response = try await self.client
            .from("items")
            .select()
            .in("lesson_id", values: lessonIds.map { $0.uuidString })
            .order("created_at", ascending: true)
            .execute()

        let dtos: [ItemDTO] = try self.decode(response.data, as: [ItemDTO].self)
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

            cacheLock.withLock {
                itemLessonLookup[item.id] = lessonId
                if let variantId = variant.flatMap({ UUID(uuidString: $0.id) }) {
                    itemVariantLookup[item.id] = variantId
                }
            }
        }

        return grouped
    }

    private func fetchActiveVariants(forItemIds itemIds: [UUID]) async throws -> [String: ItemVariantDTO] {
        guard !itemIds.isEmpty else { return [:] }

        let response = try await self.client
            .from("item_variants")
            .select()
            .in("item_id", values: itemIds.map { $0.uuidString })
            .eq("active", value: true)
            .order("version", ascending: false)
            .execute()

        let variants: [ItemVariantDTO] = try self.decode(response.data, as: [ItemVariantDTO].self)
        var map: [String: ItemVariantDTO] = [:]
        for variant in variants {
            if map[variant.item_id] == nil {
                map[variant.item_id] = variant
            }
        }
        return map
    }

    // MARK: - Resolution Helpers

    private func resolveVariantId(for itemId: UUID) async throws -> UUID {
        if let cached = cacheLock.withLock({ itemVariantLookup[itemId] }) {
            return cached
        }

        let response = try await self.client
            .from("item_variants")
            .select("id")
            .eq("item_id", value: itemId.uuidString)
            .eq("active", value: true)
            .order("version", ascending: false)
            .limit(1)
            .execute()

        let rows: [VariantIdRow] = try self.decode(response.data, as: [VariantIdRow].self)
        guard let row = rows.first, let variantId = UUID(uuidString: row.id) else {
            throw NetworkError.notFound
        }

        cacheLock.withLock {
            itemVariantLookup[itemId] = variantId
        }

        return variantId
    }

    private func resolveLessonId(for itemId: UUID) async throws -> UUID {
        if let cached = cacheLock.withLock({ itemLessonLookup[itemId] }) {
            return cached
        }

        let response = try await self.client
            .from("items")
            .select("id, lesson_id")
            .eq("id", value: itemId.uuidString)
            .limit(1)
            .execute()

        let rows: [ItemLessonRow] = try self.decode(response.data, as: [ItemLessonRow].self)
        guard let row = rows.first,
              let lessonIdString = row.lesson_id,
              let lessonId = UUID(uuidString: lessonIdString) else {
            throw NetworkError.notFound
        }

        cacheLock.withLock {
            itemLessonLookup[itemId] = lessonId
        }

        return lessonId
    }

    private func resolveLesson(for lessonId: UUID) async throws -> Lesson {
        if let cached = cachedLesson(id: lessonId) {
            return cached
        }
        guard let lesson = try await fetchLessonDetail(id: lessonId) else {
            throw NetworkError.notFound
        }
        cacheLesson(lesson)
        return lesson
    }

    private func resolveItem(_ itemId: UUID, in lesson: Lesson) throws -> Item {
        if let item = lesson.items.first(where: { $0.id == itemId }) {
            return item
        }
        throw NetworkError.notFound
    }

    private func resolveSportId(forLesson lessonId: UUID, moduleId: UUID) async throws -> UUID {
        if let cached = cacheLock.withLock({ lessonSportLookup[lessonId] }) {
            return cached
        }

        let moduleSportId = try await resolveSportId(forModule: moduleId)
        cacheLock.withLock {
            lessonSportLookup[lessonId] = moduleSportId
        }
        return moduleSportId
    }

    private func resolveSportId(forModule moduleId: UUID) async throws -> UUID {
        if let cached = cacheLock.withLock({ moduleSportLookup[moduleId] }) {
            return cached
        }

        let response = try await self.client
            .from("modules")
            .select("id, sport_id")
            .eq("id", value: moduleId.uuidString)
            .limit(1)
            .execute()

        let rows: [ModuleSportRow] = try decode(response.data, as: [ModuleSportRow].self)
        guard let row = rows.first,
              let sportId = UUID(uuidString: row.sport_id) else {
            throw NetworkError.notFound
        }

        cacheLock.withLock {
            moduleSportLookup[moduleId] = sportId
        }

        return sportId
    }

    // MARK: - Persistence Helpers

    private func logXPEvent(userId: UUID, sportId: UUID, amount: Int, source: String) async throws {
        guard amount > 0 else { 
            print("⚠️ Skipping XP event - amount is 0")
            return 
        }

        print("💰 Logging XP event - userId: \(userId), sportId: \(sportId), amount: \(amount), source: \(source)")
        
        try await executeWithRetry {
            let payload = XPEventInsertPayload(
                user_id: userId.uuidString,
                sport_id: sportId.uuidString,
                source: source,
                amount: amount,
                meta_json: nil
            )

            _ = try await self.client
                .from("user_xp_events")
                .insert([payload])
                .execute()
            
            print("✅ XP event logged successfully")
        }
    }

    private func upsertUserProgress(
        userId: UUID,
        sportId: UUID,
        moduleId: UUID,
        lessonId: UUID,
        xpDelta: Int,
        incrementLessons: Bool
    ) async throws {
        print("🔄 Upserting user progress - userId: \(userId), sportId: \(sportId), xpDelta: \(xpDelta), incrementLessons: \(incrementLessons)")
        
        let progressDTO = try await fetchUserProgressDTO(userId: userId, sportId: sportId)
        let nowString = ISO8601DateFormatter().string(from: Date())

        if let progressDTO {
            print("📊 Found existing progress - current XP: \(progressDTO.total_xp), lessons: \(progressDTO.lessons_completed)")
            let updatedXP = progressDTO.total_xp + xpDelta
            let updatedLessons = progressDTO.lessons_completed + (incrementLessons ? 1 : 0)
            print("📈 Updating to - new XP: \(updatedXP), new lessons: \(updatedLessons)")
            
            let payload = UserProgressUpdatePayload(
                total_xp: updatedXP,
                lessons_completed: updatedLessons,
                current_module_id: moduleId.uuidString,
                current_lesson_id: lessonId.uuidString,
                last_active_at: nowString
            )

            _ = try await self.client
                .from("user_progress")
                .update(payload)
                .eq("id", value: progressDTO.id)
                .execute()
            
            print("✅ User progress updated successfully")
        } else {
            print("📝 No existing progress found, creating new record")
            let payload = UserProgressInsertPayload(
                user_id: userId.uuidString,
                sport_id: sportId.uuidString,
                level: 1,
                overall_rating: 0,
                current_module_id: moduleId.uuidString,
                current_lesson_id: lessonId.uuidString,
                total_xp: max(xpDelta, 0),
                lessons_completed: incrementLessons ? 1 : 0,
                live_answers: 0,
                concepts_mastered: 0,
                last_active_at: nowString
            )

            _ = try await self.client
                .from("user_progress")
                .insert([payload])
                .execute()
            
            print("✅ User progress created successfully with XP: \(max(xpDelta, 0))")
        }
        
        // Invalidate cache so UI shows updated progress
        if let userRepo = userRepository as? SupabaseUserRepository {
            userRepo.invalidateProgressCache(userId: userId, sportId: sportId)
        }
    }

    private func fetchUserProgressDTO(userId: UUID, sportId: UUID) async throws -> UserProgressDTO? {
        let response = try await self.client
            .from("user_progress")
            .select()
            .eq("user_id", value: userId.uuidString)
            .eq("sport_id", value: sportId.uuidString)
            .limit(1)
            .execute()

        let dtos: [UserProgressDTO] = try self.decode(response.data, as: [UserProgressDTO].self)
        return dtos.first
    }

    // MARK: - Utility Helpers

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

    private func encodeAnswer(_ answer: UserAnswer) -> [String: AnyCodable] {
        switch answer {
        case .single(let value):
            return ["index": AnyCodable(value)]
        case .multiple(let values):
            return ["indices": AnyCodable(values)]
        case .slider(let value):
            return ["value": AnyCodable(value)]
        case .text(let value):
            return ["value": AnyCodable(value)]
        case .boolean(let value):
            return ["value": AnyCodable(value)]
        }
    }

    private func contextString(_ context: SubmissionContext) -> String {
        switch context {
        case .lesson: return "lesson"
        case .review: return "review"
        case .liveGame: return "live"
        }
    }

    // MARK: - Networking Helpers

    private func executeWithRetry<T>(_ operation: @escaping () async throws -> T) async throws -> T {
        var attempt = 0
        var delay = initialRetryDelay
        var lastError: NetworkError?

        while attempt <= maxRetries {
            do {
                return try await operation()
            } catch {
                let networkError = mapError(error)
                lastError = networkError

                guard networkError.isRetryable, attempt < maxRetries else {
                    throw networkError
                }

                let nanoseconds = UInt64(delay * Double(NSEC_PER_SEC))
                try await Task.sleep(nanoseconds: nanoseconds)
                attempt += 1
                delay *= 2
            }
        }

        throw lastError ?? .unknown(NSError(domain: "Supabase", code: -1))
    }

    private func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .connectionFailed(urlError)
            case .timedOut:
                return .timeout
            default:
                return .connectionFailed(urlError)
            }
        }

        #if canImport(PostgrestKit)
        if error is PostgrestError {
            return .databaseError(error)
        }
        #endif

        return .unknown(error)
    }

    private func decode<T: Decodable>(_ data: Data?, as type: T.Type) throws -> T {
        guard let data = data else {
            throw NetworkError.noData
        }
        return try ResponseParser.decode(type, from: data)
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
