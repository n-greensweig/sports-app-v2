//
//  Sport.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import Foundation

/// Represents a sport available in the app (e.g., Football, Basketball)
struct Sport: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let slug: String
    let description: String
    let iconName: String
    let isActive: Bool
    let displayOrder: Int

    /// Accent color for the sport (stored as hex string)
    let accentColorHex: String

    /// Emoji for the sport (used in sport selector)
    let emoji: String

    init(
        id: UUID,
        name: String,
        slug: String,
        description: String,
        iconName: String,
        accentColorHex: String,
        emoji: String = "",
        isActive: Bool = true,
        displayOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.description = description
        self.iconName = iconName
        self.accentColorHex = accentColorHex
        self.emoji = emoji
        self.isActive = isActive
        self.displayOrder = displayOrder
    }
}

// MARK: - Mock Data
extension Sport {
    static let football = Sport(
        id: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!,
        name: "Football",
        slug: "football",
        description: "Learn the ins and outs of American Football",
        iconName: "football.fill",
        accentColorHex: "#2E7D32",
        emoji: "🏈",
        displayOrder: 1
    )

    static let basketball = Sport(
        id: UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")!,
        name: "Basketball",
        slug: "basketball",
        description: "Master the fundamentals of Basketball",
        iconName: "basketball.fill",
        accentColorHex: "#F57C00",
        emoji: "🏀",
        displayOrder: 2
    )

    static let baseball = Sport(
        id: UUID(uuidString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC")!,
        name: "Baseball",
        slug: "baseball",
        description: "Discover America's favorite pastime",
        iconName: "baseball.fill",
        accentColorHex: "#1976D2",
        emoji: "⚾",
        displayOrder: 3
    )

    static let hockey = Sport(
        id: UUID(uuidString: "DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD")!,
        name: "Hockey",
        slug: "hockey",
        description: "Learn the fast-paced game of Hockey",
        iconName: "hockey.puck.fill",
        accentColorHex: "#0288D1",
        emoji: "🏒",
        displayOrder: 4
    )

    static let soccer = Sport(
        id: UUID(uuidString: "EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEEEEE")!,
        name: "Soccer",
        slug: "soccer",
        description: "Discover the world's most popular sport",
        iconName: "soccerball",
        accentColorHex: "#388E3C",
        emoji: "⚽",
        displayOrder: 5
    )

    static let golf = Sport(
        id: UUID(uuidString: "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF")!,
        name: "Golf",
        slug: "golf",
        description: "Master the gentleman's game",
        iconName: "figure.golf",
        accentColorHex: "#689F38",
        emoji: "⛳",
        displayOrder: 6
    )

    static let mockSports = [football, basketball, baseball, hockey, soccer, golf]
}
