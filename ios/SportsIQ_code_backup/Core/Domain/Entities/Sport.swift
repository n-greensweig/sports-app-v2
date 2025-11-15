//
//  Sport.swift
//  SportsIQ
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

    init(
        id: UUID,
        name: String,
        slug: String,
        description: String,
        iconName: String,
        accentColorHex: String,
        isActive: Bool = true,
        displayOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.description = description
        self.iconName = iconName
        self.accentColorHex = accentColorHex
        self.isActive = isActive
        self.displayOrder = displayOrder
    }
}

// MARK: - Mock Data
extension Sport {
    static let football = Sport(
        id: UUID(),
        name: "Football",
        slug: "football",
        description: "Learn the ins and outs of American Football",
        iconName: "football.fill",
        accentColorHex: "#2E7D32",
        displayOrder: 1
    )

    static let basketball = Sport(
        id: UUID(),
        name: "Basketball",
        slug: "basketball",
        description: "Master the fundamentals of Basketball",
        iconName: "basketball.fill",
        accentColorHex: "#F57C00",
        displayOrder: 2
    )

    static let baseball = Sport(
        id: UUID(),
        name: "Baseball",
        slug: "baseball",
        description: "Discover America's favorite pastime",
        iconName: "baseball.fill",
        accentColorHex: "#1976D2",
        displayOrder: 3
    )

    static let mockSports = [football, basketball, baseball]
}
