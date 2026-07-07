//
//  AIChatMessageView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import SwiftUI

struct AIChatMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: Spacing.xs) {
            if !message.isUser {
                // AI Avatar next to message
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.15))
                        .frame(width: 28, height: 28)
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.brandPrimary)
                }
            } else {
                Spacer()
            }
            
            Group {
                if message.isUser {
                    bubbleContent
                } else {
                    bubbleContent
                        .trueFitShadow(.xs)
                }
            }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal, Spacing.lg)
    }
    
    private var bubbleContent: some View {
        Text(message.text)
            .trueFitTextStyle(.body)
            .foregroundColor(message.isUser ? .white : .textPrimary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, 12)
            .background(message.isUser ? Color.brandPrimary : Color.surface)
            .clipShape(AIChatBubbleShape(isUser: message.isUser))
    }
}

#if DEBUG
#Preview {
    VStack(spacing: Spacing.md) {
        AIChatMessageView(message: ChatMessage(text: "Hello, how can I help you?", isUser: false))
        AIChatMessageView(message: ChatMessage(text: "I am looking for some white sneakers.", isUser: true))
    }
    .padding(.vertical)
    .background(Color.trueFitBackground)
}
#endif
