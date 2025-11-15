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
                                    .foregroundStyle(Color.brandPrimary)
                            )

                        if let user = coordinator.currentUser {
                            Text(user.displayName ?? user.username)
                                .font(.heading2)
                                .foregroundStyle(Color.textPrimary)

                            Text("@\(user.username)")
                                .font(.body)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                    .padding(.spacingL)

                    // Stats
                    if let progress = viewModel.userProgress {
                        VStack(spacing: .spacingM) {
                            Text("Football Stats")
                                .font(.heading3)
                                .foregroundStyle(Color.textPrimary)
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

                    // Badges Section
                    VStack(alignment: .leading, spacing: .spacingM) {
                        HStack {
                            Text("Badges")
                                .font(.heading3)
                                .foregroundStyle(Color.textPrimary)

                            Spacer()

                            Text("\(viewModel.earnedBadges.count)/\(Badge.mockBadges.count)")
                                .font(.caption)
                                .foregroundStyle(Color.textSecondary)
                        }

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: .spacingM) {
                            ForEach(Badge.mockBadges) { badge in
                                BadgeCardView(
                                    badge: badge,
                                    isEarned: viewModel.earnedBadges.contains(where: { $0.badge.id == badge.id })
                                )
                            }
                        }
                    }
                    .padding(.horizontal, .spacingM)

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
                .foregroundStyle(Color.brandPrimary)
                .frame(width: 24)

            Text(label)
                .font(.body)
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text(value)
                .font(.body)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(.spacingS)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusM)
    }
}

// MARK: - Badge Card View
struct BadgeCardView: View {
    let badge: Badge
    let isEarned: Bool

    var body: some View {
        VStack(spacing: .spacingS) {
            ZStack {
                Circle()
                    .fill(isEarned ? Color(hex: badge.rarity.colorHex).opacity(0.2) : Color.backgroundSecondary)
                    .frame(width: 64, height: 64)

                Image(systemName: badge.iconName)
                    .font(.system(size: 28))
                    .foregroundStyle(isEarned ? Color(hex: badge.rarity.colorHex) : Color.textTertiary)
            }

            Text(badge.name)
                .font(.small)
                .foregroundStyle(isEarned ? Color.textPrimary : Color.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.spacingS)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusM)
        .opacity(isEarned ? 1.0 : 0.5)
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
                    .foregroundStyle(isDestructive ? Color.incorrect : Color.brandPrimary)
                    .frame(width: 24)

                Text(label)
                    .font(.body)
                    .foregroundStyle(isDestructive ? Color.incorrect : Color.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.textTertiary)
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
