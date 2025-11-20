//
//  LoginView.swift
//  SportsIQ
//
//  Created by Claude on 2025-11-17.
//  Task 8: Authentication Integration
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @State private var authService = AuthService.shared

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSignUp = false
    @State private var showForgotPassword = false

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
                        // Logo and title
                        VStack(spacing: .spacingM) {
                            Image(systemName: "sportscourt.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(Color.footballAccent)

                            Text("SportsIQ")
                                .font(.heading1)
                                .fontWeight(.bold)

                            Text("Learn sports the smart way")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, .spacingXXL)

                        // Email/Password Form
                        VStack(spacing: .spacingL) {
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

                                SecureField("Enter your password", text: $password)
                                    .textContentType(.password)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            }

                            // Forgot password
                            Button {
                                showForgotPassword = true
                            } label: {
                                Text("Forgot password?")
                                    .font(.caption)
                                    .foregroundStyle(Color.footballAccent)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)

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

                            // Sign in button
                            Button {
                                Task {
                                    await signIn()
                                }
                            } label: {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Sign In")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.footballAccent)
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                            }
                            .disabled(isLoading || email.isEmpty || password.isEmpty)
                            .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
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

                        // Social sign in
                        VStack(spacing: .spacingM) {
                            // Sign in with Apple
                            SignInWithAppleButton(.signIn) { request in
                                request.requestedScopes = [.fullName, .email]
                            } onCompletion: { result in
                                Task {
                                    await handleAppleSignIn(result)
                                }
                            }
                            .signInWithAppleButtonStyle(.black)
                            .frame(height: 50)
                            .cornerRadius(12)

                            // Sign in with Google
                            Button {
                                Task {
                                    await handleGoogleSignIn()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "g.circle.fill")
                                    Text("Sign in with Google")
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

                        // Sign up link
                        HStack {
                            Text("Don't have an account?")
                                .foregroundStyle(.secondary)
                            Button("Sign Up") {
                                showSignUp = true
                            }
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.footballAccent)
                        }
                        .font(.body)

                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }

    // MARK: - Methods

    private func signIn() async {
        errorMessage = nil
        isLoading = true

        do {
            _ = try await authService.signIn(email: email, password: password)
            // AuthService will update the auth state, which will trigger navigation
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) async {
        errorMessage = nil
        isLoading = true

        do {
            guard case .success(let authorization) = result,
                  let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                throw AuthError.invalidAppleCredential
            }

            _ = try await authService.signInWithApple(credential: credential)
            // AuthService will update the auth state, which will trigger navigation
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func handleGoogleSignIn() async {
        errorMessage = nil
        isLoading = true

        do {
            // 1. Sign in with Google SDK
            let (idToken, nonce) = try await GoogleSignInManager.shared.signIn()

            // 2. Sign in with Supabase using the ID token and nonce
            _ = try await authService.signInWithGoogle(idToken: idToken, nonce: nonce)
            
            // AuthService will update the auth state, which will trigger navigation
        } catch {
            errorMessage = error.localizedDescription
            // Also print to console for debugging
            print("DEBUG: Google Sign In Error: \(error)")
        }

        isLoading = false
    }
}

// MARK: - Preview

#Preview("Login View") {
    LoginView()
}
