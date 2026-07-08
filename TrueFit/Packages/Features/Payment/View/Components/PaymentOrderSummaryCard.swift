//
//  PaymentOrderSummaryCard.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import SwiftUI

struct PaymentOrderSummaryCard: View {
    let total: Decimal
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                Text("Order Summary")
                    .font(.trueFitTitle3)
                    .foregroundColor(.textPrimary)
                Spacer()
            }

            Divider()
                .background(Color.borderColor)

            HStack {
                Text("Total")
                    .font(.trueFitCallout)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text(total, format: .currency(code: PaymentConfiguration.currencyCode))
                    .font(.trueFitHeadline)
                    .foregroundColor(.textPrimary)
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
