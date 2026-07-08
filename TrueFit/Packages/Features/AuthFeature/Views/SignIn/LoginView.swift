//
//  LoginView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                
                // Hero Section
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Login Account")
                        .trueFitTextStyle(.title1)
                        .foregroundColor(.textPrimary)
                    
                    Text("Please login with registered account")
                        .trueFitTextStyle(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, Spacing.lg)
                .padding(.horizontal, Spacing.md)
                
                // Form Card
                VStack(spacing: Spacing.lg) {
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
                    
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            viewModel.showForgotPasswordSheet = true
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
                
                // Actions Group
                VStack(spacing: Spacing.md) {
                    // Primary Action
                    PrimaryButton(title: "Sign In") {
                        viewModel.login()
                    }
                    .padding(.horizontal, Spacing.md)
                    
                    // Social Login
                    VStack(spacing: Spacing.md) {
                        Text("Or using other method")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.textSecondary)
                        
                        SocialLoginButton(title: "Sign In with Google", iconImage: .googleIcon) {
                            viewModel.loginWithGoogle()
                        }
                    }
                    .padding(.horizontal, Spacing.md)
                    
                    // Sign Up Navigation
                    HStack {
                        Text("Don't have an account?")
                            .trueFitTextStyle(.footnote)
                            .foregroundColor(.textSecondary)
                        Button("Sign Up") {
                            viewModel.navigateToSignUp()
                        }
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(.brandPrimary)
                        .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, Spacing.sm)
                
                Spacer(minLength: Spacing.xxxxl)
            }
        }
        .scrollDismissesKeyboard(.interactively)
            } // Close VStack
        } // Close ZStack
        .navigationBarHidden(true)
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .alert(viewModel.successMessage ?? viewModel.errorMessage ?? "", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
                viewModel.successMessage = nil
            }
        }
        .sheet(isPresented: $viewModel.showForgotPasswordSheet) {
            ForgotPasswordView(viewModel: viewModel)
                .presentationDetents([.height(350)])
                .presentationDragIndicator(.hidden)
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                viewModel.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)
            }
            Spacer()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.top, Spacing.md)
        .padding(.bottom, Spacing.xs)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: PreviewMocks.makeAuthViewModel())
    }
}
