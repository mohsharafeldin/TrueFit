//
//  AuthManager.swift
//  TrueFit
//
//  Created by Mona Zarea on 29/06/2026.
//
//
//import Foundation
//import SwiftUI
//
//@MainActor
//class AuthManager: ObservableObject {
//    @Published var isAuthenticated: Bool = false
//    
//    func completeLogin() {
//        //TODO: Save token to Keychain/CoreData here
//        self.isAuthenticated = true
//    }
//    
//    func logout() {
//        //TODO: Delete token here
//        self.isAuthenticated = false
//    }
//}


import Foundation

@MainActor
protocol AuthManagerProtocol {
    var isAuthenticated: Bool { get }
    var isGuest: Bool { get }
    func login(token: String)
    func logout()
    func setGuestMode(_ isGuest: Bool)
    func getAccessToken() -> String?
}

@MainActor
final class AuthManager: ObservableObject, AuthManagerProtocol {
    
    @Published var isAuthenticated: Bool = false
    @Published var isGuest: Bool = false
    
    private let keychainManager: KeychainManagerProtocol
    private let service = "com.truefit.auth"
    private let account = "shopifyCustomerToken"
    
    init(keychainManager: KeychainManagerProtocol = KeychainManager()) {
        self.keychainManager = keychainManager
        checkAuthStatus()
    }
    
    func login(token: String) {
       
        saveTokenToKeychain(token)
        self.isAuthenticated = true
        self.isGuest = false
    }
    
    func logout() {
        deleteTokenFromKeychain()
        self.isAuthenticated = false
        self.isGuest = false
    }
    
    func setGuestMode(_ isGuest: Bool) {
        self.isGuest = isGuest
    }
    
    nonisolated func getAccessToken() -> String? {
        return getTokenFromKeychain()
    }
    
    private func checkAuthStatus() {
        if getTokenFromKeychain() != nil {
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }
    
    private nonisolated func saveTokenToKeychain(_ token: String) {
        do {
            try keychainManager.save(token, service: service, account: account)
        } catch {
            print("Failed to save token to Keychain: \(error)")
        }
    }
    
    private nonisolated func getTokenFromKeychain() -> String? {
        do {
            return try keychainManager.read(service: service, account: account, type: String.self)
        } catch {
            return nil
        }
    }
    
    private nonisolated func deleteTokenFromKeychain() {
        do {
            try keychainManager.delete(service: service, account: account)
        } catch {
            print("Failed to delete token from Keychain: \(error)")
        }
    }
    
    
}
