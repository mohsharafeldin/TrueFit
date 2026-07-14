//
//  PaymentResultBanner.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//
import SwiftUI

struct PaymentResultBanner: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                Image(systemName: icon)
                    .font(.system(size: 52))
                    .foregroundColor(iconColor)

                VStack(spacing: Spacing.xs) {
                    Text(title)
                        .font(.trueFitTitle2)
                        .foregroundColor(.textPrimary)

                    Text(subtitle)
                        .font(.trueFitCallout)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Button(action: action) {
                    Text(actionTitle)
                        .font(.trueFitHeadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.sm)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
                }
            }
            .padding(Spacing.xl)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .shadow(color: Color.shadowColor.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, Spacing.xxl)
            .transition(.scale(scale: 0.95).combined(with: .opacity))
        }
        .transition(.opacity)
    }
}
