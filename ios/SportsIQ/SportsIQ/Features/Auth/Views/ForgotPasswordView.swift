//
//  ForgotPasswordView.swift
//  SportsIQ
//
//  Created by Claude on 2025-11-17.
//  Task 8: Authentication Integration
//

import SwiftUI

struct ForgotPasswordView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @State private var authService = AuthService.shared

    @State private var email = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: .spacingXL) {
                        // Header
                        VStack(spacing: .spacingM) {
                            Image(systemName: "lock.rotation")
                                .font(.system(size: 60))
                                .foregroundStyle(Color.footballAccent)

                            Text("Reset Password")
                                .font(.heading2)
                                .fontWeight(.bold)

                            Text("Enter your email address and we'll send you a link to reset your password")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, .spacingXL)
                        .padding(.horizontal, .spacingXL)

                        // Email field
                        VStack(spacing: .spacingL) {
                            VStack(alignment: .leading, spacing: .spacingS) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                TextField("Enter your email", text: $email)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }

                            // Error message
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .padding(.spacingS)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                            }

                            // Success message
                            if let successMessage = successMessage {
                                Text(successMessage)
                                    .font(.caption)
                                    .foregroundStyle(.green)
                                    .padding(.spacingS)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                            }

                            // Send reset link button
                            Button {
                                Task {
                                    await resetPassword()
                                }
                            } label: {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Send Reset Link")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.footballAccent)
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                            }
                            .disabled(isLoading || email.isEmpty)
                            .opacity(email.isEmpty ? 0.6 : 1.0)
                        }
                        .padding(.horizontal, .spacingXL)

                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Methods

    private func resetPassword() async {
        errorMessage = nil
        successMessage = nil
        isLoading = true

        do {
            try await authService.resetPassword(email: email)
            successMessage = "Password reset link sent! Check your email."

            // Auto-dismiss after 2 seconds
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

// MARK: - Preview

#Preview("Forgot Password View") {
    ForgotPasswordView()
}
