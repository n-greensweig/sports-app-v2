//
//  Typography.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

extension Font {
    // MARK: - Headings
    static let heading1 = Font.system(size: 32, weight: .bold, design: .default)
    static let heading2 = Font.system(size: 24, weight: .semibold, design: .default)
    static let heading3 = Font.system(size: 20, weight: .semibold, design: .default)
    static let heading4 = Font.system(size: 18, weight: .semibold, design: .default)

    // MARK: - Body Text
    static let bodyLarge = Font.system(size: 18, weight: .regular, design: .default)
    static let body = Font.system(size: 16, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)

    // MARK: - Special
    static let caption = Font.system(size: 14, weight: .regular, design: .default)
    static let small = Font.system(size: 12, weight: .regular, design: .default)
    static let button = Font.system(size: 16, weight: .semibold, design: .default)
    static let label = Font.system(size: 14, weight: .medium, design: .default)
}
