//
//  NetworkError.swift
//  SportsIQ
//
//  Network error types for API and database operations
//  Created as part of Database Setup Task 3
//

import Foundation

/// Comprehensive error type for network and database operations
///
/// This enum provides detailed error cases for all network-related failures,
/// including HTTP errors, parsing errors, and connection issues.
///
/// Example:
/// ```swift
/// do {
///     let sports = try await fetchSports()
/// } catch let error as NetworkError {
///     switch error {
///     case .unauthorized:
///         // Handle auth error
///     case .serverError(let code, let message):
///         // Handle server error
///     default:
///         // Handle other errors
///     }
/// }
/// ```
enum NetworkError: LocalizedError {
    // MARK: - Cases

    /// Invalid URL provided
    case invalidURL

    /// No data received from server
    case noData

    /// Failed to decode response data
    case decodingError(Error)

    /// Failed to encode request data
    case encodingError(Error)

    /// Server returned an error response
    case serverError(statusCode: Int, message: String)

    /// User is not authenticated or token is invalid
    case unauthorized

    /// Requested resource not found (404)
    case notFound

    /// Request forbidden (403)
    case forbidden

    /// Too many requests (rate limit exceeded)
    case rateLimitExceeded

    /// Connection to server failed
    case connectionFailed(Error)

    /// Request timed out
    case timeout

    /// Database query error
    case databaseError(Error)

    /// Unknown or unexpected error
    case unknown(Error)

    // MARK: - LocalizedError Conformance

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"

        case .noData:
            return "No data received from server"

        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"

        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"

        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"

        case .unauthorized:
            return "You are not authorized. Please sign in."

        case .notFound:
            return "The requested resource was not found"

        case .forbidden:
            return "Access to this resource is forbidden"

        case .rateLimitExceeded:
            return "Too many requests. Please try again later."

        case .connectionFailed(let error):
            return "Connection failed: \(error.localizedDescription)"

        case .timeout:
            return "Request timed out. Please check your connection."

        case .databaseError(let error):
            return "Database error: \(error.localizedDescription)"

        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }

    var failureReason: String? {
        switch self {
        case .invalidURL:
            return "The URL was malformed or missing"

        case .noData:
            return "The server did not return any data"

        case .decodingError:
            return "The response format was invalid or unexpected"

        case .encodingError:
            return "The request data could not be encoded"

        case .serverError(let code, _):
            return "The server returned status code \(code)"

        case .unauthorized:
            return "Your session may have expired"

        case .notFound:
            return "The resource does not exist"

        case .forbidden:
            return "You do not have permission to access this resource"

        case .rateLimitExceeded:
            return "Too many requests were made in a short time"

        case .connectionFailed:
            return "Could not connect to the server"

        case .timeout:
            return "The request took too long to complete"

        case .databaseError:
            return "A database operation failed"

        case .unknown:
            return "The cause of the error is unknown"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Please contact support if this issue persists"

        case .noData:
            return "Try again or check your connection"

        case .decodingError, .encodingError:
            return "Please update the app to the latest version"

        case .serverError(let code, _):
            if code >= 500 {
                return "The server is experiencing issues. Please try again later."
            } else {
                return "Please check your request and try again"
            }

        case .unauthorized:
            return "Please sign in again"

        case .notFound:
            return "The item may have been removed or moved"

        case .forbidden:
            return "Please contact support if you believe this is an error"

        case .rateLimitExceeded:
            return "Wait a few moments before trying again"

        case .connectionFailed, .timeout:
            return "Check your internet connection and try again"

        case .databaseError:
            return "Please try again or contact support"

        case .unknown:
            return "Please try again or contact support if the issue persists"
        }
    }
}

// MARK: - Helpers

extension NetworkError {
    /// Create a NetworkError from an HTTP status code
    /// - Parameters:
    ///   - statusCode: HTTP status code
    ///   - message: Optional error message from server
    /// - Returns: Appropriate NetworkError case
    static func fromStatusCode(_ statusCode: Int, message: String? = nil) -> NetworkError {
        let errorMessage = message ?? "Request failed"

        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 429:
            return .rateLimitExceeded
        case 500...599:
            return .serverError(statusCode: statusCode, message: errorMessage)
        default:
            return .serverError(statusCode: statusCode, message: errorMessage)
        }
    }

    /// Check if the error is retryable
    var isRetryable: Bool {
        switch self {
        case .timeout, .connectionFailed, .rateLimitExceeded:
            return true
        case .serverError(let code, _):
            return code >= 500 // Server errors are retryable
        default:
            return false
        }
    }

    /// Check if the error is related to authentication
    var isAuthenticationError: Bool {
        switch self {
        case .unauthorized, .forbidden:
            return true
        default:
            return false
        }
    }
}
