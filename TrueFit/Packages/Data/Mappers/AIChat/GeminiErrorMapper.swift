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
            return .unauthorized
        case .modelOverloaded:
            return .rateLimited
        case .safetyBlocked:
            return .forbidden
        case .responseEmpty:
            return .unknown("The AI returned an empty response.")
        case .networkError(let error):
            return .unknown(error.localizedDescription)
        case .unknown(let error):
            return .unknown(error.localizedDescription)
        }
    }
}
