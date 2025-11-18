//
//  SupabaseLearningRepository.swift
//  SportsIQ
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

    private let cacheLock = NSLock()

    // MARK: - Initialization

    init(client: SupabaseClient = SupabaseService.shared.client) {
        self.client = client
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

            let dtos: [SubmissionDTO] = try self.decode(response.data, as: [SubmissionDTO].self)
            guard let dto = dtos.first else {
                throw NetworkError.noData
            }
            return dto
        }

        try await executeWithRetry {
            let judgmentPayload = SubmissionJudgmentInsertPayload(
                submission_id: submissionDTO.id,
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

        guard let submissionId = UUID(uuidString: submissionDTO.id),
              let submittedAt = ISO8601DateFormatter().date(from: submissionDTO.submitted_at) else {
            throw NetworkError.decodingError(NSError(domain: "Supabase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid submission response"]))
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

        try await upsertUserProgress(
            userId: userId,
            sportId: sportId,
            moduleId: lesson.moduleId,
            lessonId: lessonId,
            xpDelta: score,
            incrementLessons: true
        )
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
        guard amount > 0 else { return }

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
        let progressDTO = try await fetchUserProgressDTO(userId: userId, sportId: sportId)
        let nowString = ISO8601DateFormatter().string(from: Date())

        if let progressDTO {
            let updatedXP = progressDTO.total_xp + xpDelta
            let updatedLessons = progressDTO.lessons_completed + (incrementLessons ? 1 : 0)
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
        } else {
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
