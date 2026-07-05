//
//  ShimmerFavoriteCard.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import SwiftUI

struct ShimmerFavoriteCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            RoundedRectangle.trueFit(Radius.md)
                .fill(Color.surface)
                .frame(width: 95, height: 95)
                .overlay(shimmerGradient)
                .clipped()
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(height: 14)
                    .overlay(shimmerGradient)
                    .clipped()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(width: 70, height: 10)
                    .overlay(shimmerGradient)
                    .clipped()
                
                Spacer()
                
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.surface)
                        .frame(width: 50, height: 16)
                        .overlay(shimmerGradient)
                        .clipped()
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.surface)
                        .frame(width: 65, height: 26)
                        .overlay(shimmerGradient)
                        .clipped()
                }
            }
            .padding(.vertical, Spacing.xs)
        }
        .padding(Spacing.sm)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .onAppear {
            withAnimation(.linear(duration: TrueFitMotion.loadingCycle).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
    
    private var shimmerGradient: some View {
        LinearGradient(colors: [.clear, .white.opacity(0.35), .clear], startPoint: .leading, endPoint: .trailing)
            .offset(x: isAnimating ? 250 : -250)
    }
}
