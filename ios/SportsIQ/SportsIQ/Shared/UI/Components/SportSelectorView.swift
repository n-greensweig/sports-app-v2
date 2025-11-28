//
//  SportSelectorView.swift
//  Ola Ball
//
//  Horizontal scrolling sport selector with circular emoji icons
//

import SwiftUI

struct SportSelectorView: View {
    let sports: [Sport]
    @Binding var selectedSport: Sport?

    private let iconSize: CGFloat = 56
    private let spacing: CGFloat = 16

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                ForEach(sports) { sport in
                    SportIconButton(
                        sport: sport,
                        isSelected: selectedSport?.id == sport.id,
                        size: iconSize
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedSport = sport
                        }
                    }
                }
            }
            .padding(.horizontal, .spacingM)
            .padding(.vertical, .spacingS)
        }
    }
}

// MARK: - Sport Icon Button
struct SportIconButton: View {
    let sport: Sport
    let isSelected: Bool
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    // Background circle
                    Circle()
                        .fill(isSelected ? sport.accentColor : Color.backgroundSecondary)
                        .frame(width: size, height: size)

                    // Selection ring
                    if isSelected {
                        Circle()
                            .stroke(sport.accentColor.opacity(0.3), lineWidth: 3)
                            .frame(width: size + 8, height: size + 8)
                    }

                    // Emoji
                    Text(sport.emoji.isEmpty ? "🏆" : sport.emoji)
                        .font(.system(size: size * 0.5))
                }

                // Sport name
                Text(sport.name)
                    .font(.caption2)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(isSelected ? sport.accentColor : Color.textSecondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Preview
#Preview("Sport Selector") {
    struct PreviewWrapper: View {
        @State private var selected: Sport? = .football

        var body: some View {
            VStack(spacing: 32) {
                Text("Sport Selector")
                    .font(.headline)

                SportSelectorView(
                    sports: Sport.mockSports,
                    selectedSport: $selected
                )
                .background(Color.backgroundPrimary)

                if let sport = selected {
                    Text("Selected: \(sport.name)")
                        .foregroundStyle(sport.accentColor)
                }

                Spacer()
            }
            .padding(.top, 32)
        }
    }

    return PreviewWrapper()
}

#Preview("Sport Icons") {
    HStack(spacing: 16) {
        SportIconButton(sport: .football, isSelected: true, size: 56) {}
        SportIconButton(sport: .baseball, isSelected: false, size: 56) {}
    }
    .padding()
}
