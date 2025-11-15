//
//  LeaderboardViewModel.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

@Observable
class LeaderboardViewModel {
    private let userId: UUID

    var selectedPeriod: LeaderboardPeriod = .weekly
    var isLoading = false
    var entries: [LeaderboardEntry] = []

    init(userId: UUID) {
        self.userId = userId
    }

    @MainActor
    func loadLeaderboard() async {
        isLoading = true

        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Mock data
        entries = [
            LeaderboardEntry(id: UUID(), userId: UUID(), username: "FootballFan99", xp: 2500, overallRating: 85),
            LeaderboardEntry(id: UUID(), userId: UUID(), username: "GridironGuru", xp: 2350, overallRating: 82),
            LeaderboardEntry(id: UUID(), userId: UUID(), username: "TouchdownPro", xp: 2100, overallRating: 78),
            LeaderboardEntry(id: UUID(), userId: userId, username: "You", xp: 1850, overallRating: 72),
            LeaderboardEntry(id: UUID(), userId: UUID(), username: "NFLExpert", xp: 1700, overallRating: 70),
            LeaderboardEntry(id: UUID(), userId: UUID(), username: "QBMaster", xp: 1550, overallRating: 68),
            LeaderboardEntry(id: UUID(), userId: UUID(), username: "DefenseKing", xp: 1400, overallRating: 65),
            LeaderboardEntry(id: UUID(), userId: UUID(), username: "CoachPete", xp: 1250, overallRating: 62),
        ]

        isLoading = false
    }
}
