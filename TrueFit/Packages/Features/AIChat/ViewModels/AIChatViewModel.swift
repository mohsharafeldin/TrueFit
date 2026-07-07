//
//  AiViewModel.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation
import SwiftUI

@MainActor
class AIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage]
    @Published var inputText: String = ""
    @Published var isTyping: Bool = false
    
    let suggestedPrompts = [
        "White sneakers under $50 👟",
        "Summer outfit ideas 🌴",
        "Show me today's deals 🔥",
        "Match with blue jeans 👖"
    ]
    
    init(mockMessages: [ChatMessage] = []) {
        self.messages = mockMessages
    }
    
    func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let userMsg = ChatMessage(text: trimmed, isUser: true)
        withAnimation(TrueFitMotion.springDefault) {
            messages.append(userMsg)
            inputText = ""
            isTyping = true
        }
        
        // Mock AI Response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(TrueFitMotion.springDefault) {
                self.isTyping = false
                let aiResponse = ChatMessage(text: "I'm looking through our catalog for the best options that match your request. Give me a second! ✨", isUser: false)
                self.messages.append(aiResponse)
            }
        }
    }
}
