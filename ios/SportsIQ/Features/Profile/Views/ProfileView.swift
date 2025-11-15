//
//  ProfileView.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import SwiftUI

struct ProfileView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: ProfileViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = State(initialValue: ProfileViewModel(
            userRepository: coordinator.userRepository,
            userId: coordinator.currentUser?.id ?? UUID()
        ))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .spacingL) {
                    // Profile Header
                    VStack(spacing: .spacingM) {
                        // Avatar
                        Circle()
                            .fill(Color.brandPrimary.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.brandPrimary)
                            )

                        if let user = coordinator.currentUser {
                            Text(user.displayName ?? user.username)
                                .font(.heading2)
                                .foregroundStyle(.textPrimary)

                            Text("@\(user.username)")
                                .font(.body)
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    .padding(.spacingL)

                    // Stats
                    if let progress = viewModel.userProgress {
                        VStack(spacing: .spacingM) {
                            Text("Football Stats")
                                .font(.heading3)
                                .foregroundStyle(.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            VStack(spacing: .spacingS) {
                                ProfileStatRow(
                                    icon: "star.fill",
                                    label: "Overall Rating",
                                    value: "\(progress.overallRating)/99"
                                )

                                ProfileStatRow(
                                    icon: "flame.fill",
                                    label: "Current Streak",
                                    value: "\(progress.currentStreak) days"
                                )

                                ProfileStatRow(
                                    icon: "trophy.fill",
                                    label: "Total XP",
                                    value: "\(progress.totalXP)"
                                )

                                ProfileStatRow(
                                    icon: "book.fill",
                                    label: "Lessons Completed",
                                    value: "\(progress.lessonsCompleted)"
                                )

                                ProfileStatRow(
                                    icon: "checkmark.circle.fill",
                                    label: "Accuracy",
                                    value: String(format: "%.1f%%", progress.accuracyPercentage)
                                )
                            }
                        }
                        .padding(.horizontal, .spacingM)
                    }

                    Divider()
                        .padding(.horizontal, .spacingM)

                    // Settings/Actions
                    VStack(spacing: .spacingS) {
                        ProfileActionButton(
                            icon: "bell.fill",
                            label: "Notifications",
                            action: {}
                        )

                        ProfileActionButton(
                            icon: "questionmark.circle.fill",
                            label: "Help & Support",
                            action: {}
                        )

                        ProfileActionButton(
                            icon: "info.circle.fill",
                            label: "About",
                            action: {}
                        )

                        ProfileActionButton(
                            icon: "arrow.right.square.fill",
                            label: "Sign Out",
                            action: {},
                            isDestructive: true
                        )
                    }
                    .padding(.horizontal, .spacingM)
                }
                .padding(.vertical, .spacingL)
            }
            .navigationTitle("Profile")
            .task {
                await viewModel.loadUserProgress()
            }
        }
    }
}

// MARK: - Profile Stat Row
struct ProfileStatRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.brandPrimary)
                .frame(width: 24)

            Text(label)
                .font(.body)
                .foregroundStyle(.textPrimary)

            Spacer()

            Text(value)
                .font(.body)
                .foregroundStyle(.textSecondary)
        }
        .padding(.spacingS)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusM)
    }
}

// MARK: - Profile Action Button
struct ProfileActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    var isDestructive: Bool = false

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(isDestructive ? .incorrect : .brandPrimary)
                    .frame(width: 24)

                Text(label)
                    .font(.body)
                    .foregroundStyle(isDestructive ? .incorrect : .textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.textTertiary)
            }
            .padding(.spacingM)
            .background(Color.backgroundSecondary)
            .cornerRadius(.radiusM)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Profile View") {
    ProfileView(coordinator: AppCoordinator(
        learningRepository: MockLearningRepository(),
        userRepository: MockUserRepository()
    ))
}
