//
//  ForgotPasswordView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xl) {
            
            HStack {
                Spacer()
                Capsule()
                    .fill(Color.disabledColor)
                    .frame(width: 40, height: 5)
                    .padding(.top, Spacing.md)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Forgot Password")
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                
                Text("Enter your mail or phone number")
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.xs)
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Email")
                    .trueFitTextStyle(.footnote)
                    .foregroundColor(.textPrimary)
                
                AuthTextField(placeholder: "Enter your email", text: $viewModel.email, iconName: "envelope", keyboardType: .emailAddress)
            }
            .padding(.horizontal, Spacing.md)
            
            PrimaryButton(title: "Send Reset Link") {
                viewModel.resetPassword()
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.sm)
            
            Spacer()
        }
        .background(Color.surface.ignoresSafeArea())
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Color.trueFitBackground
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                ForgotPasswordView(viewModel: PreviewMocks.makeAuthViewModel())
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
            }
    }
}
