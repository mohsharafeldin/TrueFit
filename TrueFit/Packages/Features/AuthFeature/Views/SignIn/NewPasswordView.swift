//
//  NewPasswordView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct NewPasswordView: View {
    @StateObject var viewModel: AuthViewModel
    
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
                Text("Create New Password")
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                
                Text("Enter your new password")
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.xs)
            
            VStack(spacing: Spacing.md) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Password")
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(.textPrimary)
                    AuthTextField(placeholder: "Create your password", text: $viewModel.password, iconName: "lock", isSecure: true)
                }
                
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Confirm Password")
                        .trueFitTextStyle(.footnote)
                        .foregroundColor(.textPrimary)
                    AuthTextField(placeholder: "Confirm your password", text: $viewModel.confirmPassword, iconName: "lock", isSecure: true)
                }
            }
            .padding(.horizontal, Spacing.md)
            
            PrimaryButton(title: "Change Password") {
                // Action to change password
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.sm)
            
            Spacer()
        }
        .background(Color.surface.ignoresSafeArea())
    }
}

#Preview {
    Color.trueFitBackground
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            NewPasswordView(viewModel: PreviewMocks.makeAuthViewModel())
                .presentationDetents([.height(450)])
                .presentationDragIndicator(.hidden)
        }
}
