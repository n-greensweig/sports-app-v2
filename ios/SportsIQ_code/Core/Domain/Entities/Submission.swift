//
//  Submission.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// User's answer to an item
enum UserAnswer: Codable, Hashable, Equatable {
    case single(Int)                // Selected option index
    case multiple([Int])            // Selected option indices
    case slider(Double)             // Slider value
    case text(String)               // Text input
    case boolean(Bool)              // True/False

    enum CodingKeys: String, CodingKey {
        case type
        case singleValue
        case multipleValue
        case sliderValue
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
        case "slider":
            let value = try container.decode(Double.self, forKey: .sliderValue)
            self = .slider(value)
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
        case .slider(let value):
            try container.encode("slider", forKey: .type)
            try container.encode(value, forKey: .sliderValue)
        case .text(let value):
            try container.encode("text", forKey: .type)
            try container.encode(value, forKey: .textValue)
        case .boolean(let value):
            try container.encode("boolean", forKey: .type)
            try container.encode(value, forKey: .boolValue)
        }
    }
}

/// Context in which an answer was submitted
enum SubmissionContext: String, Codable, Hashable {
    case lesson = "lesson"
    case review = "review"
    case liveGame = "live_game"
}

/// A user's submission for an item
struct Submission: Identifiable, Codable, Hashable {
    let id: UUID
    let userId: UUID
    let itemId: UUID
    let context: SubmissionContext
    let userAnswer: UserAnswer
    let isCorrect: Bool
    let timeSpentSeconds: Int
    let xpAwarded: Int
    let submittedAt: Date

    init(
        id: UUID = UUID(),
        userId: UUID,
        itemId: UUID,
        context: SubmissionContext,
        userAnswer: UserAnswer,
        isCorrect: Bool,
        timeSpentSeconds: Int,
        xpAwarded: Int,
        submittedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.itemId = itemId
        self.context = context
        self.userAnswer = userAnswer
        self.isCorrect = isCorrect
        self.timeSpentSeconds = timeSpentSeconds
        self.xpAwarded = xpAwarded
        self.submittedAt = submittedAt
    }
}
