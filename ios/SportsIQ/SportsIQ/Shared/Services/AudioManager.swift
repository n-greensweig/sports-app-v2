//
//  AudioManager.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import AVFoundation

/// Manager for audio feedback throughout the app
class AudioManager {
    static let shared = AudioManager()

    private var audioPlayers: [String: AVAudioPlayer] = [:]

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    // MARK: - Sound Effects

    func playCorrectSound() {
        // In a real app, play actual sound file
        // playSound(named: "correct_answer.mp3")
        print("🔊 Playing correct answer sound")
    }

    func playIncorrectSound() {
        // In a real app, play actual sound file
        // playSound(named: "incorrect_answer.mp3")
        print("🔊 Playing incorrect answer sound")
    }

    func playLessonCompleteSound() {
        // In a real app, play actual sound file
        // playSound(named: "lesson_complete.mp3")
        print("🔊 Playing lesson complete sound")
    }

    func playXPGainSound() {
        // In a real app, play actual sound file
        // playSound(named: "xp_gain.mp3")
        print("🔊 Playing XP gain sound")
    }

    func playLevelUpSound() {
        // In a real app, play actual sound file
        // playSound(named: "level_up.mp3")
        print("🔊 Playing level up sound")
    }

    func playBadgeEarnedSound() {
        // In a real app, play actual sound file
        // playSound(named: "badge_earned.mp3")
        print("🔊 Playing badge earned sound")
    }

    func playStreakSound() {
        // In a real app, play actual sound file
        // playSound(named: "streak.mp3")
        print("🔊 Playing streak sound")
    }

    // MARK: - Football Specific Sounds

    func playWhistleSound() {
        // In a real app, play actual sound file
        // playSound(named: "whistle.mp3")
        print("🔊 Playing whistle sound")
    }

    func playCrowdCheerSound() {
        // In a real app, play actual sound file
        // playSound(named: "crowd_cheer.mp3")
        print("🔊 Playing crowd cheer sound")
    }

    // MARK: - Private Methods

    private func playSound(named filename: String) {
        // Implementation for loading and playing sound files
        // This would load MP3/WAV files from the bundle
        /*
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Sound file not found: \(filename)")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
            audioPlayers[filename] = player
        } catch {
            print("Failed to play sound: \(error)")
        }
        */
    }

    func stopAllSounds() {
        for (_, player) in audioPlayers {
            player.stop()
        }
        audioPlayers.removeAll()
    }
}
