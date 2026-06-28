//
//  NewPasswordView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct NewPasswordView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Spacer()
                Capsule()
                    .fill(Color(.systemGray4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 15)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Create New Password")
                    .font(.title2)
                    .bold()
                
                Text("Enter your new password")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .padding(.horizontal, 20)
                AuthTextField(placeholder: "Create your password", text: $viewModel.password, iconName: "lock", isSecure: true)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirm Password")
                    .padding(.horizontal, 20)
                AuthTextField(placeholder: "Confirm your password", text: $viewModel.confirmPassword, iconName: "lock", isSecure: true)
            }
            
            PrimaryButton(title: "Change Password") {
                // Action to change password
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    Color.gray.opacity(0.3)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            NewPasswordView()
                .presentationDetents([.height(450)])
                .presentationDragIndicator(.hidden)
        }
}
