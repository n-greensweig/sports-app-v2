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
    var learningRepository: LearningRepository
    var userRepository: UserRepository
    let gameRepository: GameRepository
    let authService: AuthService
    let audioManager: AudioManager
    let hapticManager: HapticManager

    // MARK: - State

    /// Current user (authenticated or guest)
    var currentUser: User? {
        if authService.isGuestMode {
            return authService.guestUser
        }
        return authService.currentUser
    }

    /// Whether the user is authenticated (includes guest mode)
    var isAuthenticated: Bool {
        authService.isAuthenticated || authService.isGuestMode
    }

    /// Whether the user is in guest mode
    var isGuestMode: Bool {
        authService.isGuestMode
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
