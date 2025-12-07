//
//  TestOutEligibility.swift
//  Ola Ball
//
//  Created on 2025-12-06.
//

import Foundation

/// Represents a user's eligibility to attempt a module test-out
struct TestOutEligibility: Codable, Hashable {
    let canAttempt: Bool           // Whether the user can take the test now
    let attemptsRemaining: Int     // 0, 1, or 2 attempts left in current 24h window
    let cooldownEndsAt: Date?      // When the user can try again (if in cooldown)
    let hasPassed: Bool            // Whether the user has already passed this test-out

    init(
        canAttempt: Bool,
        attemptsRemaining: Int,
        cooldownEndsAt: Date? = nil,
        hasPassed: Bool = false
    ) {
        self.canAttempt = canAttempt
        self.attemptsRemaining = attemptsRemaining
        self.cooldownEndsAt = cooldownEndsAt
        self.hasPassed = hasPassed
    }

    /// Human-readable status message for UI display
    var statusMessage: String {
        if hasPassed {
            return "You've already passed this test!"
        }
        if canAttempt {
            if attemptsRemaining == 2 {
                return "2 attempts available"
            } else if attemptsRemaining == 1 {
                return "1 attempt remaining today"
            }
        }
        if let cooldownEnds = cooldownEndsAt {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            let relative = formatter.localizedString(for: cooldownEnds, relativeTo: Date())
            return "Try again \(relative)"
        }
        return "No attempts available"
    }

    /// Time remaining until cooldown ends (nil if not in cooldown)
    var cooldownTimeRemaining: TimeInterval? {
        guard let cooldownEnds = cooldownEndsAt else { return nil }
        let remaining = cooldownEnds.timeIntervalSince(Date())
        return remaining > 0 ? remaining : nil
    }
}

// MARK: - Convenience Initializers
extension TestOutEligibility {
    /// User can take the test with full attempts
    static let available = TestOutEligibility(
        canAttempt: true,
        attemptsRemaining: 2,
        cooldownEndsAt: nil,
        hasPassed: false
    )

    /// User has already passed
    static let alreadyPassed = TestOutEligibility(
        canAttempt: false,
        attemptsRemaining: 0,
        cooldownEndsAt: nil,
        hasPassed: true
    )

    /// User is in cooldown (used up 2 attempts)
    static func inCooldown(until date: Date) -> TestOutEligibility {
        TestOutEligibility(
            canAttempt: false,
            attemptsRemaining: 0,
            cooldownEndsAt: date,
            hasPassed: false
        )
    }

    /// User has 1 attempt remaining
    static let oneAttemptLeft = TestOutEligibility(
        canAttempt: true,
        attemptsRemaining: 1,
        cooldownEndsAt: nil,
        hasPassed: false
    )
}
