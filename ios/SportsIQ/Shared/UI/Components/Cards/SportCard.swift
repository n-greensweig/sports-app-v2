//
//  SportCard.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct SportCard: View {
    let sport: Sport
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: .spacingS) {
                HStack {
                    Image(systemName: sport.iconName)
                        .font(.system(size: 32))
                        .foregroundStyle(sport.accentColor)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundStyle(.textSecondary)
                }

                Text(sport.name)
                    .font(.heading3)
                    .foregroundStyle(.textPrimary)

                Text(sport.description)
                    .font(.bodySmall)
                    .foregroundStyle(.textSecondary)
                    .lineLimit(2)
            }
            .padding(.spacingM)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.backgroundSecondary)
            .cornerRadius(.radiusL)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Sport Card") {
    VStack(spacing: .spacingM) {
        SportCard(sport: .football, action: {})
        SportCard(sport: .basketball, action: {})
    }
    .padding()
}
