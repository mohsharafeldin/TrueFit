//
//  ApplePayAvailableView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//




import SwiftUI

struct ApplePayAvailableView: View {
    let isProcessing: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            Text("Tap the button below to complete your purchase securely with Apple Pay.")
                .font(.trueFitSubheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            ApplePayButtonView(
                buttonStyle: .automatic,
                buttonType: .plain
            ) {
                guard !isProcessing else { return }
                action()
            }
            .frame(height: 50)
        }
    }
}
