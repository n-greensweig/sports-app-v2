//
//  SportPickerButton.swift
//  Ola Ball
//
//  A sport picker that shows the current sport emoji in the toolbar.
//  Tapping it reveals a horizontal row of available sports below the nav bar.
//

import SwiftUI

struct SportPickerButton: View {
    let sports: [Sport]
    @Binding var selectedSport: Sport?
    @Binding var showPicker: Bool
    let onSportSelected: (Sport) -> Void

    var body: some View {
        Group {
            if let sport = selectedSport {
                Text(sport.emoji)
                    .font(.system(size: 28))
            } else {
                Image(systemName: "sportscourt.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                showPicker.toggle()
            }
        }
    }
}

// MARK: - Sport Picker Dropdown (appears below nav bar)
struct SportPickerDropdown: View {
    let sports: [Sport]
    let selectedSport: Sport?
    let onSportSelected: (Sport) -> Void
    let onDismiss: () -> Void

    private let iconSize: CGFloat = 72

    var body: some View {
        HStack(spacing: 16) {
            ForEach(sports) { sport in
                SportPickerIcon(
                    sport: sport,
                    isSelected: selectedSport?.id == sport.id,
                    size: iconSize,
                    onTap: {
                        onSportSelected(sport)
                    }
                )
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Sport Picker Icon
struct SportPickerIcon: View {
    let sport: Sport
    let isSelected: Bool
    let size: CGFloat
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Icon container with rounded rectangle style
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(sport.accentColor.opacity(0.12))
                        .frame(width: size, height: size)

                    // Selection border
                    if isSelected {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(sport.accentColor, lineWidth: 3)
                            .frame(width: size, height: size)
                    }

                    // Sport emoji
                    Text(sport.emoji)
                        .font(.system(size: size * 0.45))
                }

                // Sport name
                Text(sport.name)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(isSelected ? sport.accentColor : Color.textSecondary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews
#Preview("Sport Picker Dropdown") {
    VStack {
        SportPickerDropdown(
            sports: Sport.mockSports,
            selectedSport: .football,
            onSportSelected: { _ in },
            onDismiss: {}
        )
        Spacer()
    }
}

#Preview("Sport Icons") {
    HStack(spacing: 20) {
        SportPickerIcon(sport: .football, isSelected: true, size: 72, onTap: {})
        SportPickerIcon(sport: .baseball, isSelected: false, size: 72, onTap: {})
    }
    .padding()
}
