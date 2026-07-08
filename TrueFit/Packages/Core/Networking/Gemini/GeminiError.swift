//
//  GeminiError.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

enum GeminiError: Error, LocalizedError {
    case invalidAPIKey
    case modelOverloaded
    case safetyBlocked
    case responseEmpty
    case networkError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "API Key is missing or invalid."
        case .modelOverloaded:
            return "The AI model is currently overloaded. Please try again later."
        case .safetyBlocked:
            return "The response was blocked by safety settings."
        case .responseEmpty:
            return "The AI returned an empty response."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
