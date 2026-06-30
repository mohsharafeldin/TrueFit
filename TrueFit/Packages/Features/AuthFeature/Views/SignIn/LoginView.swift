//
//  LoginView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                
                // Hero Section
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Login Account")
                        .trueFitTextStyle(.display)
                        .foregroundColor(.textPrimary)
                    
                    Text("Please login with registered account")
                        .trueFitTextStyle(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, Spacing.xxxxl)
                .padding(.horizontal, Spacing.md)
                
                // Form Card
                VStack(spacing: Spacing.lg) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Email")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.textPrimary)
                        AuthTextField(placeholder: "Enter your email or phone number", text: $viewModel.email, iconName: "envelope")
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Password")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.textPrimary)
                        AuthTextField(placeholder: "Create your password", text: $viewModel.password, iconName: "lock", isSecure: true)
                    }
                    
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            // Route to Forgot Password
                        }
                        .trueFitTextStyle(.callout)
                        .foregroundColor(.brandPrimary)
                    }
                }
                .padding(Spacing.lg)
                .background(Color.surface)
                .clipShape(RoundedRectangle.trueFit(Radius.lg))
                .trueFitShadow(.sm)
                .padding(.horizontal, Spacing.md)
                
                // Primary Action
                PrimaryButton(title: "Sign In") {
                    viewModel.login()
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.sm)
                
                // Social Login
                VStack(spacing: Spacing.md) {
                    Text("Or using other method")
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(.textSecondary)
                    
                    SocialLoginButton(title: "Sign In with Google", iconImage: .googleIcon) {
                        print("Google Login Tapped")
                    }
                        
                    SocialLoginButton(title: "Sign In with Facebook", iconImage: .facebookIcon) {
                        print("Facebook Login Tapped")
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
    LoginView(viewModel: PreviewMocks.makeAuthViewModel())
}
