//
//  AppCoordinator.swift
//  SportsIQ
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
        authService: AuthService = AuthService.shared
    ) {
        self.learningRepository = learningRepository
        self.userRepository = userRepository
        self.gameRepository = gameRepository
        self.authService = authService

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

/// Main tab view with bottom navigation
struct MainTabView: View {
    let coordinator: AppCoordinator
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(coordinator: coordinator)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            LearnView(coordinator: coordinator)
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }
                .tag(1)

            ReviewView(coordinator: coordinator)
                .tabItem {
                    Label("Review", systemImage: "arrow.clockwise")
                }
                .tag(2)

            ProfileView(coordinator: coordinator)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(.brandPrimary)
    }
}
