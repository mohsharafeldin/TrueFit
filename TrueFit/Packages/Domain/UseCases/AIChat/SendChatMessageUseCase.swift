//
//  SendChatMessageUseCase.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

final class SendChatMessageUseCase {
    private let repository: AIChatRepositoryProtocol
    
    init(repository: AIChatRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(message: String, history: [ChatMessage], systemContext: String) async throws -> String {
        return try await repository.sendMessage(message, history: history, systemContext: systemContext)
    }
}
