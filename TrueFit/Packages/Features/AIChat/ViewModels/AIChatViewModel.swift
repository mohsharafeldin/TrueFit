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
    @Published var errorMessage: String?
    
    private let sendChatMessageUseCase: SendChatMessageUseCase?
    private let buildProductContextUseCase: BuildProductContextUseCase?
    
    private var systemContext: String?
    
    let suggestedPrompts = [
        "White sneakers under $50 👟",
        "Summer outfit ideas 🌴",
        "Show me today's deals 🔥",
        "Match with blue jeans 👖"
    ]
    
    init(
        sendChatMessageUseCase: SendChatMessageUseCase? = nil,
        buildProductContextUseCase: BuildProductContextUseCase? = nil,
        mockMessages: [ChatMessage] = []
    ) {
        self.sendChatMessageUseCase = sendChatMessageUseCase
        self.buildProductContextUseCase = buildProductContextUseCase
        self.messages = mockMessages
    }
    
    func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Add User Message
        let userMsg = ChatMessage(text: trimmed, isUser: true)
        withAnimation(TrueFitMotion.springDefault) {
            messages.append(userMsg)
            inputText = ""
            isTyping = true
            errorMessage = nil
        }
        
        guard let sendUseCase = sendChatMessageUseCase,
              let contextUseCase = buildProductContextUseCase else {
            // Mock AI Response for Previews
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(TrueFitMotion.springDefault) {
                    self.isTyping = false
                    let aiResponse = ChatMessage(text: "I'm looking through our catalog for the best options that match your request. Give me a second! ✨", isUser: false)
                    self.messages.append(aiResponse)
                }
            }
            return
        }
        
        Task {
            do {
                if systemContext == nil {
                    systemContext = try await contextUseCase.execute()
                }
                
                guard let context = systemContext else { return }
                
                let responseText = try await sendUseCase.execute(message: trimmed, history: messages, systemContext: context)
                
                withAnimation(TrueFitMotion.springDefault) {
                    self.isTyping = false
                    let aiResponse = ChatMessage(text: responseText, isUser: false)
                    self.messages.append(aiResponse)
                }
                
            } catch {
                withAnimation(TrueFitMotion.springDefault) {
                    self.isTyping = false
                    self.errorMessage = error.localizedDescription
                    
                    let errorMsg = ChatMessage(text: "Sorry, I ran into an issue: \(error.localizedDescription) 😔", isUser: false)
                    self.messages.append(errorMsg)
                }
            }
        }
    }
}
