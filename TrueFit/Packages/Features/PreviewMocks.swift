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
    func markAuthenticated() {
        
    }
    
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


// MARK: - Mock Favorites Repository

class MockFavoritesRepository: FavoritesRepositoryProtocol {
    var mockFavorites: [FavoriteItem] = [
        FavoriteItem(
            id: "mock-1",
            title: "Nike Air Force 1",
            price: 120.0,
            vendor: "Nike",
            imageURL: URL(string: "https://via.placeholder.com/150"),
            addedAt: Date()
        ),
        FavoriteItem(
            id: "mock-2",
            title: "Adidas Ultraboost Light",
            price: 190.0,
            vendor: "Adidas",
            imageURL: URL(string: "https://via.placeholder.com/150"),
            addedAt: Date().addingTimeInterval(-86400)
        ),
        FavoriteItem(
            id: "mock-3",
            title: "Classic Denim Jacket",
            price: 85.50,
            vendor: "Levi's",
            imageURL: nil,
            addedAt: Date().addingTimeInterval(-172800)
        )
    ]
    
    func getAllFavorites() async throws -> [FavoriteItem] {
        return mockFavorites
    }
    
    func addFavorite(_ item: FavoriteItem) async throws {
        mockFavorites.append(item)
    }
    
    func removeFavorite(productId: String) async throws {
        mockFavorites.removeAll { $0.id == productId }
    }
    
    func isFavorite(productId: String) async throws -> Bool {
        return mockFavorites.contains { $0.id == productId }
    }
}

// MARK: - Preview ViewModel Creator Extension

extension PreviewMocks {
    
    @MainActor
    static func makeFavoritesViewModel(isEmpty: Bool = false) -> FavoritesViewModel {
        let mockRepo = MockFavoritesRepository()
        
        if isEmpty {
            mockRepo.mockFavorites = []
        }
        
        let getFavoritesUseCase = GetFavoritesUseCase(repository: mockRepo)
        let toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: mockRepo)
        
        return FavoritesViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            authManager: MockAuthManager()
        )
    }
}
