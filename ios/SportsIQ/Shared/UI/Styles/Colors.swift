//
//  Colors.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

extension Color {
    // MARK: - Sport Colors
    static let footballAccent = Color(hex: "#2E7D32")
    static let basketballAccent = Color(hex: "#F57C00")
    static let baseballAccent = Color(hex: "#1976D2")
    static let hockeyAccent = Color(hex: "#0288D1")
    static let soccerAccent = Color(hex: "#388E3C")
    static let golfAccent = Color(hex: "#689F38")

    // MARK: - Brand Colors
    static let brandPrimary = Color(hex: "#1976D2")
    static let brandSecondary = Color(hex: "#424242")

    // MARK: - Semantic Colors
    static let correct = Color(hex: "#4CAF50")
    static let incorrect = Color(hex: "#F44336")
    static let warning = Color(hex: "#FF9800")
    static let info = Color(hex: "#2196F3")

    // MARK: - Background Colors
    static let backgroundPrimary = Color(hex: "#FFFFFF")
    static let backgroundSecondary = Color(hex: "#F5F5F5")
    static let backgroundTertiary = Color(hex: "#E0E0E0")

    // MARK: - Text Colors
    static let textPrimary = Color(hex: "#212121")
    static let textSecondary = Color(hex: "#757575")
    static let textTertiary = Color(hex: "#9E9E9E")

    // MARK: - Helper Init
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Sport Extension
extension Sport {
    var accentColor: Color {
        Color(hex: accentColorHex)
    }
}
