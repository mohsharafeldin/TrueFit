//
//  ForgotPasswordView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
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
                Text("Forgot Password")
                    .font(.title2)
                    .bold()
                
                Text("Enter your mail or phone number")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email or Phone Number")
                    .padding(.horizontal, 20)
                AuthTextField(placeholder: "Enter your email", text: $viewModel.emailOrPhone, iconName: "envelope")
            }
            
            PrimaryButton(title: "Send Code") {
                // Action to send code
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
            ForgotPasswordView()
                .presentationDetents([.height(350)]) .presentationDragIndicator(.hidden)
        }
}
