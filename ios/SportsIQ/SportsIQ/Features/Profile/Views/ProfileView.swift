//
//  ProfileView.swift
//  Ola Ball
//
//  Created on 2025-11-15.
//

import SwiftUI

struct ProfileView: View {
    let coordinator: AppCoordinator
    @State private var viewModel: ProfileViewModel
    @State private var showSignOutAlert = false
    @State private var isSigningOut = false
    @State private var showDeleteAccountAlert = false
    @State private var isDeletingAccount = false
    @State private var deleteErrorMessage: String?

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self._viewModel = State(initialValue: ProfileViewModel(
            userRepository: coordinator.userRepository,
            userId: coordinator.currentUser?.id ?? UUID()
        ))
    }

    var body: some View {
        NavigationStack {
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

                Spacer()

                // Action Buttons
                VStack(spacing: .spacingS) {
                    // Sign Out Button
                    ProfileActionButton(
                        icon: "arrow.right.square.fill",
                        label: isSigningOut ? "Signing Out..." : "Sign Out",
                        action: { showSignOutAlert = true },
                        isDestructive: false
                    )
                    .disabled(isSigningOut || isDeletingAccount)

                    // Delete Account Button
                    ProfileActionButton(
                        icon: "trash.fill",
                        label: isDeletingAccount ? "Deleting Account..." : "Delete Account",
                        action: { showDeleteAccountAlert = true },
                        isDestructive: true
                    )
                    .disabled(isSigningOut || isDeletingAccount)
                }
                .padding(.horizontal, .spacingM)
                .padding(.bottom, .spacingL)
            }
            .navigationTitle("Profile")
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    Task {
                        await signOut()
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task {
                        await deleteAccount()
                    }
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone. All your progress, achievements, and data will be permanently deleted.")
            }
            .alert("Error", isPresented: .init(
                get: { deleteErrorMessage != nil },
                set: { if !$0 { deleteErrorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(deleteErrorMessage ?? "An unknown error occurred.")
            }
        }
    }

    // MARK: - Methods

    private func signOut() async {
        isSigningOut = true
        do {
            try await coordinator.authService.signOut()
        } catch {
            print("❌ Sign out error: \(error.localizedDescription)")
        }
        isSigningOut = false
    }

    private func deleteAccount() async {
        isDeletingAccount = true
        do {
            try await coordinator.authService.deleteAccount()
        } catch {
            deleteErrorMessage = error.localizedDescription
            print("❌ Delete account error: \(error.localizedDescription)")
        }
        isDeletingAccount = false
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
        userRepository: MockUserRepository(),
        gameRepository: MockGameRepository()
    ))
}
