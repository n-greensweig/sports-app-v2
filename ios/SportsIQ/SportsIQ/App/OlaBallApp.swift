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
    @Environment(\.scenePhase) private var scenePhase

    // Keep a reference to userRepository for streak checks
    private let userRepository: SupabaseUserRepository

    init() {
        // Print configuration in debug mode
        #if DEBUG
        Config.printConfiguration()
        #endif

        // Initialize repositories
        let userRepo = SupabaseUserRepository()
        let learningRepository = SupabaseLearningRepository(userRepository: userRepo)
        let gameRepository = SupabaseGameRepository()

        self.userRepository = userRepo

        // Initialize app coordinator
        self._appCoordinator = State(initialValue: AppCoordinator(
            learningRepository: learningRepository,
            userRepository: userRepo,
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
                .onChange(of: scenePhase) { _, newPhase in
                    handleScenePhaseChange(newPhase)
                }
        }
    }

    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .active:
            // User opened app - cancel any pending reminder
            NotificationManager.shared.cancelStreakReminder()

        case .background:
            // User left app - schedule reminder if needed
            Task {
                await scheduleStreakReminderIfNeeded()
            }

        case .inactive:
            break

        @unknown default:
            break
        }
    }

    private func scheduleStreakReminderIfNeeded() async {
        guard let user = appCoordinator.currentUser else { return }

        // Football sport ID
        let footballId = UUID(uuidString: "0105433b-5bdd-4093-b6b1-157a0c3c515e")!

        do {
            if let streak = try await userRepository.getStreak(userId: user.id, sportId: footballId) {
                // Only schedule if they haven't practiced today
                if !Calendar.current.isDateInToday(streak.lastActivityDate) {
                    NotificationManager.shared.scheduleStreakReminder(currentStreak: streak.currentStreak)
                }
            }
        } catch {
            #if DEBUG
            print("Error checking streak for notification: \(error)")
            #endif
        }
    }
}
