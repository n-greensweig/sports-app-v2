//
//  HapticManager.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import UIKit
import CoreHaptics

/// Manager for haptic feedback throughout the app
class HapticManager {
    static let shared = HapticManager()

    private var engine: CHHapticEngine?

    private init() {
        prepareHaptics()
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Failed to start haptic engine: \(error)")
        }
    }

    // MARK: - Simple Haptics

    func playCorrectFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func playIncorrectFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    func playSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    func playLightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func playMediumImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    func playHeavyImpact() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    /// Soft haptic for section/banner changes while scrolling
    func playSectionChangeFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred(intensity: 0.6)
    }

    // MARK: - Custom Haptic Patterns

    func playLevelUpPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            playLightImpact()
            return
        }

        var events: [CHHapticEvent] = []

        // Create ascending pattern (gentler)
        for i in 0..<3 {
            let intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: Float(0.3 + Double(i) * 0.15)
            )
            let sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 0.35
            )

            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: Double(i) * 0.15
            )
            events.append(event)
        }

        playPattern(events: events)
    }

    func playStreakPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            playHeavyImpact()
            return
        }

        var events: [CHHapticEvent] = []

        // Quick double tap
        for i in 0..<2 {
            let intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: 0.8
            )
            let sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 0.7
            )

            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: Double(i) * 0.1
            )
            events.append(event)
        }

        playPattern(events: events)
    }

    /// Dramatic build-up pattern for streak milestones
    func playMilestonePattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            playHeavyImpact()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.playHeavyImpact()
            }
            return
        }

        var events: [CHHapticEvent] = []

        // Ascending 5-tap pattern with increasing intensity
        for i in 0..<5 {
            let intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: Float(0.3 + Double(i) * 0.15)
            )
            let sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: Float(0.3 + Double(i) * 0.1)
            )

            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: Double(i) * 0.1
            )
            events.append(event)
        }

        // Final burst
        let finalIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let finalSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
        let finalEvent = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [finalIntensity, finalSharpness],
            relativeTime: 0.6
        )
        events.append(finalEvent)

        playPattern(events: events)
    }

    /// Triple tap celebration for perfect scores
    func playPerfectScorePattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            playMediumImpact()
            return
        }

        var events: [CHHapticEvent] = []

        // Triple tap celebration (gentler)
        for i in 0..<3 {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)

            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: Double(i) * 0.15
            )
            events.append(event)
        }

        playPattern(events: events)
    }

    private func playPattern(events: [CHHapticEvent]) {
        guard let engine = engine else { return }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern: \(error)")
        }
    }
}
