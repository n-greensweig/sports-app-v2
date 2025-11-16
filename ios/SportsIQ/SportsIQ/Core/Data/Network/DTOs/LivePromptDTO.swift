//
//  LivePromptDTO.swift
//  SportsIQ
//
//  Created on 2025-11-15.
//

import Foundation

/// Data Transfer Object for LivePrompt from Supabase
struct LivePromptDTO: Codable {
    let id: String
    let sport_id: String
    let level_min: Int
    let level_max: Int
    let template_prompt: String
    let answer_schema_json: [String: AnyCodable]
    let grading_rule_json: [String: AnyCodable]
    let cooldown_seconds: Int
    let priority: Int
    let is_active: Bool
    let created_at: String
    let updated_at: String

    // Note: toDomain() not implemented yet - LivePrompt structure in Game.swift is different from database schema
    // This will be implemented when repositories are created
}

/// Data Transfer Object for LivePromptWindow from Supabase
struct LivePromptWindowDTO: Codable {
    let id: String
    let game_id: String
    let play_id: String
    let live_prompt_id: String
    let user_id: String
    let expires_at: String
    let status: String
    let created_at: String
    let updated_at: String

    // Note: toDomain() not implemented yet - LivePromptWindow doesn't exist in current domain model
    // This will be implemented when repositories are created
}

// Note: LivePrompt domain entity is defined in Game.swift
// Note: LivePromptWindow doesn't exist in current domain model yet

// MARK: - Domain to DTO Extensions
// Note: toDTO() methods not implemented yet - domain entities have different structures
// These will be implemented when the domain models are updated to match database schema
