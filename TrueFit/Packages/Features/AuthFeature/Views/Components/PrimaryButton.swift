//
//  PrimaryButton.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

import SwiftUI

public struct TrueFitPrimaryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .trueFitTextStyle(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(Spacing.md)
            .background(Color.brandPrimary)
            .clipShape(RoundedRectangle.trueFit(Radius.xl))
            .trueFitShadow(.md)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(TrueFitMotion.springSnappy, value: configuration.isPressed)
    }
}

struct PrimaryButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(TrueFitPrimaryButtonStyle())
    }
}

#Preview {
    PrimaryButton(title: "Sign In", action: {
        print("Button Tapped")
    })
    .padding(Spacing.md)
    .background(Color.trueFitBackground)
}
