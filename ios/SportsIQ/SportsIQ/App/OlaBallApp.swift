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

    // Keep references to repositories
    private var supabaseUserRepository: SupabaseUserRepository?

    init() {
        // Print configuration in debug mode
        #if DEBUG
        Config.printConfiguration()
        #endif

        // Initialize repositories based on auth state
        let gameRepository = SupabaseGameRepository()
        let learningRepository: LearningRepository
        let userRepository: UserRepository

        if GuestSessionManager.shared.isGuestMode {
            // Guest mode - use local repositories
            let guestUserId = GuestSessionManager.shared.guestUserId
            let localUserRepo = LocalUserRepository(guestUserId: guestUserId)
            let localLearningRepo = LocalLearningRepository(
                guestUserId: guestUserId,
                localUserRepository: localUserRepo
            )
            learningRepository = localLearningRepo
            userRepository = localUserRepo
            self.supabaseUserRepository = nil
        } else {
            // Authenticated mode - use Supabase repositories
            let supabaseUserRepo = SupabaseUserRepository()
            let supabaseLearningRepo = SupabaseLearningRepository(userRepository: supabaseUserRepo)
            learningRepository = supabaseLearningRepo
            userRepository = supabaseUserRepo
            self.supabaseUserRepository = supabaseUserRepo
        }

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
            // Use the coordinator's user repository (works for both guest and authenticated)
            if let streak = try await appCoordinator.userRepository.getStreak(userId: user.id, sportId: footballId) {
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
