//
//  PaymentMethodRow.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import SwiftUI

struct PaymentMethodRow: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .brandPrimary : .textSecondary)
                    .frame(width: 30)
                
                Text(title)
                    .font(.trueFitHeadline)
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.brandPrimary)
                        .font(.system(size: 20))
                } else {
                    Circle()
                        .stroke(Color.borderColor, lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.vertical, Spacing.sm)
            .contentShape(Rectangle())
        }
    }
}
