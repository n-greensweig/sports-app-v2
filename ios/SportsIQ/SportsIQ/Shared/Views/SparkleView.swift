//
//  SparkleView.swift
//  Ola Ball
//
//  Small particle burst effect for correct answer feedback
//

import SwiftUI

struct SparkleView: View {
    let color: Color

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                SparkleParticle(
                    angle: Double(index) * 45,
                    color: color
                )
            }
        }
        .frame(width: 60, height: 60)
    }
}

struct SparkleParticle: View {
    let angle: Double
    let color: Color

    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 1
    @State private var distance: CGFloat = 0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 6, height: 6)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(
                x: distance * CGFloat(cos(angle * .pi / 180)),
                y: distance * CGFloat(sin(angle * .pi / 180))
            )
            .onAppear {
                withAnimation(.easeOut(duration: 0.35)) {
                    scale = 1.0
                    distance = 25
                }
                withAnimation(.easeIn(duration: 0.25).delay(0.15)) {
                    opacity = 0
                    scale = 0.3
                }
            }
    }
}

#Preview("Sparkle Effect") {
    VStack(spacing: 40) {
        SparkleView(color: .green)
        SparkleView(color: .blue)
        SparkleView(color: .orange)
    }
}
