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
    var keyboardType: UIKeyboardType = .default
    
    @FocusState private var isFocused: Bool
    
    var autocapitalization: TextInputAutocapitalization {
        if isSecure { return .never }
        if keyboardType == .emailAddress { return .never }
        if keyboardType == .default { return .words }
        return .sentences
    }
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: iconName)
                .foregroundColor(isFocused ? .brandPrimary : .textTertiary)
                .animation(.easeInOut(duration: TrueFitMotion.durationFast), value: isFocused)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textInputAutocapitalization(autocapitalization)
                        .autocorrectionDisabled(true)
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(autocapitalization)
                        .keyboardType(keyboardType)
                        .autocorrectionDisabled(true)
                }
            }
            .focused($isFocused)
            .trueFitTextStyle(.body)
            .foregroundColor(.textPrimary)
            
            if isSecure {
                Image(systemName: "eye.slash")
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.sm))
        .overlay(
            RoundedRectangle.trueFit(Radius.sm)
                .stroke(isFocused ? Color.brandPrimary : Color.borderColor, lineWidth: 1)
                .animation(.easeInOut(duration: TrueFitMotion.durationFast), value: isFocused)
        )
    }
}

struct AuthTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            AuthTextField(placeholder: "Enter your email", text: .constant(""), iconName: "envelope")
            AuthTextField(placeholder: "Create your password", text: .constant(""), iconName: "lock", isSecure: true)
        }
        .padding(Spacing.xl)
        .background(Color.trueFitBackground)
    }
}
