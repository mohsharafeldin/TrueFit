//
//  AIChatWelcomeStateView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import SwiftUI

struct AIChatWelcomeStateView: View {
    @ObservedObject var viewModel: AIChatViewModel
    @State private var isGlowing = false
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            // Pulsing AI Icon
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .scaleEffect(isGlowing ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isGlowing)
                
                Circle()
                    .fill(Color.brandPrimary.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: "wand.and.stars.inverse")
                    .font(.system(size: 32))
                    .foregroundColor(.brandPrimary)
            }
            .onAppear { isGlowing = true }
            
            VStack(spacing: Spacing.sm) {
                Text("Hi there! I'm TrueFit AI.")
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                    .bold()
                
                Text("Describe what you are looking for,\nor tap a suggestion below to start.")
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxxl)
            }
            
            // Suggestions Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                ForEach(viewModel.suggestedPrompts, id: \.self) { prompt in
                    Button(action: {
                        viewModel.sendMessage(prompt)
                    }) {
                        Text(prompt)
                            .trueFitTextStyle(.caption)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                            .padding(Spacing.md)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.surface)
                            .clipShape(RoundedRectangle.trueFit(Radius.lg))
                            .trueFitShadow(.xs)
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)
            
            Spacer()
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    AIChatWelcomeStateView(viewModel: AIChatViewModel())
        .background(Color.trueFitBackground)
}
#endif
