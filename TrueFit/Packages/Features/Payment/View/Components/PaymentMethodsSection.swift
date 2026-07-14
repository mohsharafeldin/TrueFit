//
//  PaymentMethodsSection.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//


import SwiftUI

struct PaymentMethodsSection: View {
    @Binding var selectedMethod: PaymentMethodType
    let isApplePayAvailable: Bool
    let isProcessing: Bool
    let onApplePayAction: () -> Void
    let onCashOnDeliveryAction: () -> Void

    var body: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Payment Method")
                    .font(.trueFitTitle3)
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            
            PaymentMethodSelector(selectedMethod: $selectedMethod)
            
            Divider()
                .background(Color.borderColor)

            if selectedMethod == .applePay {
                if isApplePayAvailable {
                    ApplePayAvailableView(isProcessing: isProcessing, action: onApplePayAction)
                } else {
                    ApplePayUnavailableView()
                }
            } else {
                CashOnDeliveryView(isProcessing: isProcessing, action: onCashOnDeliveryAction)
            }
        }
        .padding(Spacing.lg)
        .background(Color.surface)
        .cornerRadius(Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.md)
                .stroke(Color.borderColor, lineWidth: 0.5)
        )
    }
}
