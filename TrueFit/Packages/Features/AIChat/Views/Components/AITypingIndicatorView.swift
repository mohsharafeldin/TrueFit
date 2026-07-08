//
//  AITypingIndicatorView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import SwiftUI

struct AITypingIndicatorView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .bottom, spacing: Spacing.xs) {
            // AI Avatar
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.15))
                        .frame(width: 28, height: 28)
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.brandPrimary)
            }
            
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: 6, height: 6)
                        .offset(y: (sin(phase + CGFloat(index) * .pi / 1.5) * -4))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.surface)
            .clipShape(AIChatBubbleShape(isUser: false))
            .trueFitShadow(.xs)
        }
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

#if DEBUG
#Preview {
    AITypingIndicatorView()
        .padding()
        .background(Color.trueFitBackground)
}
#endif
