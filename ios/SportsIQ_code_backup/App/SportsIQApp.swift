//
//  SportsIQApp.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

@main
struct SportsIQApp: App {
    @State private var appCoordinator: AppCoordinator

    init() {
        // Initialize repositories (mock for now)
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
        }
    }
}
