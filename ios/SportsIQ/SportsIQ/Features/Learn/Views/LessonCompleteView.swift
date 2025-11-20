//
//  LessonCompleteView.swift
//  SportsIQ
//
//  Created on 2025-11-20.
//

import SwiftUI

struct LessonCompleteView: View {
    let lesson: Lesson
    let correctAnswers: Int
    let totalQuestions: Int
    let xpEarned: Int
    let onDismiss: () -> Void
    
    @State private var showContent = false
    
    var accuracy: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(totalQuestions)) * 100)
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            
            // Confetti Background
            CelebrationView()
                .ignoresSafeArea()
            
            VStack(spacing: .spacingXL) {
                Spacer()
                
                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.brandPrimary)
                }
                .scaleEffect(showContent ? 1 : 0.5)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContent)
                
                VStack(spacing: .spacingS) {
                    Text("Lesson Complete!")
                        .font(.heading1)
                        .foregroundStyle(Color.textPrimary)
                    
                    Text(lesson.title)
                        .font(.heading3)
                        .foregroundStyle(Color.textSecondary)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut.delay(0.2), value: showContent)
                
                // Stats Grid
                HStack(spacing: .spacingL) {
                    StatBox(title: "Accuracy", value: "\(accuracy)%", icon: "target")
                    StatBox(title: "XP Earned", value: "+\(xpEarned)", icon: "star.fill")
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut.delay(0.4), value: showContent)
                
                Spacer()
                
                PrimaryButton(title: "Continue", action: onDismiss)
                    .padding(.horizontal, .spacingL)
                    .padding(.bottom, .spacingXL)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut.delay(0.6), value: showContent)
            }
        }
        .onAppear {
            showContent = true
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: .spacingXS) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.brandPrimary)
            
            Text(value)
                .font(.heading2)
                .foregroundStyle(Color.textPrimary)
            
            Text(title)
                .font(.label)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(width: 120, height: 100)
        .background(Color.backgroundSecondary)
        .cornerRadius(.radiusL)
    }
}

#Preview {
    LessonCompleteView(
        lesson: .footballBasicsLesson1,
        correctAnswers: 8,
        totalQuestions: 10,
        xpEarned: 150,
        onDismiss: {}
    )
}
