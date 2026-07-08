//
//  AIChatHeaderView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import SwiftUI

struct AIChatHeaderView: View {
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Button(action: {
                appRouter.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text("TrueFit AI")
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                        .bold()
                    
                    Image(systemName: "sparkles")
                        .foregroundColor(.brandPrimary)
                        .font(.system(size: 14))
                }
                
                Text("Your personal stylist")
                    .trueFitTextStyle(.caption2)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Active Dot indicator
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                Text("Online")
                    .trueFitTextStyle(.caption2)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.pill))
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.md)
        .background(.ultraThinMaterial)
    }
}

#if DEBUG
#Preview {
    AIChatHeaderView()
        .environmentObject(AppRouter())
        .background(Color.trueFitBackground)
}
#endif

