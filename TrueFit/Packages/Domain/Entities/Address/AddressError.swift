//
//  AddressError.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

public enum AddressError: LocalizedError {
    case networkError
    case invalidAccessToken
    case invalidCountry
    case invalidProvince
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .networkError:
            return "No internet connection. Please check your network and try again."
        case .invalidAccessToken:
            return "Your session has expired. Please sign in again."
        case .invalidCountry:
            return "Please select a valid country."
        case .invalidProvince:
            return "Please select a valid province."
        case .unknown(let message):
            return message
        }
    }
}
