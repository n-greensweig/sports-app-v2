//
//  SignUpView.swift
//  SportsIQ
//
//  Created by Claude on 2025-11-17.
//  Task 8: Authentication Integration
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @State private var authService = AuthService.shared

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentNonce: String?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.footballAccent.opacity(0.1), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: .spacingXL) {
                        // Header
                        VStack(spacing: .spacingM) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 60))
                                .foregroundStyle(Color.footballAccent)

                            Text("Create Account")
                                .font(.heading1)
                                .fontWeight(.bold)

                            Text("Join the SportsIQ community")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, .spacingL)

                        // Sign up form
                        VStack(spacing: .spacingL) {
                            // Username field
                            VStack(alignment: .leading, spacing: .spacingS) {
                                Text("Username")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                TextField("Choose a username", text: $username)
                                    .textContentType(.username)
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

                            // Email field
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

                            // Password field
                            VStack(alignment: .leading, spacing: .spacingS) {
                                Text("Password")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                SecureField("Create a password", text: $password)
                                    .textContentType(.newPassword)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )

                                // Password requirements
                                Text("At least 8 characters")
                                    .font(.caption)
                                    .foregroundStyle(password.count >= 8 ? .green : .secondary)
                            }

                            // Confirm password field
                            VStack(alignment: .leading, spacing: .spacingS) {
                                Text("Confirm Password")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textContentType(.newPassword)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                passwordsMatch ? Color.gray.opacity(0.2) : Color.red.opacity(0.5),
                                                lineWidth: 1
                                            )
                                    )

                                if !confirmPassword.isEmpty && !passwordsMatch {
                                    Text("Passwords do not match")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
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

                            // Sign up button
                            Button {
                                Task {
                                    await signUp()
                                }
                            } label: {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Create Account")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.footballAccent)
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                            }
                            .disabled(isLoading || !isFormValid)
                            .opacity(isFormValid ? 1.0 : 0.6)
                        }
                        .padding(.horizontal, .spacingXL)

                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            Text("OR")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, .spacingXL)

                        // Social sign up
                        VStack(spacing: .spacingM) {
                            // Sign up with Apple
                            SignInWithAppleButton(.signUp) { request in
                                let nonce = CryptoUtils.randomNonceString()
                                currentNonce = nonce
                                request.requestedScopes = [.fullName, .email]
                                request.nonce = CryptoUtils.sha256(nonce)
                            } onCompletion: { result in
                                Task {
                                    await handleAppleSignUp(result)
                                }
                            }
                            .signInWithAppleButtonStyle(.black)
                            .frame(height: 50)
                            .cornerRadius(12)

                            // Sign up with Google (placeholder)
                            Button {
                                errorMessage = "Google Sign Up coming soon!"
                            } label: {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                    Text("Sign up with Google")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemBackground))
                                .foregroundStyle(.primary)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, .spacingXL)

                        // Terms and privacy
                        Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
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

    // MARK: - Computed Properties

    private var passwordsMatch: Bool {
        password == confirmPassword
    }

    private var isFormValid: Bool {
        !username.isEmpty &&
        !email.isEmpty &&
        password.count >= 8 &&
        passwordsMatch
    }

    // MARK: - Methods

    private func signUp() async {
        errorMessage = nil
        isLoading = true

        do {
            _ = try await authService.signUp(
                email: email,
                password: password,
                username: username
            )
            // AuthService will update the auth state, which will trigger navigation
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func handleAppleSignUp(_ result: Result<ASAuthorization, Error>) async {
        errorMessage = nil
        isLoading = true

        do {
            guard case .success(let authorization) = result,
                  let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                throw AuthError.invalidAppleCredential
            }

            guard let nonce = currentNonce else {
                throw AuthError.invalidAppleCredential
            }

            _ = try await authService.signInWithApple(credential: credential, nonce: nonce)
            // AuthService will update the auth state, which will trigger navigation
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

// MARK: - Preview

#Preview("Sign Up View") {
    SignUpView()
}
