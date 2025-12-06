//
//  ScreenShakeModifier.swift
//  Ola Ball
//
//  Created for Engagement Features
//

import SwiftUI

/// A view modifier that applies a screen shake animation
struct ScreenShakeModifier: ViewModifier {
    @Binding var trigger: Bool
    var intensity: CGFloat
    var duration: Double

    @State private var offset: CGFloat = 0

    init(trigger: Binding<Bool>, intensity: CGFloat = 10, duration: Double = 0.5) {
        self._trigger = trigger
        self.intensity = intensity
        self.duration = duration
    }

    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .onChange(of: trigger) { _, newValue in
                if newValue {
                    performShake()
                }
            }
    }

    private func performShake() {
        let animation = Animation
            .spring(response: 0.1, dampingFraction: 0.2)
            .repeatCount(5, autoreverses: true)

        withAnimation(animation) {
            offset = intensity
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                offset = 0
            }
            trigger = false
        }
    }
}

extension View {
    /// Applies a screen shake animation when trigger becomes true
    func screenShake(trigger: Binding<Bool>, intensity: CGFloat = 10, duration: Double = 0.5) -> some View {
        modifier(ScreenShakeModifier(trigger: trigger, intensity: intensity, duration: duration))
    }
}

#Preview("Screen Shake") {
    struct PreviewWrapper: View {
        @State private var shake = false

        var body: some View {
            VStack(spacing: 40) {
                Text("Shake Me!")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
                    .screenShake(trigger: $shake, intensity: 15)

                Button("Trigger Shake") {
                    shake = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    return PreviewWrapper()
}
