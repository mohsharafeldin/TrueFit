//
//  PaymentNavigationBar.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import SwiftUI

struct PaymentNavigationBar: View {
    let dismissAction: () -> Void
    
    var body: some View {
        ZStack {
            Text("Payment")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.textPrimary)

            HStack {
                Button(action: dismissAction) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.textPrimary)
                }
                Spacer()
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.surface)
        .overlay(
            Rectangle()
                .fill(Color.borderColor)
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
}
