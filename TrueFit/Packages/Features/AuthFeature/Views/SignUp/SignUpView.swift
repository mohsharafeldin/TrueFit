//
//  SignUpView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal, 20)
                .padding(.top, 40)
            
            Text("Start learning with create your account")
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .padding(.horizontal, 20)
                AuthTextField(placeholder: "Create your username", text: $viewModel.username, iconName: "person")
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email or Phone Number")
                    .padding(.horizontal, 20)
                AuthTextField(placeholder: "Enter your email or phone number", text: $viewModel.emailOrPhone, iconName: "envelope")
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .padding(.horizontal, 20)
                AuthTextField(placeholder: "Create your password", text: $viewModel.password, iconName: "lock", isSecure: true)
            }
            
            PrimaryButton(title: "Create Account") {
                // Route to Verification
            }
            .padding(.top, 10)
            
            VStack(spacing: 15) {
                Text("Or using other method")
                    .foregroundColor(.gray)
                    .font(.footnote)
                
                SocialLoginButton(title: "Sign Up with Google", iconImage: .googleIcon) {
                    print("Google Sign Up Tapped")
                }
                    
                SocialLoginButton(title: "Sign Up with Facebook", iconImage: .facebookIcon) {
                    print("Facebook Sign Up Tapped")
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

#Preview {
    SignUpView()
}
