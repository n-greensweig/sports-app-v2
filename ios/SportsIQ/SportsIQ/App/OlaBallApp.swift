//
//  OlaBallApp.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//  Updated: 2025-11-15 - Added Supabase dependency injection (Task 3)
//  Updated: 2025-11-16 - Added GameRepository (Task 7)
//  Updated: 2025-11-23 - Renamed to Ola Ball
//

import SwiftUI

@main
struct OlaBallApp: App {
    @State private var appCoordinator: AppCoordinator
    @State private var supabaseService = SupabaseService.shared

    init() {
        // Print configuration in debug mode
        #if DEBUG
        Config.printConfiguration()
        #endif

        // Initialize repositories
        let userRepository = SupabaseUserRepository()
        let learningRepository = SupabaseLearningRepository(userRepository: userRepository)
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
                .onOpenURL { url in
                    handleIncomingURL(url)
                }
        }
    }
}
