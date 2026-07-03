//
//  AuthRepository.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 30/06/2026.
//

import Foundation
import FirebaseAuth

public final class AuthRepository: AuthRepositoryProtocol {
func loginWithGoogle() async throws -> String {
        return "dummy_token_123"
    }
    private let firebaseDataSource: FirebaseAuthDataSourceProtocol
    private let shopifyDataSource: ShopifyAuthDataSourceProtocol
    private let keychainManager: KeychainManagerProtocol
    
    public init(
        firebaseDataSource: FirebaseAuthDataSourceProtocol,
        shopifyDataSource: ShopifyAuthDataSourceProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.shopifyDataSource = shopifyDataSource
        self.keychainManager = keychainManager
    }
    
    public func login(email: String, password: String) async throws -> AuthResult {
        do {
            // 1. Authenticate with Firebase
            let authResult = try await firebaseDataSource.signIn(email: email, password: password)
            let firebaseUser = authResult.user
            
            // 2. Authenticate with Shopify
            let shopifyTokenResponse = try await shopifyDataSource.customerAccessTokenCreate(email: email, password: password)
            let shopifyToken = AuthMapper.extractShopifyToken(from: shopifyTokenResponse)
            
            // 3. Save tokens
            let firebaseToken = try await firebaseUser.getIDToken()
            try keychainManager.save(firebaseToken, service: "com.truefit.auth", account: "firebaseToken")
            try keychainManager.save(shopifyToken, service: "com.truefit.auth", account: "shopifyCustomerToken")
            
            // 4. Map to Domain entity
            let user = AuthMapper.toDomain(firebaseUser: firebaseUser, shopifyCustomerId: "")
            return AuthResult(user: user)
            
        } catch {
            throw AuthMapper.mapError(error)
        }
    }
    
    public func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> AuthResult {
        var createdFirebaseUser: FirebaseAuth.User?
        
        do {
            // 1. Firebase
            let authResult = try await firebaseDataSource.signUp(email: email, password: password)
            createdFirebaseUser = authResult.user
            
            // 2. Profile Change
            let changeRequest = createdFirebaseUser?.createProfileChangeRequest()
            changeRequest?.displayName = "\(firstName) \(lastName)"
            try await changeRequest?.commitChanges()
            
            // 3. Shopify
            let shopifyCustomer = try await shopifyDataSource.customerCreate(
                firstName: firstName, lastName: lastName, email: email, password: password
            )
            let shopifyCustomerId = AuthMapper.extractShopifyCustomerId(from: shopifyCustomer)
            
            // 4. Shopify Token
            let shopifyTokenResponse = try await shopifyDataSource.customerAccessTokenCreate(email: email, password: password)
            let shopifyToken = AuthMapper.extractShopifyToken(from: shopifyTokenResponse)
            
            // 5. Save
            let firebaseToken = try await createdFirebaseUser?.getIDToken() ?? ""
            try keychainManager.save(firebaseToken, service: "com.truefit.auth", account: "firebaseToken")
            try keychainManager.save(shopifyToken, service: "com.truefit.auth", account: "shopifyCustomerToken")
            
            // 6. Map
            let user = AuthMapper.toDomain(firebaseUser: createdFirebaseUser!, shopifyCustomerId: shopifyCustomerId)
            return AuthResult(user: user)
            
        } catch {
            // ROLLBACK
            if createdFirebaseUser != nil {
                try? await firebaseDataSource.deleteCurrentUser()
            }
            throw AuthMapper.mapError(error)
        }
    }
    
    public func resetPassword(email: String) async throws {
        do {
            try await firebaseDataSource.resetPassword(email: email)
        } catch {
            throw AuthMapper.mapError(error)
        }
    }
    
    public func signOut() async throws {
        // 1. Delete Shopify customer access token
        if let shopifyToken = try? keychainManager.read(service: "com.truefit.auth", account: "shopifyCustomerToken", type: String.self) {
            try? await shopifyDataSource.customerAccessTokenDelete(accessToken: shopifyToken)
        }
        
        // 2. Sign out of Firebase
        try firebaseDataSource.signOut()
        
        // 3. Clear all auth tokens
        try? keychainManager.delete(service: "com.truefit.auth", account: "firebaseToken")
        try? keychainManager.delete(service: "com.truefit.auth", account: "shopifyCustomerToken")
    }
}
