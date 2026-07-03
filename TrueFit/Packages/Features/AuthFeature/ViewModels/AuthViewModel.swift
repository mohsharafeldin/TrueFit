//
//  AuthViewModel.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    // Inputs
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    // States
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Dependencies
    private let authRepository: AuthRepositoryProtocol
    private let authManager: AuthManagerProtocol
    private let authRouter: AuthRouter
    
    // Injection
    init(authRepository: AuthRepositoryProtocol, authManager: AuthManagerProtocol, authRouter: AuthRouter) {
        self.authRepository = authRepository
        self.authManager = authManager
        self.authRouter = authRouter
    }
    
    func login() {
        isLoading = true
        Task {
            do {
                let token = try await authRepository.login(email: email, password: password)
                
                authManager.login(token: token)
                
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    func loginWithGoogle() {
            isLoading = true
            Task {
                do {
                    let token = try await authRepository.loginWithGoogle()
                    
                    authManager.login(token: token)
                    
                } catch {
                    self.errorMessage = error.localizedDescription
                }
                isLoading = false
            }
        }
}
