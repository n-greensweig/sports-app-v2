//
//  HapticManager.swift
//  SportsIQ
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

    // MARK: - Custom Haptic Patterns

    func playLevelUpPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            playMediumImpact()
            return
        }

        var events: [CHHapticEvent] = []

        // Create ascending pattern
        for i in 0..<3 {
            let intensity = CHHapticEventParameter(
                parameterID: .hapticIntensity,
                value: Float(0.5 + Double(i) * 0.2)
            )
            let sharpness = CHHapticEventParameter(
                parameterID: .hapticSharpness,
                value: 0.5
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
