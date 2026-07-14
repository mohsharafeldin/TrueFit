//
//  ApplePayUnavailableView.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//
import SwiftUI

struct ApplePayUnavailableView: View {
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.semanticWarning)

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Apple Pay Not Available")
                    .font(.trueFitCallout)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)

                Text("Please add a card in the Wallet app to use Apple Pay.")
                    .font(.trueFitSubheadline)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(Spacing.sm)
        .background(Color.semanticWarning.opacity(0.08))
        .cornerRadius(Radius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.sm)
                .stroke(Color.semanticWarning.opacity(0.3), lineWidth: 0.5)
        )
    }
}
