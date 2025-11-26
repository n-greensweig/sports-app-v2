//
//  AppCoordinator.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import SwiftUI

/// Main app coordinator that handles navigation and dependency injection
@Observable
class AppCoordinator {
    // MARK: - Dependencies
    let learningRepository: LearningRepository
    let userRepository: UserRepository
    let gameRepository: GameRepository
    let authService: AuthService
    let audioManager: AudioManager
    let hapticManager: HapticManager

    // MARK: - State
    var currentUser: User? {
        authService.currentUser
    }

    var isAuthenticated: Bool {
        authService.isAuthenticated
    }

    init(
        learningRepository: LearningRepository,
        userRepository: UserRepository,
        gameRepository: GameRepository,
        authService: AuthService = AuthService.shared,
        audioManager: AudioManager = AudioManager.shared,
        hapticManager: HapticManager = HapticManager.shared
    ) {
        self.learningRepository = learningRepository
        self.userRepository = userRepository
        self.gameRepository = gameRepository
        self.authService = authService
        self.audioManager = audioManager
        self.hapticManager = hapticManager

        // Set up auth state listener
        authService.setupAuthStateListener()
    }

    @ViewBuilder
    func start() -> some View {
        if isAuthenticated {
            MainTabView(coordinator: self)
        } else {
            LoginView()
        }
    }
}

/// Main view (no tab bar - minimalist design)
struct MainTabView: View {
    let coordinator: AppCoordinator

    var body: some View {
        HomeView(coordinator: coordinator)
    }
}
