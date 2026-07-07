//
//  CashOnDeliveryView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import SwiftUI

struct CashOnDeliveryView: View {
    let isProcessing: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            Text("Pay with cash when your order is delivered to your address.")
                .font(.trueFitSubheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: action) {
                HStack {
                    if isProcessing {
                        ProgressView().tint(.white)
                    } else {
                        Text("Place Order")
                    }
                }
                .font(.trueFitHeadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            }
            .disabled(isProcessing)
        }
    }
}
