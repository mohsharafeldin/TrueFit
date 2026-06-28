//
//  AuthTextField.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

struct AuthTextField: View {
    var placeholder: String
    @Binding var text: String
    var iconName: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            
            if isSecure {
                Image(systemName: "eye.slash")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack(spacing: 20) {
        AuthTextField(placeholder: "Enter your email", text: .constant(""), iconName: "envelope")
        AuthTextField(placeholder: "Create your password", text: .constant(""), iconName: "lock", isSecure: true)
    }
}
