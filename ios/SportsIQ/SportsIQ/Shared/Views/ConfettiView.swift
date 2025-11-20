//
//  ConfettiView.swift
//  SportsIQ
//
//  Created on 2025-11-20.
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { _ in
                ConfettiParticle()
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiParticle: View {
    @State private var location: CGPoint = CGPoint(x: 0, y: 0)
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    // Random properties
    let color: Color = [.red, .blue, .green, .yellow, .orange, .purple, .pink].randomElement()!
    let size: CGFloat = CGFloat.random(in: 5...10)
    let shape: Int = Int.random(in: 0...2) // 0: circle, 1: square, 2: capsule
    
    var body: some View {
        Group {
            if shape == 0 {
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
            } else if shape == 1 {
                Rectangle()
                    .fill(color)
                    .frame(width: size, height: size)
            } else {
                Capsule()
                    .fill(color)
                    .frame(width: size, height: size * 2)
            }
        }
        .position(location)
        .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .onAppear {
            withAnimation(Animation.timingCurve(0.1, 0.8, 0.2, 1, duration: Double.random(in: 2...4)).repeatForever(autoreverses: false)) {
                // Start from top (random x)
                let startX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                location = CGPoint(x: startX, y: -50)
                
                // End at bottom (random x offset)
                let endX = startX + CGFloat.random(in: -100...100)
                let endY = UIScreen.main.bounds.height + 50
                
                // Animate to end position
                // Note: This is a simplified animation. For complex physics, we'd need a Canvas or SpriteKit.
                // But for a simple "ConfettiView", we can just animate state changes if we want a continuous fall,
                // or use a GeometryReader to set initial positions.
                
                // Actually, let's use a GeometryEffect or just simple transition for "burst" style if we want.
                // But for a "rain" style, we need a timer or continuous animation.
            }
        }
    }
}

// Improved Confetti Implementation using GeometryEffect for better performance
struct ConfettiGeometryEffect: GeometryEffect {
    var time: Double
    var speed: Double = Double.random(in: 50...200)
    var xSpeed: Double = Double.random(in: -50...50)
    var rotationSpeed: Double = Double.random(in: 0...360)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = xSpeed * time
        let yTranslation = speed * time
        let rotation = rotationSpeed * time
        
        let transform = CGAffineTransform(translationX: xTranslation, y: yTranslation)
            .rotated(by: CGFloat(Angle(degrees: rotation).radians))
        
        return ProjectionTransform(transform)
    }
}

struct CelebrationView: View {
    @State private var counter = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(counter: counter)
            }
        }
        .onAppear {
            counter += 1
        }
    }
}

struct ConfettiPiece: View {
    let counter: Int
    @State private var yPosition: CGFloat = -50
    @State private var xPosition: CGFloat = CGFloat.random(in: 0...UIScreen.main.bounds.width)
    @State private var rotation: Double = Double.random(in: 0...360)
    
    let color: Color = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan].randomElement()!
    let size: CGFloat = CGFloat.random(in: 8...12)
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .position(x: xPosition, y: yPosition)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.easeOut(duration: Double.random(in: 1.5...3.0))) {
                    yPosition = UIScreen.main.bounds.height + 50
                    xPosition += CGFloat.random(in: -50...50)
                    rotation += 180
                }
            }
    }
}
