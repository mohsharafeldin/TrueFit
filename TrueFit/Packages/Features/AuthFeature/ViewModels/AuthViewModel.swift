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
    // MARK: - Inputs
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    // MARK: - States
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert = false
    @Published var successMessage: String?
    @Published var showForgotPasswordSheet = false
    
    // MARK: - Dependencies
    private let loginUseCase: LoginUseCaseProtocol
    private let signUpUseCase: SignUpUseCaseProtocol
    private let resetPasswordUseCase: ResetPasswordUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol
    private let authManager: AuthManagerProtocol
    private let authRepository: AuthRepositoryProtocol
    var authRouter: AuthRouter
    
    // MARK: - Init
    init(
        loginUseCase: LoginUseCaseProtocol,
        signUpUseCase: SignUpUseCaseProtocol,
        resetPasswordUseCase: ResetPasswordUseCaseProtocol,
        logoutUseCase: LogoutUseCaseProtocol,
        authManager: AuthManagerProtocol,
        authRouter: AuthRouter, 
        authRepository: AuthRepositoryProtocol
    ) {
        self.loginUseCase = loginUseCase
        self.signUpUseCase = signUpUseCase
        self.resetPasswordUseCase = resetPasswordUseCase
        self.logoutUseCase = logoutUseCase
        self.authManager = authManager
        self.authRouter = authRouter
       self.authRepository = authRepository
    }
    
    // MARK: - Validation
    
    private func validateEmail() -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
    
    private func validateLoginInputs() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError("Please enter your email address.")
            return false
        }
        guard validateEmail() else {
            showError("Please enter a valid email address.")
            return false
        }
        guard !password.isEmpty else {
            showError("Please enter your password.")
            return false
        }
        return true
    }
    
    private func validateSignUpInputs() -> Bool {
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError("Please enter your first name.")
            return false
        }
        guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError("Please enter your last name.")
            return false
        }
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError("Please enter your email address.")
            return false
        }
        guard validateEmail() else {
            showError("Please enter a valid email address.")
            return false
        }
        guard password.count >= 6 else {
            showError("Password must be at least 6 characters.")
            return false
        }
        return true
    }
    
    // MARK: - Actions
    
    func login() {
        guard validateLoginInputs() else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await loginUseCase.execute(email: email.trimmingCharacters(in: .whitespaces), password: password)
                authManager.login(token: result.user.id)
            } catch let error as AuthError {
                showError(error.localizedDescription)
            } catch {
                showError(error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    func signUp() {
        guard validateSignUpInputs() else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await signUpUseCase.execute(
                    firstName: firstName.trimmingCharacters(in: .whitespaces),
                    lastName: lastName.trimmingCharacters(in: .whitespaces),
                    email: email.trimmingCharacters(in: .whitespaces),
                    password: password
                )
                
                await MainActor.run {
                    self.successMessage = "Account created successfully!"
                    self.showAlert = true
                }
                
                authManager.login(token: result.user.id)
                
                isLoading = false
                
            } catch let error as AuthError {
                showError(error.localizedDescription)
            } catch {
                showError(error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    func resetPassword() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError("Please enter your email address.")
            return
        }
        guard validateEmail() else {
            showError("Please enter a valid email address.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await resetPasswordUseCase.execute(email: email.trimmingCharacters(in: .whitespaces))
                successMessage = "Password reset link sent to your email."
                showAlert = true
                showForgotPasswordSheet = false
            } catch let error as AuthError {
                showError(error.localizedDescription)
            } catch {
                showError(error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    func logout() {
        isLoading = true
        Task {
            do {
                try await logoutUseCase.execute()
                authManager.logout()
            } catch {
                showError(error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    // MARK: - Navigation
    
    func navigateToSignUp() {
        authRouter.navigate(to: .signUp)
    }
    
    func navigateToSignIn() {
        authRouter.navigate(to: .signIn)
    }
    
    func goBack() {
        authRouter.goBack()
    }
    
    // MARK: - Helpers
    
    private func showError(_ message: String) {
        errorMessage = message
        showAlert = true
    }
    
    func clearForm() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        confirmPassword = ""
        errorMessage = nil
        successMessage = nil
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
