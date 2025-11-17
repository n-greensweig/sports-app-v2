//
//  SportsIQApp.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//  Updated: 2025-11-15 - Added Supabase dependency injection (Task 3)
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
        let userRepository = MockUserRepository()

        // Initialize app coordinator
        self._appCoordinator = State(initialValue: AppCoordinator(
            learningRepository: learningRepository,
            userRepository: userRepository
        ))
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
                .environment(supabaseService)
        }
    }
}
