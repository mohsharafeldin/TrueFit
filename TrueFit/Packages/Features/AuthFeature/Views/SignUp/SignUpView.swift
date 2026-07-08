//
//  SignUpView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    
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
                    
                    // First Name & Last Name
                    HStack(spacing: Spacing.md) {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("First Name")
                                .trueFitTextStyle(.footnote)
                                .foregroundColor(.textPrimary)
                            AuthTextField(placeholder: "First name", text: $viewModel.firstName, iconName: "person", keyboardType: .default)
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Last Name")
                                .trueFitTextStyle(.footnote)
                                .foregroundColor(.textPrimary)
                            AuthTextField(placeholder: "Last name", text: $viewModel.lastName, iconName: "person", keyboardType: .default)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Email")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.textPrimary)
                        AuthTextField(placeholder: "Enter your email", text: $viewModel.email, iconName: "envelope", keyboardType: .emailAddress)
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
                    viewModel.signUp()
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
                
                // Already have account
                HStack {
                    Text("Already have an account?")
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(.textSecondary)
                    Button("Sign In") {
                        viewModel.goBack()
                    }
                    .trueFitTextStyle(.footnote)
                    .foregroundColor(.brandPrimary)
                    .fontWeight(.semibold)
                }
                .padding(.top, Spacing.md)
                
                Spacer(minLength: Spacing.xxxxl)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(
            Color.trueFitBackground
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .alert(viewModel.errorMessage ?? "", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        }
        .sheet(isPresented: $viewModel.showEmailVerificationSheet) {
            EmailVerificationView(viewModel: viewModel)
                .presentationDetents([.height(520)])
                .presentationDragIndicator(.hidden)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: PreviewMocks.makeAuthViewModel())
    }
}
