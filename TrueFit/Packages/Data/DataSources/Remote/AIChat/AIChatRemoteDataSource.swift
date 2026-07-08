//
//  AIChatRemoteDataSource.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

final class AIChatRemoteDataSource: AIChatRemoteDataSourceProtocol {
    private let geminiService: GeminiChatServiceProtocol
    
    init(geminiService: GeminiChatServiceProtocol) {
        self.geminiService = geminiService
    }
    
    func sendMessage(_ text: String, history: [ChatBootMessage], systemPrompt: String) async throws -> String {
        return try await geminiService.sendMessage(text, history: history, systemPrompt: systemPrompt)
    }
}
