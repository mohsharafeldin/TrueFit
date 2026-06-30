//
//  PreviewMocks.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 30/06/2026.
//

import Foundation
import SwiftUI

// Mock Repository
class MockAuthRepository: AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> String { return "dummy_token" }
    func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> String { return "dummy_token" }
    func resetPassword(email: String) async throws {}
}

// Mock Manager
@MainActor
class MockAuthManager: AuthManagerProtocol {
    var isAuthenticated = false
    var isGuest = false
    func login(token: String) {}
    func logout() {}
    func setGuestMode(_ isGuest: Bool) {}
    func getAccessToken() -> String? { return nil }
}

// Mock ViewModel Creator
@MainActor
struct PreviewMocks {
    static func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(
            authRepository: MockAuthRepository(),
            authManager: MockAuthManager(),
            authRouter: AuthRouter()
        )
    }
}
