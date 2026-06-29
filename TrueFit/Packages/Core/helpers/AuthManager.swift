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
import Security

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
    
   // private let tokenKey = "com.truefit.accessToken"
    
    init() {
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
       
    }
    
    private nonisolated func getTokenFromKeychain() -> String? {
        //TODO: change this and put your implementation
           return nil
    }
    
    private nonisolated func deleteTokenFromKeychain() {
       
    }
}
