//
//  PaymentMethodSelector.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//


import SwiftUI

struct PaymentMethodSelector: View {
    @Binding var selectedMethod: PaymentMethodType
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            PaymentMethodRow(
                title: "Apple Pay",
                icon: "applelogo",
                isSelected: selectedMethod == .applePay
            ) {
                selectedMethod = .applePay
            }
            
            PaymentMethodRow(
                title: "Cash On Delivery",
                icon: "shippingbox",
                isSelected: selectedMethod == .cashOnDelivery
            ) {
                selectedMethod = .cashOnDelivery
            }
        }
    }
}
