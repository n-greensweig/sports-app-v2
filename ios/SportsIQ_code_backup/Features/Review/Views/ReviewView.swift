//
//  ReviewView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct ReviewView: View {
    let coordinator: AppCoordinator

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .spacingL) {
                    // Coming Soon Placeholder
                    VStack(spacing: .spacingM) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.brandPrimary)

                        Text("Spaced Repetition")
                            .font(.heading2)
                            .foregroundStyle(.textPrimary)

                        Text("Review past concepts to reinforce your learning. This feature is coming soon!")
                            .font(.body)
                            .foregroundStyle(.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, .spacingXL)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.spacingXXL)
                }
                .padding(.spacingM)
            }
            .navigationTitle("Review")
        }
    }
}

#Preview("Review View") {
    ReviewView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository()
    ))
}
