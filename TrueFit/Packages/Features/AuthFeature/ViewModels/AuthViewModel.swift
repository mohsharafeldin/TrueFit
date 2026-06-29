//
//  AuthViewModel.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    // Inputs
    @Published var emailOrPhone: String = ""
    @Published var password: String = ""
    @Published var verificationCode: String = ""
    @Published var username: String = ""
    @Published var confirmPassword: String = ""
    
    // States for Dummy Loading
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Dummy Actions
    func login(completion: @escaping (Bool) -> Void) {
        isLoading = true
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            if self.emailOrPhone == "magdalena83@mail.com" && self.password == "123456" {
                completion(true) // Success
            } else {
                self.errorMessage = "Invalid credentials"
                completion(false) // Failed
            }
        }
    }
    
    func verifyCode(completion: @escaping (Bool) -> Void) {
        // Dummy verification logic
        completion(verificationCode == "6381")
    }
}
