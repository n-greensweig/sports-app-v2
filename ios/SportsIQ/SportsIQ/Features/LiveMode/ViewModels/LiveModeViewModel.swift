//
//  LiveModeViewModel.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

@Observable
class LiveModeViewModel {
    var isLoading = false
    var games: [Game] = []

    var liveGames: [Game] {
        games.filter { $0.isLive }
    }

    var upcomingGames: [Game] {
        games.filter { $0.status == .scheduled }
    }

    @MainActor
    func loadGames() async {
        isLoading = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        games = Game.mockGames
        isLoading = false
    }
}
