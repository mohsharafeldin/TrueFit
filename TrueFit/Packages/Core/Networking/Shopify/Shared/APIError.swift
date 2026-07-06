//
//  APIError.swift
//  TrueFit
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case missingToken
    case unauthorized
    case forbidden
    case notFound
    case rateLimited(retryAfterSeconds: TimeInterval?)
    case serverError(statusCode: Int)
    case decodingFailed(Error)
    case graphQLErrors([String])
    case noInternetConnection
    case unknown(Error)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The endpoint URL is invalid."
        case .missingToken: return "Shopify Admin API Token is missing."
        case .unauthorized: return "Unauthorized (401). Check your API token."
        case .forbidden: return "Forbidden (403). The token lacks sufficient scopes."
        case .notFound: return "Not Found (404). The requested resource does not exist."
        case .rateLimited(let retryAfter):
            if let delay = retryAfter {
                return "Rate limited (429). Retry after \(delay) seconds."
            } else {
                return "Rate limited (429). Too many requests."
            }
        case .serverError(let code): return "Server error with status code: \(code)."
        case .decodingFailed(let error): return "Failed to decode response: \(error.localizedDescription)"
        case .graphQLErrors(let messages): return "GraphQL Errors: \(messages.joined(separator: ", "))"
        case .noInternetConnection: return "No internet connection."
        case .unknown(let error): return "An unknown error occurred: \(error.localizedDescription)"
        case .noData:
            return "No data received from the server."  
        }
    }
}

// MARK: - Error Response Models

struct ErrorResponse: Decodable {
    let errors: String?
}

struct GraphQLErrorResponse: Decodable {
    let errors: [GraphQLErrorDetail]?
    
    struct GraphQLErrorDetail: Decodable {
        let message: String
    }
}
