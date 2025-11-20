//
//  SubmissionDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for Submission from Supabase
struct SubmissionDTO: Codable {
    let id: String
    let user_id: String
    let context: String
    let item_variant_id: String?
    let live_prompt_id: String?
    let session_id: String?
    let response_json: [String: AnyCodable]
    let submitted_at: String
    let latency_ms: Int?
    let device_platform: String?

    /// Convert DTO to Domain entity
    func toDomain(judgment: SubmissionJudgmentDTO?, timeSpentSeconds: Int = 0, xpAwarded: Int = 0) throws -> Submission {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let userUuid = UUID(uuidString: user_id) else {
            throw DTOConversionError.invalidUUID(field: "user_id", value: user_id)
        }

        // Get itemId from either item_variant_id or live_prompt_id
        var itemUuid: UUID
        if let variantId = item_variant_id {
            guard let uuid = UUID(uuidString: variantId) else {
                throw DTOConversionError.invalidUUID(field: "item_variant_id", value: variantId)
            }
            itemUuid = uuid
        } else if let promptId = live_prompt_id {
            guard let uuid = UUID(uuidString: promptId) else {
                throw DTOConversionError.invalidUUID(field: "live_prompt_id", value: promptId)
            }
            itemUuid = uuid
        } else {
            throw DTOConversionError.missingRequiredField(field: "item_variant_id or live_prompt_id")
        }


        guard let submittedDate = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter.date(from: submitted_at)
        }() else {
            throw DTOConversionError.invalidDate(field: "submitted_at", value: submitted_at)
        }

        // Parse response to UserAnswer
        let userAnswer = parseResponse(from: response_json)

        // Parse context
        let submissionContext: SubmissionContext
        switch context {
        case "lesson":
            submissionContext = .lesson
        case "review":
            submissionContext = .review
        case "live":
            submissionContext = .liveGame
        default:
            submissionContext = .lesson
        }

        return Submission(
            id: uuid,
            userId: userUuid,
            itemId: itemUuid,
            context: submissionContext,
            userAnswer: userAnswer,
            isCorrect: judgment?.is_correct ?? false,
            timeSpentSeconds: timeSpentSeconds,
            xpAwarded: xpAwarded,
            submittedAt: submittedDate
        )
    }

    private func parseResponse(from json: [String: AnyCodable]) -> UserAnswer {
        if let index = json["index"]?.value as? Int {
            return .single(index)
        } else if let indices = json["indices"]?.value as? [Int] {
            return .multiple(indices)
        } else if let bool = json["value"]?.value as? Bool {
            return .boolean(bool)
        } else if let value = json["value"]?.value as? Double {
            return .slider(value)
        } else if let value = json["value"]?.value as? Int {
            return .slider(Double(value))
        } else if let text = json["value"]?.value as? String {
            return .text(text)
        }
        return .single(0) // Default fallback
    }
}

/// Data Transfer Object for SubmissionJudgment from Supabase
struct SubmissionJudgmentDTO: Codable {
    let id: String
    let submission_id: String
    let is_correct: Bool
    let score: Double?
    let judged_by: String
    let explanation: String?
    let ground_truth_ref: String?
    let provider_event_id: String?
    let confidence: Double?
    let created_at: String

    /// Convert DTO to Domain entity
    func toDomain() throws -> SubmissionJudgment {
        guard let uuid = UUID(uuidString: id) else {
            throw DTOConversionError.invalidUUID(field: "id", value: id)
        }
        guard let submissionUuid = UUID(uuidString: submission_id) else {
            throw DTOConversionError.invalidUUID(field: "submission_id", value: submission_id)
        }


        guard let createdDate = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter.date(from: created_at)
        }() else {
            throw DTOConversionError.invalidDate(field: "created_at", value: created_at)
        }

        return SubmissionJudgment(
            id: uuid,
            submissionId: submissionUuid,
            isCorrect: is_correct,
            score: score,
            judgedBy: judged_by,
            explanation: explanation,
            createdAt: createdDate
        )
    }
}

/// Domain entity for SubmissionJudgment (if not already defined)
struct SubmissionJudgment: Identifiable, Codable {
    let id: UUID
    let submissionId: UUID
    let isCorrect: Bool
    let score: Double?
    let judgedBy: String
    let explanation: String?
    let createdAt: Date
}

// MARK: - Domain to DTO Extensions
extension Submission {
    func toDTO(devicePlatform: String = "ios") -> SubmissionDTO {
        let responseJson: [String: AnyCodable]
        switch userAnswer {
        case .single(let index):
            responseJson = ["index": AnyCodable(index)]
        case .multiple(let indices):
            responseJson = ["indices": AnyCodable(indices)]
        case .boolean(let value):
            responseJson = ["value": AnyCodable(value)]
        case .slider(let value):
            responseJson = ["value": AnyCodable(value)]
        case .text(let text):
            responseJson = ["value": AnyCodable(text)]
        }

        let contextString: String
        switch context {
        case .lesson:
            contextString = "lesson"
        case .review:
            contextString = "review"
        case .liveGame:
            contextString = "live"
        }

        return SubmissionDTO(
            id: id.uuidString,
            user_id: userId.uuidString,
            context: contextString,
            item_variant_id: itemId.uuidString,
            live_prompt_id: nil,
            session_id: nil,
            response_json: responseJson,
            submitted_at: ISO8601DateFormatter().string(from: submittedAt),
            latency_ms: nil, // Not tracked in current domain model
            device_platform: devicePlatform
        )
    }
}
