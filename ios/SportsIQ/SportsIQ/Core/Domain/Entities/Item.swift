//
//  Item.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Type of interactive item in a lesson
enum ItemType: String, Codable, Hashable {
    case mcq = "mcq"                    // Multiple choice (single answer)
    case multiSelect = "multi_select"   // Multiple choice (multiple answers)
    case slider = "slider"              // Slider input
    case freeText = "free_text"         // Text input
    case clipLabel = "clip_label"       // Label parts of a video clip
    case binary = "binary"              // True/False or Yes/No
}

/// Answer options for different item types
enum ItemAnswer: Codable, Hashable, Equatable {
    case single(Int)                // Index of correct option
    case multiple([Int])            // Indices of correct options
    case range(min: Double, max: Double)  // Acceptable range for slider
    case text(String)               // Expected text answer
    case boolean(Bool)              // True/False

    enum CodingKeys: String, CodingKey {
        case type
        case singleValue
        case multipleValue
        case rangeMin
        case rangeMax
        case textValue
        case boolValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "single":
            let value = try container.decode(Int.self, forKey: .singleValue)
            self = .single(value)
        case "multiple":
            let value = try container.decode([Int].self, forKey: .multipleValue)
            self = .multiple(value)
        case "range":
            let min = try container.decode(Double.self, forKey: .rangeMin)
            let max = try container.decode(Double.self, forKey: .rangeMax)
            self = .range(min: min, max: max)
        case "text":
            let value = try container.decode(String.self, forKey: .textValue)
            self = .text(value)
        case "boolean":
            let value = try container.decode(Bool.self, forKey: .boolValue)
            self = .boolean(value)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid answer type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .single(let value):
            try container.encode("single", forKey: .type)
            try container.encode(value, forKey: .singleValue)
        case .multiple(let value):
            try container.encode("multiple", forKey: .type)
            try container.encode(value, forKey: .multipleValue)
        case .range(let min, let max):
            try container.encode("range", forKey: .type)
            try container.encode(min, forKey: .rangeMin)
            try container.encode(max, forKey: .rangeMax)
        case .text(let value):
            try container.encode("text", forKey: .type)
            try container.encode(value, forKey: .textValue)
        case .boolean(let value):
            try container.encode("boolean", forKey: .type)
            try container.encode(value, forKey: .boolValue)
        }
    }
}

/// A learning item (question/exercise) within a lesson
struct Item: Identifiable, Codable, Hashable {
    let id: UUID
    let lessonId: UUID
    let type: ItemType
    let orderIndex: Int
    let prompt: String
    let options: [String]?          // For MCQ, multi-select
    let correctAnswer: ItemAnswer
    let explanation: String?        // Shown after answer
    let mediaURL: String?           // Optional image/video URL
    let xpValue: Int                // XP awarded for correct answer

    init(
        id: UUID,
        lessonId: UUID,
        type: ItemType,
        orderIndex: Int,
        prompt: String,
        options: [String]? = nil,
        correctAnswer: ItemAnswer,
        explanation: String? = nil,
        mediaURL: String? = nil,
        xpValue: Int = 10
    ) {
        self.id = id
        self.lessonId = lessonId
        self.type = type
        self.orderIndex = orderIndex
        self.prompt = prompt
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.mediaURL = mediaURL
        self.xpValue = xpValue
    }
}

// MARK: - Mock Data
extension Item {
    static let mockMCQ = Item(
        id: UUID(),
        lessonId: UUID(),
        type: .mcq,
        orderIndex: 1,
        prompt: "How many players are on the field for one team in American Football?",
        options: ["9", "11", "12", "15"],
        correctAnswer: .single(1),
        explanation: "Each team has 11 players on the field at a time.",
        xpValue: 10
    )

    static let mockBinary = Item(
        id: UUID(),
        lessonId: UUID(),
        type: .binary,
        orderIndex: 2,
        prompt: "A touchdown is worth 6 points.",
        options: ["True", "False"],
        correctAnswer: .boolean(true),
        explanation: "That's correct! A touchdown is worth 6 points, with the opportunity for an extra point or 2-point conversion.",
        xpValue: 10
    )

    static let mockMultiSelect = Item(
        id: UUID(),
        lessonId: UUID(),
        type: .multiSelect,
        orderIndex: 3,
        prompt: "Which of these are ways to score in football? Select all that apply.",
        options: ["Touchdown", "Field Goal", "Home Run", "Safety", "Grand Slam"],
        correctAnswer: .multiple([0, 1, 3]),
        explanation: "Touchdown, Field Goal, and Safety are all valid ways to score in football. Home Run and Grand Slam are baseball terms.",
        xpValue: 15
    )

    static let mockSlider = Item(
        id: UUID(),
        lessonId: UUID(),
        type: .slider,
        orderIndex: 4,
        prompt: "How many yards is the football field (excluding end zones)?",
        options: nil,
        correctAnswer: .range(min: 95, max: 105),
        explanation: "The football field is 100 yards long, not including the 10-yard end zones on each end.",
        xpValue: 10
    )

    static let mockFreeText = Item(
        id: UUID(),
        lessonId: UUID(),
        type: .freeText,
        orderIndex: 5,
        prompt: "What is the name of the championship game in the NFL?",
        options: nil,
        correctAnswer: .text("Super Bowl"),
        explanation: "The Super Bowl is the annual championship game of the National Football League (NFL).",
        xpValue: 10
    )

    static let mockItems = [mockMCQ, mockBinary, mockMultiSelect, mockSlider, mockFreeText]
}
