//
//  DashedPathShape.swift
//  Ola Ball
//
//  A SwiftUI Shape that draws a curved dashed path connecting lesson nodes
//

import SwiftUI

/// Shape that draws a smooth curved path through a series of points
/// Used to create the winding dashed line connecting lesson nodes
struct DashedPathShape: Shape {
    let points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard points.count >= 2 else { return path }

        path.move(to: points[0])

        if points.count == 2 {
            // Simple line for just 2 points
            path.addLine(to: points[1])
            return path
        }

        // For 3+ points, use smooth curves
        for i in 1..<points.count {
            let current = points[i]
            let previous = points[i - 1]

            // Calculate control points for smooth bezier curve
            let midY = (previous.y + current.y) / 2

            // Control point 1: horizontally aligned with previous, vertically at midpoint
            let cp1 = CGPoint(x: previous.x, y: midY)

            // Control point 2: horizontally aligned with current, vertically at midpoint
            let cp2 = CGPoint(x: current.x, y: midY)

            path.addCurve(to: current, control1: cp1, control2: cp2)
        }

        return path
    }
}


// MARK: - Preview
#Preview("Dashed Path Shape") {
    let mockPoints: [CGPoint] = [
        CGPoint(x: 200, y: 50),   // center
        CGPoint(x: 248, y: 138),  // right
        CGPoint(x: 280, y: 226),  // farRight
        CGPoint(x: 248, y: 314),  // right
        CGPoint(x: 200, y: 402),  // center
        CGPoint(x: 152, y: 490),  // left
        CGPoint(x: 120, y: 578),  // farLeft
        CGPoint(x: 152, y: 666),  // left
        CGPoint(x: 200, y: 754),  // center
    ]

    ZStack {
        Color.gray.opacity(0.1)

        // Draw the dashed path
        DashedPathShape(points: mockPoints)
            .stroke(
                Color.footballAccent,
                style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [8, 6])
            )

        // Draw node positions for reference
        ForEach(0..<mockPoints.count, id: \.self) { i in
            Circle()
                .fill(Color.footballAccent.opacity(0.3))
                .frame(width: 64, height: 64)
                .position(mockPoints[i])
        }
    }
    .frame(height: 850)
}

#Preview("Dashed Path - Trim Animation") {
    @Previewable @State var progress: CGFloat = 0.0

    let mockPoints: [CGPoint] = [
        CGPoint(x: 200, y: 50),
        CGPoint(x: 248, y: 138),
        CGPoint(x: 280, y: 226),
        CGPoint(x: 248, y: 314),
        CGPoint(x: 200, y: 402),
        CGPoint(x: 152, y: 490),
        CGPoint(x: 120, y: 578),
    ]

    VStack {
        ZStack {
            Color.gray.opacity(0.1)

            DashedPathShape(points: mockPoints)
                .trim(from: 0, to: progress)
                .stroke(
                    Color.footballAccent,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [8, 6])
                )
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: progress)

            ForEach(0..<mockPoints.count, id: \.self) { i in
                Circle()
                    .fill(Color.footballAccent.opacity(0.3))
                    .frame(width: 64, height: 64)
                    .position(mockPoints[i])
            }
        }
        .frame(height: 650)

        Slider(value: $progress, in: 0...1)
            .padding()

        Text("Progress: \(Int(progress * 100))%")
            .font(.caption)
    }
}
