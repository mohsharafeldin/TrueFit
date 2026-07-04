//
//  PreviewMocks.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 30/06/2026.
//

import Foundation
import SwiftUI

// MARK: - Mock Repository

class MockAuthRepository: AuthRepositoryProtocol {
     func loginWithGoogle() async throws -> AuthResult {
        return AuthResult(user: User(id: "mock-id", email: "email", firstName: "Mock", lastName: "User", shopifyCustomerId: "mock-shopify-id"))
    }
    func login(email: String, password: String) async throws -> AuthResult {
        return AuthResult(user: User(id: "mock-id", email: email, firstName: "Mock", lastName: "User", shopifyCustomerId: "mock-shopify-id"))
    }
    func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> AuthResult {
        return AuthResult(user: User(id: "mock-id", email: email, firstName: firstName, lastName: lastName, shopifyCustomerId: "mock-shopify-id"))
    }
    
    func resetPassword(email: String) async throws {}
    
    func signOut() async throws {}
}

// MARK: - Mock Use Cases

class MockLoginUseCase: LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> AuthResult {
        return AuthResult(user: User(id: "mock", email: email, firstName: "Mock", lastName: "User", shopifyCustomerId: ""))
    }
}

class MockSignUpUseCase: SignUpUseCaseProtocol {
    func execute(firstName: String, lastName: String, email: String, password: String) async throws -> AuthResult {
        return AuthResult(user: User(id: "mock", email: email, firstName: firstName, lastName: lastName, shopifyCustomerId: ""))
    }
}

class MockResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    func execute(email: String) async throws {}
}

class MockLogoutUseCase: LogoutUseCaseProtocol {
    func execute() async throws {}
}

class MockLoginWithGoogleUseCase: LoginWithGoogleUseCaseProtocol {
    func execute() async throws -> AuthResult {
        return AuthResult(user: User(id: "mock-id", email: "email", firstName: "Mock", lastName: "User", shopifyCustomerId: "mock-shopify-id"))
    }
}


// MARK: - Mock Manager

@MainActor
class MockAuthManager: AuthManagerProtocol {
    var isAuthenticated = false
    var isGuest = false
    func login(token: String) {}
    func logout() {}
    func setGuestMode(_ isGuest: Bool) {}
    func getAccessToken() -> String? { return nil }
}

// MARK: - Preview ViewModel Creator
@MainActor
struct PreviewMocks {
    static func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(
            loginUseCase: MockLoginUseCase(),
            signUpUseCase: MockSignUpUseCase(),
            resetPasswordUseCase: MockResetPasswordUseCase(),
            logoutUseCase: MockLogoutUseCase(),
            authManager: MockAuthManager(),
            authRouter: AuthRouter(),
            loginWithGoogleUseCase: MockLoginWithGoogleUseCase(),
        )
    }
}
