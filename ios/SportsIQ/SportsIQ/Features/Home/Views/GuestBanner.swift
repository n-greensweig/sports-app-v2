//
//  GuestBanner.swift
//  Ola Ball
//
//  Created on 2025-12-18.
//  Guest Mode Implementation - Subtle reminder banner for guest users
//

import SwiftUI

/// A subtle banner shown to guest users encouraging them to create an account
struct GuestBanner: View {
    let onCreateAccount: () -> Void

    var body: some View {
        Button(action: onCreateAccount) {
            HStack(spacing: .spacingS) {
                Image(systemName: "person.badge.plus")
                    .font(.subheadline)
                    .foregroundStyle(Color.brandPrimary)

                Text("Create an account to save progress across devices")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.horizontal, .spacingM)
            .padding(.vertical, .spacingS)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.brandPrimary.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.brandPrimary.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        GuestBanner {
            print("Create account tapped")
        }
        .padding()

        Spacer()
    }
    .background(Color.backgroundPrimary)
}
