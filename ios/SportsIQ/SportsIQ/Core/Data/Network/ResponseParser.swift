//
//  ResponseParser.swift
//  SportsIQ
//
//  Generic utilities for parsing API responses
//  Created as part of Database Setup Task 3
//

import Foundation

/// Utilities for parsing and decoding API responses
///
/// This struct provides generic methods for decoding JSON data from API responses,
/// with proper error handling and snake_case to camelCase conversion.
///
/// Example:
/// ```swift
/// let sports = try ResponseParser.decode([SportDTO].self, from: data)
/// ```
struct ResponseParser {
    // MARK: - JSON Decoder

    /// Shared JSON decoder configured for Supabase responses
    ///
    /// This decoder is configured with:
    /// - Snake case to camel case conversion
    /// - ISO8601 date decoding with fractional seconds
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        // DTOs use snake_case to match database schema, so no conversion needed
        // decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Handle dates in ISO8601 format with fractional seconds
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            // Try ISO8601 with fractional seconds first
            if let date = ISO8601DateFormatter.withFractionalSeconds.date(from: dateString) {
                return date
            }

            // Fall back to standard ISO8601
            if let date = ISO8601DateFormatter().date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }

        return decoder
    }()

    // MARK: - JSON Encoder

    /// Shared JSON encoder configured for Supabase requests
    ///
    /// This encoder is configured with:
    /// - Camel case to snake case conversion
    /// - ISO8601 date encoding
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()

        // Convert camelCase keys to snake_case
        encoder.keyEncodingStrategy = .convertToSnakeCase

        // Encode dates in ISO8601 format
        encoder.dateEncodingStrategy = .iso8601

        return encoder
    }()

    // MARK: - Decoding Methods

    /// Decode a Codable type from Data
    /// - Parameters:
    ///   - type: The type to decode
    ///   - data: Raw data from the response
    /// - Returns: Decoded object
    /// - Throws: NetworkError.decodingError if decoding fails
    static func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            #if DEBUG
            print("❌ Decoding error for type \(T.self):")
            print("   Error: \(error)")
            if let decodingError = error as? DecodingError {
                print("   Details: \(decodingError.detailedDescription)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("   JSON: \(jsonString)")
            }
            #endif
            throw NetworkError.decodingError(error)
        }
    }

    /// Decode a Codable type from a JSON string
    /// - Parameters:
    ///   - type: The type to decode
    ///   - jsonString: JSON string
    /// - Returns: Decoded object
    /// - Throws: NetworkError.decodingError if decoding fails
    static func decode<T: Decodable>(_ type: T.Type, from jsonString: String) throws -> T {
        guard let data = jsonString.data(using: .utf8) else {
            throw NetworkError.invalidURL
        }
        return try decode(type, from: data)
    }

    // MARK: - Encoding Methods

    /// Encode a Codable object to Data
    /// - Parameter object: The object to encode
    /// - Returns: Encoded JSON data
    /// - Throws: NetworkError.encodingError if encoding fails
    static func encode<T: Encodable>(_ object: T) throws -> Data {
        do {
            return try encoder.encode(object)
        } catch {
            #if DEBUG
            print("❌ Encoding error for type \(T.self):")
            print("   Error: \(error)")
            #endif
            throw NetworkError.encodingError(error)
        }
    }

    /// Encode a Codable object to a JSON string
    /// - Parameter object: The object to encode
    /// - Returns: JSON string
    /// - Throws: NetworkError.encodingError if encoding fails
    static func encodeToString<T: Encodable>(_ object: T) throws -> String {
        let data = try encode(object)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw NetworkError.encodingError(NSError(
                domain: "ResponseParser",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to create JSON string"]
            ))
        }
        return jsonString
    }
}

// MARK: - ISO8601DateFormatter Extension

extension ISO8601DateFormatter {
    /// ISO8601 formatter that handles fractional seconds
    static let withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

// MARK: - DecodingError Extension

extension DecodingError {
    /// Detailed description of decoding error for debugging
    var detailedDescription: String {
        switch self {
        case .typeMismatch(let type, let context):
            return "Type mismatch: Expected \(type), path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"

        case .valueNotFound(let type, let context):
            return "Value not found: \(type), path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"

        case .keyNotFound(let key, let context):
            return "Key not found: \(key.stringValue), path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"

        case .dataCorrupted(let context):
            return "Data corrupted: \(context.debugDescription), path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"

        @unknown default:
            return "Unknown decoding error"
        }
    }
}

// MARK: - UUID Extension

extension ResponseParser {
    /// Safely parse a UUID from a string
    /// - Parameter uuidString: String representation of UUID
    /// - Returns: UUID if valid, nil otherwise
    static func parseUUID(_ uuidString: String?) -> UUID? {
        guard let uuidString = uuidString else {
            return nil
        }
        return UUID(uuidString: uuidString)
    }

    /// Safely parse a UUID from a string, throwing error if invalid
    /// - Parameter uuidString: String representation of UUID
    /// - Returns: Valid UUID
    /// - Throws: NetworkError.decodingError if UUID is invalid
    static func requireUUID(_ uuidString: String?) throws -> UUID {
        guard let uuid = parseUUID(uuidString) else {
            throw NetworkError.decodingError(NSError(
                domain: "ResponseParser",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid UUID: \(uuidString ?? "nil")"]
            ))
        }
        return uuid
    }
}

// MARK: - Date Helper Extensions

extension ResponseParser {
    /// Parse an ISO8601 date string
    /// - Parameter dateString: ISO8601 formatted date string
    /// - Returns: Date if valid, nil otherwise
    static func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }

        // Try with fractional seconds
        if let date = ISO8601DateFormatter.withFractionalSeconds.date(from: dateString) {
            return date
        }

        // Try standard ISO8601
        return ISO8601DateFormatter().date(from: dateString)
    }

    /// Format a date as ISO8601 string
    /// - Parameter date: Date to format
    /// - Returns: ISO8601 formatted string
    static func formatDate(_ date: Date) -> String {
        return ISO8601DateFormatter.withFractionalSeconds.string(from: date)
    }
}
