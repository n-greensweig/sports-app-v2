//
//  FootballFieldBackground.swift
//  Ola Ball
//
//  A stylized football field background that creates an immersive
//  "journey down the field" experience for the lesson path.
//

import SwiftUI

struct FootballFieldBackground: View {
    let totalHeight: CGFloat
    let scrollOffset: CGFloat
    let sportColor: Color

    // Field configuration
    private let endZoneHeight: CGFloat = 80

    // Parallax factor (0.5 = moves at half scroll speed)
    private let parallaxFactor: CGFloat = 0.5

    // Colors - more visible but still not overwhelming
    private let fieldGreen = Color(red: 0.15, green: 0.45, blue: 0.15) // Darker turf green
    private let fieldGreenLight = Color(red: 0.18, green: 0.50, blue: 0.18) // Lighter stripe

    private var parallaxOffset: CGFloat {
        scrollOffset * parallaxFactor
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            ZStack {
                // Base field color
                fieldGreen.opacity(0.08)

                // Layer 1: Alternating grass stripes (mow pattern)
                grassStripes(width: width)

                // Layer 2: Sideline borders
                sidelines(width: width)

                // Layer 3: Yard lines and numbers
                yardLines(width: width)

                // Layer 4: Hash marks in the center
                centerHashMarks(width: width)

                // Layer 5: End zones
                endZones(width: width)
            }
            .offset(y: parallaxOffset)
        }
        .frame(height: totalHeight)
        .clipped()
    }

    // MARK: - Grass Stripes (Mow Pattern)

    @ViewBuilder
    private func grassStripes(width: CGFloat) -> some View {
        let stripeHeight: CGFloat = 60 // Each stripe is about 5 yards
        let stripeCount = Int(ceil(totalHeight / stripeHeight)) + 4

        VStack(spacing: 0) {
            ForEach(0..<stripeCount, id: \.self) { index in
                Rectangle()
                    .fill(index % 2 == 0 ? fieldGreen.opacity(0.06) : fieldGreenLight.opacity(0.10))
                    .frame(height: stripeHeight)
            }
        }
        .frame(width: width)
    }

    // MARK: - Sidelines

    @ViewBuilder
    private func sidelines(width: CGFloat) -> some View {
        HStack {
            // Left sideline
            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 3)
                .padding(.leading, 16)

            Spacer()

            // Right sideline
            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 3)
                .padding(.trailing, 16)
        }
        .frame(height: totalHeight)
    }

    // MARK: - Yard Lines

    @ViewBuilder
    private func yardLines(width: CGFloat) -> some View {
        // Space yard lines evenly based on total height
        // Show yard lines every ~120pt representing 10 yards each
        let yardLineSpacing: CGFloat = 120
        let lineCount = Int(totalHeight / yardLineSpacing)

        // Yard numbers cycle: 10, 20, 30, 40, 50, 40, 30, 20, 10, G, 10, 20...
        let yardSequence = [10, 20, 30, 40, 50, 40, 30, 20, 10, 0] // 0 = goal line

        ForEach(0..<lineCount, id: \.self) { index in
            let yPosition = CGFloat(index) * yardLineSpacing + endZoneHeight
            let yardIndex = index % yardSequence.count
            let yardNumber = yardSequence[yardIndex]
            let isMidfield = yardNumber == 50
            let isGoalLine = yardNumber == 0

            // Yard line
            yardLine(
                width: width,
                yardNumber: yardNumber,
                isMidfield: isMidfield,
                isGoalLine: isGoalLine
            )
            .position(x: width / 2, y: yPosition)
        }
    }

    @ViewBuilder
    private func yardLine(width: CGFloat, yardNumber: Int, isMidfield: Bool, isGoalLine: Bool) -> some View {
        let lineWidth = width - 40 // Leave room for sidelines
        let lineOpacity = isMidfield ? 0.28 : (isGoalLine ? 0.22 : 0.18)
        let lineHeight: CGFloat = isMidfield ? 2.5 : 2
        let numberOpacity = isMidfield ? 0.25 : 0.18
        let fontSize: CGFloat = isMidfield ? 28 : 24

        // Split the yard number into tens and ones digits
        let tensDigit = yardNumber / 10
        let onesDigit = yardNumber % 10

        ZStack {
            // THE YARD LINE (runs horizontally across the field)
            Rectangle()
                .fill(Color.white.opacity(lineOpacity))
                .frame(width: lineWidth, height: lineHeight)

            // Numbers on both sides - digits split by the yard line
            // Left side: rotated -90° (CCW), so ones digit on top, tens on bottom to read as "20"
            // Right side: rotated +90° (CW), so tens digit on top, ones on bottom to read as "20"
            if yardNumber > 0 {
                HStack {
                    // LEFT SIDE - Ones on top, tens on bottom (reads correctly when rotated -90°)
                    ZStack {
                        // Ones digit - ABOVE the line
                        Text("\(onesDigit)")
                            .font(.system(size: fontSize, weight: .heavy, design: .default))
                            .foregroundStyle(Color.white.opacity(numberOpacity))
                            .rotationEffect(.degrees(-90))
                            .offset(y: -20)

                        // Tens digit - BELOW the line
                        Text("\(tensDigit)")
                            .font(.system(size: fontSize, weight: .heavy, design: .default))
                            .foregroundStyle(Color.white.opacity(numberOpacity))
                            .rotationEffect(.degrees(-90))
                            .offset(y: 20)
                    }
                    .padding(.leading, 24)

                    Spacer()

                    // RIGHT SIDE - Tens on top, ones on bottom (reads correctly when rotated +90°)
                    ZStack {
                        // Tens digit - ABOVE the line
                        Text("\(tensDigit)")
                            .font(.system(size: fontSize, weight: .heavy, design: .default))
                            .foregroundStyle(Color.white.opacity(numberOpacity))
                            .rotationEffect(.degrees(90))
                            .offset(y: -20)

                        // Ones digit - BELOW the line
                        Text("\(onesDigit)")
                            .font(.system(size: fontSize, weight: .heavy, design: .default))
                            .foregroundStyle(Color.white.opacity(numberOpacity))
                            .rotationEffect(.degrees(90))
                            .offset(y: 20)
                    }
                    .padding(.trailing, 24)
                }
            }
        }
        .frame(width: width, height: 70)
    }

    // MARK: - Center Hash Marks

    @ViewBuilder
    private func centerHashMarks(width: CGFloat) -> some View {
        // Hash marks are small perpendicular lines between yard lines
        let hashSpacing: CGFloat = 12 // Every yard
        let hashCount = Int(totalHeight / hashSpacing)

        let leftHashX = width * 0.35
        let rightHashX = width * 0.65

        ForEach(0..<hashCount, id: \.self) { index in
            let yPosition = CGFloat(index) * hashSpacing

            // Left hash
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 12, height: 1.5)
                .position(x: leftHashX, y: yPosition)

            // Right hash
            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 12, height: 1.5)
                .position(x: rightHashX, y: yPosition)
        }
    }

    // MARK: - End Zones

    @ViewBuilder
    private func endZones(width: CGFloat) -> some View {
        let endZoneWidth = width - 32

        // Top end zone (START)
        VStack(spacing: 0) {
            ZStack {
                // End zone fill with diagonal pattern
                RoundedRectangle(cornerRadius: 12)
                    .fill(sportColor.opacity(0.12))

                // Diagonal stripe pattern
                EndZoneStripes()
                    .fill(sportColor.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                // END ZONE text
                Text("END ZONE")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .tracking(6)
                    .foregroundStyle(Color.white.opacity(0.18))
            }
            .frame(width: endZoneWidth, height: endZoneHeight - 10)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)

        // Bottom end zone (GOAL) - positioned at bottom
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(sportColor.opacity(0.15))

                EndZoneStripes()
                    .fill(sportColor.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.white.opacity(0.20))

                    Text("GOAL")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .tracking(6)
                        .foregroundStyle(Color.white.opacity(0.20))
                }
            }
            .frame(width: endZoneWidth, height: endZoneHeight - 10)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .frame(height: totalHeight)
    }
}

// MARK: - End Zone Diagonal Stripes Shape

struct EndZoneStripes: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let stripeWidth: CGFloat = 20
        let spacing: CGFloat = 30

        var x: CGFloat = -rect.height // Start off-screen to cover diagonal
        while x < rect.width + rect.height {
            path.move(to: CGPoint(x: x, y: rect.height))
            path.addLine(to: CGPoint(x: x + rect.height, y: 0))
            path.addLine(to: CGPoint(x: x + rect.height + stripeWidth, y: 0))
            path.addLine(to: CGPoint(x: x + stripeWidth, y: rect.height))
            path.closeSubpath()
            x += spacing + stripeWidth
        }

        return path
    }
}

// MARK: - Preview

#Preview("Football Field Background") {
    ScrollView {
        ZStack {
            FootballFieldBackground(
                totalHeight: 2000,
                scrollOffset: 0,
                sportColor: Color(hex: "#2E7D32") ?? .green
            )

            // Simulate lesson nodes
            VStack(spacing: 94) {
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(Color(hex: "#2E7D32") ?? .green)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "football.fill")
                                .foregroundStyle(.white)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                }
            }
            .padding(.top, 100)
        }
    }
    .background(Color.white)
}

#Preview("Field Only") {
    FootballFieldBackground(
        totalHeight: 800,
        scrollOffset: 0,
        sportColor: Color(hex: "#2E7D32") ?? .green
    )
    .background(Color.white)
}

#Preview("With Parallax Simulation") {
    @Previewable @State var offset: CGFloat = 0

    VStack {
        FootballFieldBackground(
            totalHeight: 1200,
            scrollOffset: offset,
            sportColor: Color(hex: "#2E7D32") ?? .green
        )
        .frame(height: 600)
        .clipped()
        .background(Color.white)

        Slider(value: $offset, in: -400...0)
            .padding()

        Text("Scroll offset: \(Int(offset))")
            .font(.caption)
    }
}
