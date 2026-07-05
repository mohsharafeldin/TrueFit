//
//  AuthRepository.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 30/06/2026.
//

import Foundation
import FirebaseAuth

public final class AuthRepository: AuthRepositoryProtocol {
    
    

    private let firebaseDataSource: FirebaseAuthDataSourceProtocol
    private let shopifyDataSource: ShopifyAuthDataSourceProtocol
    private let keychainManager: KeychainManagerProtocol
    private let googleSignInService:GoogleSignInServiceProtocol
    
    public init(
        firebaseDataSource: FirebaseAuthDataSourceProtocol,
        shopifyDataSource: ShopifyAuthDataSourceProtocol,
        keychainManager: KeychainManagerProtocol,
        googleSignInService:GoogleSignInServiceProtocol
    ) {
        self.firebaseDataSource = firebaseDataSource
        self.shopifyDataSource = shopifyDataSource
        self.keychainManager = keychainManager
        self.googleSignInService = googleSignInService
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
    public func loginWithGoogle() async throws -> AuthResult {
        do {
            // 1. Authenticate with Google
            let googleResult = try await googleSignInService.signIn()
            let email = googleResult.email
            let fixedPassword = "12345678"
            
            let shopifyToken: String
            let shopifyCustomerId: String
            
            // 2. Try to log in first (account might already exist)
            do {
                let tokenResponse = try await shopifyDataSource.customerAccessTokenCreate(
                    email: email,
                    password: fixedPassword
                )
                shopifyToken = AuthMapper.extractShopifyToken(from: tokenResponse)
                shopifyCustomerId = ""
                
            } catch {
                // Account doesn't exist yet - create it
                let customer = try await shopifyDataSource.customerCreate(
                    firstName: googleResult.firstName,
                    lastName: googleResult.lastName,
                    email: email,
                    password: fixedPassword
                )
                shopifyCustomerId = AuthMapper.extractShopifyCustomerId(from: customer)
                
                let tokenResponse = try await shopifyDataSource.customerAccessTokenCreate(
                    email: email,
                    password: fixedPassword
                )
                shopifyToken = AuthMapper.extractShopifyToken(from: tokenResponse)
            }
            
            // 3. Save token
            try keychainManager.save(shopifyToken, service: "com.truefit.auth", account: "shopifyCustomerToken")
            
            // 4. Map to Domain entity
            let user = User(
                id: shopifyCustomerId,
                email: email,
                firstName: googleResult.firstName,
                lastName: googleResult.lastName,
                shopifyCustomerId: shopifyCustomerId
            )
            return AuthResult(user: user)
            
        } catch {
            throw AuthMapper.mapError(error)
        }
    }
}
