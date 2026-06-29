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
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                
                // Hero Section
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Create Account")
                        .trueFitTextStyle(.display)
                        .foregroundColor(.textPrimary)
                    
                    Text("Start learning with create your account")
                        .trueFitTextStyle(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, Spacing.xxxxl)
                .padding(.horizontal, Spacing.md)
                
                // Form Card
                VStack(spacing: Spacing.lg) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Username")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.textPrimary)
                        AuthTextField(placeholder: "Create your username", text: $viewModel.username, iconName: "person")
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Email or Phone Number")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.textPrimary)
                        AuthTextField(placeholder: "Enter your email or phone number", text: $viewModel.emailOrPhone, iconName: "envelope")
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Password")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.textPrimary)
                        AuthTextField(placeholder: "Create your password", text: $viewModel.password, iconName: "lock", isSecure: true)
                    }
                }
                .padding(Spacing.lg)
                .background(Color.surface)
                .clipShape(RoundedRectangle.trueFit(Radius.lg))
                .trueFitShadow(.sm)
                .padding(.horizontal, Spacing.md)
                
                // Primary Action
                PrimaryButton(title: "Create Account") {
                    // Route to Verification
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.sm)
                
                // Social Login
                VStack(spacing: Spacing.md) {
                    Text("Or using other method")
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(.textSecondary)
                    
                    SocialLoginButton(title: "Sign Up with Google", iconImage: .googleIcon) {
                        print("Google Sign Up Tapped")
                    }
                        
                    SocialLoginButton(title: "Sign Up with Facebook", iconImage: .facebookIcon) {
                        print("Facebook Sign Up Tapped")
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.lg)
                
                Spacer(minLength: Spacing.xxxxl)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(
            Color.trueFitBackground
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    SignUpView()
}
