//
//  SportsIQApp.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//  Updated: 2025-11-15 - Added Supabase dependency injection (Task 3)
//  Updated: 2025-11-16 - Added GameRepository (Task 7)
//

import SwiftUI

@main
struct SportsIQApp: App {
    @State private var appCoordinator: AppCoordinator
    @State private var supabaseService = SupabaseService.shared

    init() {
        // Print configuration in debug mode
        #if DEBUG
        Config.printConfiguration()
        #endif

        // Initialize repositories
        let learningRepository = SupabaseLearningRepository()
        let userRepository = SupabaseUserRepository()
        let gameRepository = SupabaseGameRepository()

        // Initialize app coordinator
        self._appCoordinator = State(initialValue: AppCoordinator(
            learningRepository: learningRepository,
            userRepository: userRepository,
            gameRepository: gameRepository
        ))
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
                .environment(supabaseService)
        }
    }
}
