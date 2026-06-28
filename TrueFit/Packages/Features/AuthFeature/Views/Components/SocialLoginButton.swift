//
//  SocialLoginButton.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

import SwiftUI

public struct SocialLoginButton: View {
    var title: String
    var iconImage: Image
    var action: () -> Void
    
    public init(title: String, iconImage: Image, action: @escaping () -> Void) {
        self.title = title
        self.iconImage = iconImage
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                iconImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack(spacing: 20) {
        SocialLoginButton(title: "Sign In with Google", iconImage: .googleIcon, action: {})
        SocialLoginButton(title: "Sign In with Facebook", iconImage: .facebookIcon, action: {})
    }
}
