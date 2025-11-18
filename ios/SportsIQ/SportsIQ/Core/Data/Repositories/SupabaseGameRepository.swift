//
//  SupabaseGameRepository.swift
//  SportsIQ
//
//  Created for Database Setup Task 7
//

import Foundation
import Supabase
#if canImport(PostgrestKit)
import PostgrestKit
#endif
#if canImport(Realtime)
import Realtime
#endif

/// Concrete implementation of `GameRepository` backed by Supabase/Postgrest
///
/// This repository is responsible for loading game data, managing live game subscriptions
/// via Supabase Realtime, and handling live prompt submissions.
final class SupabaseGameRepository: GameRepository {
    // MARK: - Nested Types

    private struct CacheEntry<Value> {
        let value: Value
        let expiration: Date

        var isExpired: Bool { Date() > expiration }
    }

    private struct LiveSubmissionInsertPayload: Encodable {
        let user_id: String
        let context: String
        let live_prompt_id: String
        let response_json: [String: AnyCodable]
        let latency_ms: Int
        let device_platform: String
    }

    private struct LiveSubmissionJudgmentInsertPayload: Encodable {
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

    // MARK: - Properties

    private let client: SupabaseClient
    private let cacheTTL: TimeInterval = 60 * 5 // 5 minutes
    private let maxRetries = 2
    private let initialRetryDelay: TimeInterval = 0.5

    private var gamesCache: [String: CacheEntry<[Game]>] = [:] // Key: "date-sportId"
    private var teamsCache: [UUID: Team] = [:]

    private let cacheLock = NSLock()

    // MARK: - Initialization

    init(client: SupabaseClient = SupabaseService.shared.client) {
        self.client = client
    }

    // MARK: - GameRepository

    func getGames(date: Date, sportId: UUID) async throws -> [Game] {
        #if DEBUG
        print("🔄 SupabaseGameRepository.getGames(date: \(date), sportId: \(sportId))")
        #endif

        let cacheKey = gameCacheKey(date: date, sportId: sportId)

        if let cached = cachedGames(for: cacheKey) {
            #if DEBUG
            print("✅ Returning \(cached.count) games from cache")
            #endif
            return cached
        }

        #if DEBUG
        print("🌐 Fetching games from Supabase...")
        #endif

        let games: [Game] = try await executeWithRetry {
            // Get date range (whole day)
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

            // Query games for the date
            let response = try await self.client
                .from("games")
                .select()
                .gte("start_time", value: ISO8601DateFormatter().string(from: startOfDay))
                .lt("start_time", value: ISO8601DateFormatter().string(from: endOfDay))
                .order("start_time", ascending: true)
                .execute()

            let gameDTOs: [GameDTO] = try self.decode(response.data, as: [GameDTO].self)

            #if DEBUG
            print("✅ Decoded \(gameDTOs.count) GameDTOs")
            #endif

            // Extract unique team IDs
            var teamIds = Set<String>()
            for gameDTO in gameDTOs {
                teamIds.insert(gameDTO.home_team_id)
                teamIds.insert(gameDTO.away_team_id)
            }

            // Fetch teams
            let teams = try await self.fetchTeams(ids: Array(teamIds))

            // Convert to domain entities
            var convertedGames: [Game] = []
            for gameDTO in gameDTOs {
                guard let homeTeam = teams[gameDTO.home_team_id],
                      let awayTeam = teams[gameDTO.away_team_id] else {
                    #if DEBUG
                    print("⚠️ Skipping game \(gameDTO.id) - missing team data")
                    #endif
                    continue
                }

                let game = try gameDTO.toDomain(
                    homeTeam: homeTeam,
                    awayTeam: awayTeam,
                    sportId: sportId
                )
                convertedGames.append(game)
            }

            return convertedGames
        }

        #if DEBUG
        print("✅ Successfully fetched \(games.count) games from Supabase")
        #endif

        storeGames(games, for: cacheKey)
        return games
    }

    func getGame(id: UUID) async throws -> Game? {
        #if DEBUG
        print("🔄 SupabaseGameRepository.getGame(id: \(id))")
        #endif

        return try await executeWithRetry {
            let response = try await self.client
                .from("games")
                .select()
                .eq("id", value: id.uuidString)
                .limit(1)
                .execute()

            let gameDTOs: [GameDTO] = try self.decode(response.data, as: [GameDTO].self)
            guard let gameDTO = gameDTOs.first else {
                return nil
            }

            // Fetch teams
            let teams = try await self.fetchTeams(ids: [gameDTO.home_team_id, gameDTO.away_team_id])

            guard let homeTeam = teams[gameDTO.home_team_id],
                  let awayTeam = teams[gameDTO.away_team_id] else {
                throw NetworkError.notFound
            }

            // Get sport ID from league
            let sportId = try await self.fetchSportId(forLeagueId: gameDTO.league_id)

            let game = try gameDTO.toDomain(
                homeTeam: homeTeam,
                awayTeam: awayTeam,
                sportId: sportId
            )

            return game
        }
    }

    func connectToLiveGame(gameId: UUID) -> AsyncThrowingStream<LivePrompt, Error> {
        #if DEBUG
        print("🔄 SupabaseGameRepository.connectToLiveGame(gameId: \(gameId))")
        #endif

        // TODO: Implement Supabase Realtime integration
        // The current Supabase Swift SDK's RealtimeChannel is deprecated
        // and the new RealtimeChannelV2 is not yet available via client.realtime.channel()
        //
        // For production implementation:
        // 1. Wait for Supabase Swift SDK to update to RealtimeChannelV2
        // 2. Use Postgres Change listeners to watch live_prompt_windows table
        // 3. Set up database triggers to broadcast events on inserts
        //
        // For MVP/Testing:
        // - Use polling mechanism to check for new live prompts
        // - Or implement a mock live prompt generator for testing

        return AsyncThrowingStream { continuation in
            #if DEBUG
            print("⚠️ Live game connection not yet implemented - Realtime API migration pending")
            print("   This requires Supabase Swift SDK update to RealtimeChannelV2")
            #endif

            // Note: In a real implementation, you would:
            // 1. Subscribe to realtime channel
            // 2. Listen for live_prompt_window inserts
            // 3. Fetch prompt details and yield to stream
            // 4. Handle errors and reconnection
        }
    }

    func submitLiveAnswer(
        userId: UUID,
        gameId: UUID,
        itemId: UUID,
        answer: UserAnswer
    ) async throws -> Submission {
        #if DEBUG
        print("🔄 SupabaseGameRepository.submitLiveAnswer(userId: \(userId), gameId: \(gameId), itemId: \(itemId))")
        #endif

        // For live answers, itemId is actually the live_prompt_id
        let livePromptId = itemId

        // Fetch the live prompt to check correctness
        let livePrompt = try await fetchLivePrompt(promptId: livePromptId.uuidString, gameId: gameId)

        // Check if answer is correct
        let isCorrect = evaluateLiveAnswer(answer: answer, correctAnswer: livePrompt.correctAnswer)
        let xpAwarded = isCorrect ? livePrompt.xpValue : 0

        // Insert submission
        let submissionDTO = try await executeWithRetry {
            let payload = LiveSubmissionInsertPayload(
                user_id: userId.uuidString,
                context: "live",
                live_prompt_id: livePromptId.uuidString,
                response_json: self.encodeAnswer(answer),
                latency_ms: 0, // Could track this if needed
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

        // Insert judgment
        try await executeWithRetry {
            let judgmentPayload = LiveSubmissionJudgmentInsertPayload(
                submission_id: submissionDTO.id,
                is_correct: isCorrect,
                judged_by: "rules",
                explanation: isCorrect ? livePrompt.explanation : nil,
                confidence: isCorrect ? 0.95 : 0.3
            )

            _ = try await self.client
                .from("submission_judgments")
                .insert([judgmentPayload])
                .execute()
        }

        // Award XP if correct
        if xpAwarded > 0 {
            try await logXPEvent(
                userId: userId,
                sportId: livePrompt.gameId, // Using gameId as sportId for now
                amount: xpAwarded,
                source: "live"
            )
        }

        // Create and return submission
        guard let submissionId = UUID(uuidString: submissionDTO.id),
              let submittedAt = ISO8601DateFormatter().date(from: submissionDTO.submitted_at) else {
            throw NetworkError.decodingError(NSError(domain: "Supabase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid submission response"]))
        }

        return Submission(
            id: submissionId,
            userId: userId,
            itemId: livePromptId,
            context: .liveGame,
            userAnswer: answer,
            isCorrect: isCorrect,
            timeSpentSeconds: 0,
            xpAwarded: xpAwarded,
            submittedAt: submittedAt
        )
    }

    // MARK: - Cache Helpers

    private func gameCacheKey(date: Date, sportId: UUID) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return "\(dateFormatter.string(from: date))-\(sportId.uuidString)"
    }

    private func cachedGames(for key: String) -> [Game]? {
        cacheLock.lock(); defer { cacheLock.unlock() }
        guard let cache = gamesCache[key] else { return nil }
        if cache.isExpired {
            gamesCache.removeValue(forKey: key)
            return nil
        }
        return cache.value
    }

    private func storeGames(_ games: [Game], for key: String) {
        cacheLock.lock(); defer { cacheLock.unlock() }
        gamesCache[key] = CacheEntry(value: games, expiration: Date().addingTimeInterval(cacheTTL))
    }

    // MARK: - Fetch Helpers

    private func fetchTeams(ids: [String]) async throws -> [String: Team] {
        guard !ids.isEmpty else { return [:] }

        // Check cache first
        let (cachedResult, idsToFetch): ([String: Team], [String]) = cacheLock.withLock {
            var cached: [String: Team] = [:]
            var toFetch: [String] = []
            for id in ids {
                if let uuid = UUID(uuidString: id), let cachedTeam = teamsCache[uuid] {
                    cached[id] = cachedTeam
                } else {
                    toFetch.append(id)
                }
            }
            return (cached, toFetch)
        }

        var result = cachedResult

        // Fetch missing teams
        if !idsToFetch.isEmpty {
            let response = try await self.client
                .from("teams")
                .select()
                .in("id", values: idsToFetch)
                .execute()

            let teamDTOs: [TeamDTO] = try self.decode(response.data, as: [TeamDTO].self)

            for teamDTO in teamDTOs {
                let team = try teamDTO.toDomain()
                result[teamDTO.id] = team

                // Cache it
                if let uuid = UUID(uuidString: teamDTO.id) {
                    cacheLock.withLock {
                        teamsCache[uuid] = team
                    }
                }
            }
        }

        return result
    }

    private func fetchSportId(forLeagueId leagueId: String) async throws -> UUID {
        let response = try await self.client
            .from("leagues")
            .select("sport_id")
            .eq("id", value: leagueId)
            .limit(1)
            .execute()

        struct LeagueSportRow: Decodable {
            let sport_id: String
        }

        let rows: [LeagueSportRow] = try self.decode(response.data, as: [LeagueSportRow].self)
        guard let row = rows.first,
              let sportId = UUID(uuidString: row.sport_id) else {
            throw NetworkError.notFound
        }

        return sportId
    }

    private func fetchLivePrompt(promptId: String, gameId: UUID) async throws -> LivePrompt {
        // Fetch the live_prompts template
        let response = try await self.client
            .from("live_prompts")
            .select()
            .eq("id", value: promptId)
            .limit(1)
            .execute()

        let promptDTOs: [LivePromptDTO] = try self.decode(response.data, as: [LivePromptDTO].self)
        guard let promptDTO = promptDTOs.first else {
            throw NetworkError.notFound
        }

        // Convert to domain entity
        // Note: The LivePromptDTO doesn't have a toDomain() method yet, so we'll create one inline
        guard let promptUuid = UUID(uuidString: promptDTO.id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: promptDTO.id)
        }

        // Parse answer schema to extract options and correct answer
        let answerSchema = promptDTO.answer_schema_json
        let options = (answerSchema["options"]?.value as? [String]) ?? []
        let correctAnswerIndex = (answerSchema["correct"]?.value as? Int) ?? 0

        // Parse grading rule for explanation
        let gradingRule = promptDTO.grading_rule_json
        let explanation = (gradingRule["explanation"]?.value as? String) ?? "Correct!"

        // Determine difficulty based on level range
        let difficulty: LivePrompt.PromptDifficulty
        if promptDTO.level_max <= 20 {
            difficulty = .beginner
        } else if promptDTO.level_max <= 50 {
            difficulty = .intermediate
        } else {
            difficulty = .advanced
        }

        return LivePrompt(
            id: promptUuid,
            gameId: gameId,
            prompt: promptDTO.template_prompt,
            options: options,
            correctAnswer: correctAnswerIndex,
            explanation: explanation,
            timestamp: Date(), // Current time when prompt is shown
            gameContext: "Live game situation", // Could be enhanced with play data
            difficulty: difficulty,
            xpValue: difficulty.baseXP
        )
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

    // MARK: - Utility Helpers

    private func evaluateLiveAnswer(answer: UserAnswer, correctAnswer: Int) -> Bool {
        switch answer {
        case .single(let index):
            return index == correctAnswer
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
