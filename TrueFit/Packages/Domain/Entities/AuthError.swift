//
//  AuthError.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public enum AuthError: Error, LocalizedError, Equatable {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case missingClientID
    case missingRootViewController
    case missingIDToken
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .emailAlreadyInUse:
            return "This email is already associated with an account."
        case .weakPassword:
            return "Password is too weak. Please use a stronger password."
        case .networkError:
            return "Network connection error. Please check your internet connection."
        case .missingClientID:
            return "Google Client ID not found"
        case .missingRootViewController:
            return "Unable to present sign-in screen"
        case .missingIDToken:
            return "Failed to retrieve ID token from Google"
        case .unknown(let message):
            return message
        }
    }
}
