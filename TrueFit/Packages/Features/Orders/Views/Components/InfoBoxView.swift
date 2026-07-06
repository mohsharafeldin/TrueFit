//
//  InfoBoxView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

struct InfoBoxView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .foregroundColor(.textTertiary)
                Text(title)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Text(value)
                .trueFitTextStyle(.subheadline)
                .foregroundColor(.textPrimary)
                .fontWeight(.medium)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.xs)
    }
}

#Preview {
    InfoBoxView(icon: "mappin.and.ellipse", title: "Delivery Address", value: "123 Main Street, Apt 4B, New York, NY 10001")
        .padding()
}
