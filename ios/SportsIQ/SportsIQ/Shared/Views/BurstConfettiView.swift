//
//  BurstConfettiView.swift
//  Ola Ball
//
//  Created for Engagement Features
//

import SwiftUI

/// Enhanced confetti view that bursts from center with customizable intensity
struct BurstConfettiView: View {
    let intensity: CelebrationIntensity

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<intensity.particleCount, id: \.self) { index in
                    BurstParticle(
                        delay: Double(index) * 0.008,
                        screenSize: geometry.size
                    )
                }
            }
        }
    }
}

struct BurstParticle: View {
    let delay: Double
    let screenSize: CGSize

    @State private var position: CGPoint = .zero
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1

    private let color: Color
    private let size: CGFloat
    private let shapeType: Int

    init(delay: Double, screenSize: CGSize) {
        self.delay = delay
        self.screenSize = screenSize

        let colors: [Color] = [
            .red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan, .mint
        ]
        self.color = colors.randomElement()!
        self.size = CGFloat.random(in: 8...14)
        self.shapeType = Int.random(in: 0...2)
    }

    var body: some View {
        Group {
            switch shapeType {
            case 0:
                Circle().fill(color)
            case 1:
                Rectangle().fill(color)
            default:
                Capsule().fill(color)
            }
        }
        .frame(width: size, height: shapeType == 2 ? size * 2 : size)
        .position(position)
        .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .scaleEffect(scale)
        .onAppear {
            animateBurst()
        }
    }

    private func animateBurst() {
        let screenCenter = CGPoint(
            x: screenSize.width / 2,
            y: screenSize.height / 2
        )

        // Start from center
        position = screenCenter

        // Calculate burst direction
        let angle = Double.random(in: 0...360)
        let distance = CGFloat.random(in: 200...500)
        let endX = screenCenter.x + cos(angle * .pi / 180) * distance
        let endY = screenCenter.y + sin(angle * .pi / 180) * distance + CGFloat.random(in: 200...400) // gravity

        // Animate outward
        let duration = Double.random(in: 1.5...2.5)
        withAnimation(.easeOut(duration: duration).delay(delay)) {
            position = CGPoint(x: endX, y: endY)
            rotation = Double.random(in: 180...720)
            opacity = 0
            scale = CGFloat.random(in: 0.3...0.8)
        }
    }
}

#Preview("Burst Confetti - Low") {
    ZStack {
        Color.black.ignoresSafeArea()
        BurstConfettiView(intensity: .low)
    }
}

#Preview("Burst Confetti - High") {
    ZStack {
        Color.black.ignoresSafeArea()
        BurstConfettiView(intensity: .high)
    }
}

#Preview("Burst Confetti - Extreme") {
    ZStack {
        Color.black.ignoresSafeArea()
        BurstConfettiView(intensity: .extreme)
    }
}
