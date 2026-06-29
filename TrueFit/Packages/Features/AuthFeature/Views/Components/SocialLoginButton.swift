//
//  SocialLoginButton.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

public struct TrueFitSocialButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .trueFitTextStyle(.headline)
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(Spacing.md)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.xl))
            .overlay(
                RoundedRectangle.trueFit(Radius.xl)
                    .stroke(Color.borderColor, lineWidth: 1)
            )
            .trueFitShadow(.xs)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(TrueFitMotion.springSnappy, value: configuration.isPressed)
    }
}

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
            HStack(spacing: Spacing.sm) {
                iconImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(title)
            }
        }
        .buttonStyle(TrueFitSocialButtonStyle())
    }
}

#Preview {
    VStack(spacing: Spacing.lg) {
        SocialLoginButton(title: "Sign In with Google", iconImage: Image("google"), action: {})
        SocialLoginButton(title: "Sign In with Facebook", iconImage: Image("facebook"), action: {})
    }
    .padding(Spacing.xl)
    .background(Color.trueFitBackground)
}
