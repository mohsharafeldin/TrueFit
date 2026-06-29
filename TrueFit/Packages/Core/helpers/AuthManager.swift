//
//  AuthManager.swift
//  TrueFit
//
//  Created by Mona Zarea on 29/06/2026.
//

import Foundation
import SwiftUI

@MainActor
class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    func completeLogin() {
        //TODO: Save token to Keychain/CoreData here
        self.isAuthenticated = true
    }
    
    func logout() {
        //TODO: Delete token here
        self.isAuthenticated = false
    }
}
