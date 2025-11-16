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

        // Initialize repositories (mock for now)
        // TODO: Replace with real repositories after Task 4 (DTOs) is complete
        let learningRepository = MockLearningRepository()
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
