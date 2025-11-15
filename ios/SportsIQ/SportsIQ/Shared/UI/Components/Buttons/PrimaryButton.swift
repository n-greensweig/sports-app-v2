//
//  PrimaryButton.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var color: Color = .brandPrimary
    var isEnabled: Bool = true
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }

                Text(title)
                    .font(.button)
                    .foregroundStyle(Color.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isEnabled ? color : Color.gray)
            .cornerRadius(.radiusM)
        }
        .disabled(!isEnabled || isLoading)
    }
}

#Preview("Primary Button") {
    VStack(spacing: .spacingM) {
        PrimaryButton(title: "Continue", action: {})
        PrimaryButton(title: "Start Lesson", action: {}, color: .footballAccent)
        PrimaryButton(title: "Disabled", action: {}, isEnabled: false)
        PrimaryButton(title: "Loading", action: {}, isLoading: true)
    }
    .padding()
}
