//
//  LoginView.swift
//  Ola Ball
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
    @State private var currentNonce: String?

    // Animation states
    @State private var showContent = false
    @State private var heroFloat: CGFloat = 0
    @State private var showSparkle = false
    @State private var triggerShake = false
    @State private var showSuccessSparkle = false
    @State private var isEmailFocused = false
    @State private var isPasswordFocused = false

    // Computed properties
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient Background
                backgroundView

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: .spacingL)

                    // Animated Logo/Header
                    heroSection

                    Spacer()
                        .frame(height: .spacingL)

                    // Email/Password Form
                    formSection
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(0.2), value: showContent)

                    Spacer()
                        .frame(height: .spacingM)

                    // Divider
                    dividerSection
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.4).delay(0.3), value: showContent)

                    Spacer()
                        .frame(height: .spacingM)

                    // Social sign in
                    socialSignInSection
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(0.4), value: showContent)

                    Spacer()

                    // Sign up link
                    signUpLinkSection
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.4).delay(0.5), value: showContent)
                        .padding(.bottom, .spacingL)
                }

                // Success sparkle overlay
                if showSuccessSparkle {
                    SparkleView(color: .brandPrimary)
                        .scaleEffect(2)
                }
            }
            .screenShake(trigger: $triggerShake, intensity: 8)
            .navigationBarHidden(true)
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
            .onAppear {
                startAnimations()
            }
        }
    }

    // MARK: - View Components

    private var backgroundView: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color.brandPrimary.opacity(0.06),
                    Color.backgroundPrimary
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Floating decorative circles
            floatingCircles
        }
    }

    private var floatingCircles: some View {
        GeometryReader { geometry in
            ZStack {
                // Top-right circle
                Circle()
                    .fill(Color.brandPrimary.opacity(0.04))
                    .frame(width: 200, height: 200)
                    .blur(radius: 60)
                    .offset(x: geometry.size.width * 0.3, y: -50 + heroFloat * 0.5)

                // Bottom-left circle
                Circle()
                    .fill(Color.brandPrimary.opacity(0.03))
                    .frame(width: 150, height: 150)
                    .blur(radius: 50)
                    .offset(x: -geometry.size.width * 0.3, y: geometry.size.height * 0.6 - heroFloat * 0.3)
            }
        }
        .ignoresSafeArea()
    }

    private var heroSection: some View {
        VStack(spacing: .spacingS) {
            ZStack {
                // Glow behind trophy
                Circle()
                    .fill(Color.brandPrimary.opacity(0.08))
                    .frame(width: 80, height: 80)
                    .blur(radius: 15)

                // Trophy icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.brandPrimary)
                    .offset(y: heroFloat)

                // Sparkle effect
                if showSparkle {
                    SparkleView(color: .brandPrimary)
                        .offset(y: heroFloat)
                }
            }
            .scaleEffect(showContent ? 1 : 0.5)
            .opacity(showContent ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContent)

            Text("Ola Ball")
                .font(.heading2)
                .fontWeight(.bold)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 10)
                .animation(.easeOut(duration: 0.4).delay(0.1), value: showContent)
        }
    }

    private var formSection: some View {
        VStack(spacing: .spacingM) {
            // Email field
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(.spacingM)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isEmailFocused ? Color.brandPrimary.opacity(0.5) : Color.gray.opacity(0.15), lineWidth: 1)
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEmailFocused = true
                        isPasswordFocused = false
                    }
                }

            // Password field
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding(.spacingM)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isPasswordFocused ? Color.brandPrimary.opacity(0.5) : Color.gray.opacity(0.15), lineWidth: 1)
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPasswordFocused = true
                        isEmailFocused = false
                    }
                }

            // Forgot password
            Button {
                HapticManager.shared.playSelectionFeedback()
                showForgotPassword = true
            } label: {
                Text("Forgot password?")
                    .font(.caption)
                    .foregroundStyle(Color.brandPrimary)
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
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }

            // Sign in button
            signInButton
        }
        .padding(.horizontal, .spacingL)
    }

    private var signInButton: some View {
        Button {
            HapticManager.shared.playSelectionFeedback()
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
            .frame(height: 44)
            .background(Color.brandPrimary)
            .foregroundStyle(.white)
            .cornerRadius(12)
        }
        .disabled(isLoading || !isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
    }

    private var dividerSection: some View {
        HStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            Text("or")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.horizontal, .spacingS)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
        }
        .padding(.horizontal, .spacingL)
    }

    private var socialSignInSection: some View {
        VStack(spacing: .spacingS) {
            // Sign in with Apple
            SignInWithAppleButton(.signIn) { request in
                let nonce = CryptoUtils.randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = CryptoUtils.sha256(nonce)
            } onCompletion: { result in
                HapticManager.shared.playSelectionFeedback()
                Task {
                    await handleAppleSignIn(result)
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 44)
            .cornerRadius(12)

            // Sign in with Google
            Button {
                HapticManager.shared.playSelectionFeedback()
                Task {
                    await handleGoogleSignIn()
                }
            } label: {
                HStack(spacing: .spacingS) {
                    Image(systemName: "g.circle.fill")
                        .font(.title3)
                    Text("Sign in with Google")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color(.systemBackground))
                .foregroundStyle(.primary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }

            // Continue as Guest
            guestModeSection
        }
        .padding(.horizontal, .spacingL)
    }

    private var guestModeSection: some View {
        VStack(spacing: .spacingXS) {
            Button {
                HapticManager.shared.playSelectionFeedback()
                authService.continueAsGuest()
            } label: {
                Text("Continue as Guest")
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }

            Text("Progress saved locally. Create an account to sync across devices.")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
    }

    private var signUpLinkSection: some View {
        HStack {
            Text("Don't have an account?")
                .foregroundStyle(.secondary)
            Button("Sign Up") {
                HapticManager.shared.playSelectionFeedback()
                showSignUp = true
            }
            .fontWeight(.semibold)
            .foregroundStyle(Color.brandPrimary)
        }
        .font(.body)
    }

    // MARK: - Animation Methods

    private func startAnimations() {
        // Trigger content reveal
        withAnimation {
            showContent = true
        }

        // Sparkle burst after trophy appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showSparkle = true
        }

        // Start floating animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(
                .easeInOut(duration: 2.5)
                .repeatForever(autoreverses: true)
            ) {
                heroFloat = -6
            }
        }
    }

    // MARK: - Methods

    private func signIn() async {
        errorMessage = nil
        isLoading = true

        do {
            _ = try await authService.signIn(email: email, password: password)
            // Success feedback
            await MainActor.run {
                showSuccessSparkle = true
                HapticManager.shared.playCorrectFeedback()
            }
            // AuthService will update the auth state, which will trigger navigation
        } catch {
            await MainActor.run {
                withAnimation {
                    errorMessage = error.localizedDescription
                }
                triggerShake = true
                HapticManager.shared.playIncorrectFeedback()
            }
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

            guard let nonce = currentNonce else {
                throw AuthError.invalidAppleCredential
            }

            _ = try await authService.signInWithApple(credential: credential, nonce: nonce)
            // Success feedback
            await MainActor.run {
                showSuccessSparkle = true
                HapticManager.shared.playCorrectFeedback()
            }
        } catch {
            await MainActor.run {
                withAnimation {
                    errorMessage = error.localizedDescription
                }
                triggerShake = true
                HapticManager.shared.playIncorrectFeedback()
            }
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

            // Success feedback
            await MainActor.run {
                showSuccessSparkle = true
                HapticManager.shared.playCorrectFeedback()
            }
        } catch {
            await MainActor.run {
                withAnimation {
                    errorMessage = error.localizedDescription
                }
                triggerShake = true
                HapticManager.shared.playIncorrectFeedback()
            }
            #if DEBUG
            print("DEBUG: Google Sign In Error: \(error)")
            #endif
        }

        isLoading = false
    }
}

// MARK: - Preview

#Preview("Login View") {
    LoginView()
}
