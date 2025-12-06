//
//  YardLinePath.swift
//  Ola Ball
//
//  A dashed path connecting lesson nodes with section-based gradient coloring
//  and scroll-driven animation
//

import SwiftUI

/// A dashed path connecting lesson nodes
/// Features draw-on-scroll animation and section-based color gradients
struct YardLinePath: View {
    /// Edge positions of each lesson node (top/bottom edges, not centers)
    let nodePositions: [CGPoint]

    /// Order indices of lessons (for section color lookup)
    let lessonOrderIndices: [Int]

    /// Current scroll progress (0.0 = top, 1.0 = fully scrolled)
    let scrollProgress: CGFloat

    /// Total number of lessons (for gradient calculation)
    let totalLessons: Int

    // Visual configuration
    private let pathLineWidth: CGFloat = 3
    private let dashLength: CGFloat = 8
    private let dashGap: CGFloat = 6

    var body: some View {
        ZStack {
            // Background path (faded, shows full path ahead)
            backgroundPath

            // Foreground path (animated, shows progress)
            foregroundPath
        }
    }

    // MARK: - Background Path (upcoming lessons)
    private var backgroundPath: some View {
        DashedPathShape(points: nodePositions)
            .stroke(
                Color.backgroundTertiary.opacity(0.4),
                style: StrokeStyle(
                    lineWidth: pathLineWidth,
                    lineCap: .round,
                    dash: [dashLength, dashGap]
                )
            )
    }

    // MARK: - Foreground Path (completed progress)
    private var foregroundPath: some View {
        DashedPathShape(points: nodePositions)
            .trim(from: 0, to: scrollProgress)
            .stroke(
                sectionGradient,
                style: StrokeStyle(
                    lineWidth: pathLineWidth,
                    lineCap: .round,
                    dash: [dashLength, dashGap]
                )
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: scrollProgress)
    }

    // MARK: - Section Gradient
    /// Creates a gradient with color stops based on lesson section boundaries
    private var sectionGradient: LinearGradient {
        let stops = buildGradientStops()

        return LinearGradient(
            stops: stops,
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Builds gradient stops based on section boundaries
    private func buildGradientStops() -> [Gradient.Stop] {
        guard totalLessons > 0 else {
            return [Gradient.Stop(color: .footballAccent, location: 0)]
        }

        var stops: [Gradient.Stop] = []
        let sections = LessonSection.footballRookieSections

        // Find the minimum and maximum order indices we have
        let minOrder = lessonOrderIndices.min() ?? 1
        let maxOrder = lessonOrderIndices.max() ?? totalLessons

        for section in sections {
            // Skip sections outside our lesson range
            guard section.startOrderIndex <= maxOrder && section.endOrderIndex >= minOrder else {
                continue
            }

            // Calculate normalized positions (0 to 1) for this section
            let startProgress = normalizedPosition(for: section.startOrderIndex)
            let endProgress = normalizedPosition(for: section.endOrderIndex)

            // Add start of section
            stops.append(Gradient.Stop(color: section.color, location: startProgress))

            // Add end of section (slightly before to ensure smooth transition)
            if endProgress < 1.0 {
                stops.append(Gradient.Stop(color: section.color, location: endProgress))
            }
        }

        // Ensure we have at least one stop
        if stops.isEmpty {
            stops.append(Gradient.Stop(color: .footballAccent, location: 0))
            stops.append(Gradient.Stop(color: .footballAccent, location: 1))
        }

        // Sort by location and remove duplicates
        stops.sort { $0.location < $1.location }

        return stops
    }

    /// Converts an order index to a normalized position (0 to 1)
    private func normalizedPosition(for orderIndex: Int) -> CGFloat {
        guard totalLessons > 1 else { return 0 }

        // Find which array index corresponds to this order index
        if let arrayIndex = lessonOrderIndices.firstIndex(of: orderIndex) {
            return CGFloat(arrayIndex) / CGFloat(totalLessons - 1)
        }

        // Fallback: estimate position based on order index range
        let minOrder = lessonOrderIndices.min() ?? 1
        let maxOrder = lessonOrderIndices.max() ?? totalLessons

        let normalizedOrder = CGFloat(orderIndex - minOrder) / CGFloat(max(1, maxOrder - minOrder))
        return min(1, max(0, normalizedOrder))
    }
}

// MARK: - Preview
#Preview("Yard Line Path - Full") {
    @Previewable @State var progress: CGFloat = 0.5

    let mockPositions: [CGPoint] = [
        CGPoint(x: 200, y: 80),
        CGPoint(x: 248, y: 168),
        CGPoint(x: 280, y: 256),
        CGPoint(x: 248, y: 344),
        CGPoint(x: 200, y: 432),
        CGPoint(x: 152, y: 520),
        CGPoint(x: 120, y: 608),
        CGPoint(x: 152, y: 696),
        CGPoint(x: 200, y: 784),
        CGPoint(x: 248, y: 872),
    ]

    // Order indices mapping to sections
    let orderIndices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    VStack(spacing: 0) {
        ZStack {
            Color.white

            YardLinePath(
                nodePositions: mockPositions,
                lessonOrderIndices: orderIndices,
                scrollProgress: progress,
                totalLessons: 10
            )

            // Draw node circles for reference
            ForEach(0..<mockPositions.count, id: \.self) { i in
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 64, height: 64)
                    .position(mockPositions[i])

                Text("\(i + 1)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .position(mockPositions[i])
            }
        }
        .frame(height: 950)

        VStack {
            Slider(value: $progress, in: 0...1)
                .padding(.horizontal)

            Text("Scroll Progress: \(Int(progress * 100))%")
                .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

#Preview("Yard Line Path - Section Colors") {
    // Simulate lessons across multiple sections
    let positions: [CGPoint] = (0..<20).map { i in
        let patternIndex = i % 8
        let xOffset: CGFloat = switch patternIndex {
        case 0: 0
        case 1: 48
        case 2: 80
        case 3: 48
        case 4: 0
        case 5: -48
        case 6: -80
        case 7: -48
        default: 0
        }
        return CGPoint(x: 200 + xOffset, y: CGFloat(50 + i * 88))
    }

    // Order indices spanning multiple sections
    let orderIndices = Array(1...20)

    ScrollView {
        ZStack {
            YardLinePath(
                nodePositions: positions,
                lessonOrderIndices: orderIndices,
                scrollProgress: 1.0,
                totalLessons: 20
            )

            // Section labels
            VStack(alignment: .leading, spacing: 0) {
                Text("Section 1: Green")
                    .foregroundStyle(Color(hex: "#2E7D32"))
                    .padding(.top, 30)

                Spacer().frame(height: 200)

                Text("Section 2: Blue")
                    .foregroundStyle(Color(hex: "#1565C0"))

                Spacer().frame(height: 500)

                Text("Section 3: Orange")
                    .foregroundStyle(Color(hex: "#E65100"))

                Spacer()
            }
            .font(.caption)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
        }
        .frame(height: CGFloat(50 + 20 * 88))
    }
}
