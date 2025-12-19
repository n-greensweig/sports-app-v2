//
//  NotificationManager.swift
//  Ola Ball
//
//  Created for Engagement Features
//

import Foundation
import UserNotifications

/// Manager for local push notifications (streak reminders)
@Observable
class NotificationManager: NSObject {
    static let shared = NotificationManager()

    var isAuthorized = false

    private let streakReminderIdentifier = "streak_reminder"
    private let notificationCenter = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        Task {
            await checkAuthorizationStatus()
        }
    }

    // MARK: - Permission

    /// Request notification permission from the user
    func requestPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            await MainActor.run {
                isAuthorized = granted
            }

            #if DEBUG
            print(granted ? "Notification permission granted" : "Notification permission denied")
            #endif

            return granted
        } catch {
            #if DEBUG
            print("Notification permission error: \(error)")
            #endif
            return false
        }
    }

    /// Check current authorization status
    func checkAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        await MainActor.run {
            isAuthorized = settings.authorizationStatus == .authorized
        }
    }

    // MARK: - Streak Reminder

    /// Schedule a gentle reminder for 8 PM if streak is at risk
    func scheduleStreakReminder(currentStreak: Int) {
        guard currentStreak > 0 else { return }

        // Cancel any existing reminder first
        cancelStreakReminder()

        let content = UNMutableNotificationContent()
        content.title = "Don't lose your streak!"
        content.body = streakReminderBody(for: currentStreak)
        content.sound = .default
        content.badge = 1

        // Schedule for 8 PM local time today
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: streakReminderIdentifier,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            #if DEBUG
            if let error = error {
                print("Failed to schedule streak reminder: \(error)")
            } else {
                print("Scheduled streak reminder for 8 PM")
            }
            #endif
        }
    }

    /// Cancel any pending streak reminder
    func cancelStreakReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [streakReminderIdentifier])

        // Also clear badge
        Task { @MainActor in
            try? await UNUserNotificationCenter.current().setBadgeCount(0)
        }

        #if DEBUG
        print("Cancelled pending streak reminder")
        #endif
    }

    /// Generate reminder body text based on streak length
    private func streakReminderBody(for streak: Int) -> String {
        switch streak {
        case 1...6:
            return "You've got a \(streak)-day streak going. Complete a lesson to keep it alive!"
        case 7...13:
            return "A whole week of learning! Don't break your \(streak)-day streak now."
        case 14...29:
            return "You're on fire with \(streak) days! Keep the momentum going."
        case 30...99:
            return "Incredible! \(streak) days strong. One lesson keeps the streak alive!"
        default:
            return "Your \(streak)-day streak is legendary. Don't stop now!"
        }
    }
}
