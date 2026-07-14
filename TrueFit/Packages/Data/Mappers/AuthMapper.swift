//
//  AuthMapper.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation
import FirebaseAuth

public final class AuthMapper {
    
    // MARK: - Firebase → Domain
    
    static func toDomain(firebaseUser: FirebaseAuth.User, shopifyCustomerId: String) -> User {
        var firstName = ""
        var lastName = ""
        
        if let displayName = firebaseUser.displayName {
            let components = displayName.components(separatedBy: " ")
            firstName = components.first ?? ""
            if components.count > 1 {
                lastName = components.dropFirst().joined(separator: " ")
            }
        }
        
        return User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            firstName: firstName,
            lastName: lastName,
            shopifyCustomerId: shopifyCustomerId
        )
    }
    
    // MARK: - Shopify Token Extraction
    
    static func extractShopifyToken(from response: ShopifyCustomerTokenResponse) -> String {
        return response.accessToken
    }
    
    static func extractShopifyCustomerId(from response: ShopifyCustomerResponse) -> String {
        return response.id
    }
    
    // MARK: - Error Mapping
    
    static func mapError(_ error: Error) -> AuthError {
        // If it's an APIError from Shopify
        if let apiError = error as? APIError {
            switch apiError {
            case .unauthorized:
                return .invalidCredentials
            case .noInternetConnection:
                return .networkError
            case .graphQLErrors(let messages):
                let joined = messages.joined(separator: ". ")
                if joined.lowercased().contains("already") {
                    return .emailAlreadyInUse
                }
                return .unknown(joined)
            default:
                return .unknown(apiError.localizedDescription)
            }
        }
        
        // If it's already an AuthError, pass it through directly
        if let authError = error as? AuthError {
            return authError
        }
        
        let nsError = error as NSError
        if nsError.domain == AuthErrorDomain {
            if let authErrorCode = AuthErrorCode.Code(rawValue: nsError.code) {
                switch authErrorCode {
                case .emailAlreadyInUse: return .emailAlreadyInUse
                case .invalidEmail, .wrongPassword, .userNotFound, .invalidCredential:
                    return .invalidCredentials
                case .weakPassword: return .weakPassword
                case .networkError: return .networkError
                case .tooManyRequests: return .failedToSendVerificationEmail
                default: return .unknown(error.localizedDescription)
                }
            }
        }
        
        return .unknown(error.localizedDescription)
    }
}
