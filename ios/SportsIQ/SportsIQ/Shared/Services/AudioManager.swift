//
//  AudioManager.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import AVFoundation
import AudioToolbox

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
        playSound(named: "correct_answer.mp3", fallbackSystemSoundID: 1057) // Pin drop / nice tone
    }

    func playIncorrectSound() {
        playSound(named: "incorrect_answer.mp3", fallbackSystemSoundID: 1053) // System sound for error/alert
    }

    func playLessonCompleteSound() {
        playSound(named: "lesson_complete.mp3", fallbackSystemSoundID: 1022) // Fanfare-ish
    }

    func playXPGainSound() {
        playSound(named: "xp_gain.mp3", fallbackSystemSoundID: 1103) // Tink
    }

    func playLevelUpSound() {
        playSound(named: "level_up.mp3", fallbackSystemSoundID: 1023) // Fanfare
    }

    func playBadgeEarnedSound() {
        playSound(named: "badge_earned.mp3", fallbackSystemSoundID: 1025) // Fanfare
    }

    func playStreakSound() {
        playSound(named: "streak.mp3", fallbackSystemSoundID: 1104) // Tink
    }

    // MARK: - Football Specific Sounds

    func playWhistleSound() {
        playSound(named: "whistle.mp3", fallbackSystemSoundID: 1000) // Generic
    }

    func playCrowdCheerSound() {
        playSound(named: "crowd_cheer.mp3", fallbackSystemSoundID: 1022) // Fanfare
    }

    // MARK: - Private Methods

    private func playSound(named filename: String, fallbackSystemSoundID: SystemSoundID? = nil) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            // Fallback to system sound if file not found
            if let systemSoundID = fallbackSystemSoundID {
                AudioServicesPlaySystemSound(systemSoundID)
            } else {
                print("Sound file not found: \(filename)")
            }
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
    }

    func stopAllSounds() {
        for (_, player) in audioPlayers {
            player.stop()
        }
        audioPlayers.removeAll()
    }
}
