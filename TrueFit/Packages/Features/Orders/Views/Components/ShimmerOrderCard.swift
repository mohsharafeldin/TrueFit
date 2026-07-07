//
//  ShimmerOrderCard.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

struct ShimmerOrderCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    shimmerBlock(width: 120, height: 16)
                    shimmerBlock(width: 80, height: 12)
                }
                Spacer()
                shimmerBlock(width: 70, height: 24, cornerRadius: Radius.pill)
            }
            .padding(Spacing.md)
            
            Divider()
            
            // Middle
            HStack(spacing: -Spacing.sm) {
                ForEach(0..<3) { index in
                    shimmerBlock(width: 46, height: 46, cornerRadius: 23)
                        .overlay(Circle().stroke(Color.surface, lineWidth: 2))
                        .zIndex(Double(3 - index))
                }
                Spacer()
            }
            .padding(Spacing.md)
            
            // Bottom
            HStack {
                shimmerBlock(width: 60, height: 14)
                shimmerBlock(width: 80, height: 18)
                Spacer()
                shimmerBlock(width: 80, height: 30, cornerRadius: Radius.pill)
            }
            .padding(Spacing.md)
        }
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.sm)
        .onAppear {
            withAnimation(
                .linear(duration: TrueFitMotion.loadingCycle)
                .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
    
    @ViewBuilder
    private func shimmerBlock(width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 4) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.trueFitBackground)
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.4), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 200 : -200)
            )
            .clipped()
    }
}

struct ShimmerOrderCard_Previews: PreviewProvider {
    static var previews: some View {

        ShimmerOrderCard()
            .padding()
            .background(Color.trueFitBackground)

    }
}
