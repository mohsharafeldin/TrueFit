//
//  KeychainError.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public enum KeychainError: Error, LocalizedError {
    case itemNotFound
    case duplicateItem
    case unexpectedStatus(OSStatus)
    case decodingError
    case encodingError
    
    public var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Item not found in Keychain."
        case .duplicateItem:
            return "Item already exists in Keychain."
        case .unexpectedStatus(let status):
            return "Unexpected Keychain status: \(status)"
        case .decodingError:
            return "Failed to decode item from Keychain."
        case .encodingError:
            return "Failed to encode item for Keychain."
        }
    }
}
