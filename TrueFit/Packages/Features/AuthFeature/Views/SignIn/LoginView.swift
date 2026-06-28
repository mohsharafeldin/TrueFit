//
//  LoginView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Login Account")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal, 20)
                .padding(.top, 40)
            
            Text("Please login with registered account")
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
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
            
            HStack {
                Spacer()
                Button("Forgot Password?") {
                    // Route to Forgot Password
                }
                .foregroundColor(.purple)
                .padding(.horizontal, 20)
            }
            
            PrimaryButton(title: "Sign In") {
                viewModel.login { success in
                    if success {
                        print("Route to Home")
                    } else {
                        print("Show Error")
                    }
                }
            }
            .padding(.top, 10)
            
            VStack(spacing: 15) {
                Text("Or using other method")
                    .foregroundColor(.gray)
                    .font(.footnote)
                
            SocialLoginButton(title: "Sign In with Google", iconImage: .googleIcon) {
                print("Google Login Tapped")
            }
                    
            SocialLoginButton(title: "Sign In with Facebook", iconImage: .facebookIcon) {
                print("Facebook Login Tapped")
            }

            }
            .padding(.top, 20)
            
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
