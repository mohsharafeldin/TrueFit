//
//  GeminiErrorMapper.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

enum GeminiErrorMapper {
    static func map(_ error: GeminiError) -> AppError {
        switch error {
        case .invalidAPIKey:
            return .invalidRequest
        case .modelOverloaded:
            return .rateLimited
        case .safetyBlocked:
            return .featureUnavailable("Your message was flagged by the AI's safety filter. Please try rephrasing.")
        case .responseEmpty:
            return .unknown("The AI returned an empty response. Please try again.")
        case .networkError(let underlyingError):
            if let urlError = underlyingError as? URLError,
               urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                return .noInternet
            }
            return .unknown(underlyingError.localizedDescription)
        case .unknown(let error):
            return .unknown(error.localizedDescription)
        }
    }
}
