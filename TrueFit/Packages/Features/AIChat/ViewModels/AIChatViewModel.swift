//
//  AIChatViewModel.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

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
        
        let userMsg = ChatMessage(text: trimmed, isUser: true)
        messages.append(userMsg)
        inputText = ""
        isTyping = true
        errorMessage = nil
        
        guard let sendUseCase = sendChatMessageUseCase,
              let contextUseCase = buildProductContextUseCase else {
            // Fallback for Previews when no use cases are injected
            handleMockResponse()
            return
        }
        
        Task {
            do {
                if systemContext == nil {
                    systemContext = try await contextUseCase.execute()
                }
                
                guard let context = systemContext else { return }
                
                let responseText = try await sendUseCase.execute(
                    message: trimmed,
                    history: Array(messages.dropLast()),
                    systemContext: context
                )
                
                let aiResponse = ChatMessage(text: responseText, isUser: false)
                self.messages.append(aiResponse)
                self.isTyping = false
                
            } catch let appError as AppError {
                print("🚨 AI CHAT APP ERROR: \(appError)")
                self.isTyping = false
                self.errorMessage = appError.userMessage
                let errorMsg = ChatMessage(text: "Sorry, I ran into an issue. \(appError.userMessage) 😔", isUser: false)
                self.messages.append(errorMsg)
            } catch {
                print("🚨 AI CHAT RAW ERROR: \(error)")
                self.isTyping = false
                self.errorMessage = error.localizedDescription
                let errorMsg = ChatMessage(text: "Sorry, something unexpected went wrong. Please try again. 😔", isUser: false)
                self.messages.append(errorMsg)
            }
        }
    }
    
    // MARK: - Private Helpers
    
    private func handleMockResponse() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            self.isTyping = false
            let aiResponse = ChatMessage(
                text: "I'm looking through our catalog for the best options that match your request. Give me a second! ✨",
                isUser: false
            )
            self.messages.append(aiResponse)
        }
    }
}
