//
//  ProgressBar.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct ProgressBar: View {
    let progress: Double // 0.0 to 1.0
    var color: Color = .brandPrimary
    var height: CGFloat = 8

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color.backgroundTertiary)
                    .frame(height: height)
                    .cornerRadius(height / 2)

                // Progress
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * min(progress, 1.0), height: height)
                    .cornerRadius(height / 2)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: height)
    }
}

#Preview("Progress Bar") {
    VStack(spacing: .spacingL) {
        VStack(alignment: .leading, spacing: .spacingS) {
            Text("25% Complete")
                .font(.caption)
            ProgressBar(progress: 0.25)
        }

        VStack(alignment: .leading, spacing: .spacingS) {
            Text("50% Complete")
                .font(.caption)
            ProgressBar(progress: 0.5, color: .footballAccent)
        }

        VStack(alignment: .leading, spacing: .spacingS) {
            Text("75% Complete")
                .font(.caption)
            ProgressBar(progress: 0.75, color: .correct)
        }

        VStack(alignment: .leading, spacing: .spacingS) {
            Text("100% Complete")
                .font(.caption)
            ProgressBar(progress: 1.0, color: .brandPrimary)
        }
    }
    .padding()
}
