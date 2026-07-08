//
//  AIChatRepositoryProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

protocol AIChatRepositoryProtocol {
    /// Sends a message to the AI and returns the response.
    /// - Parameters:
    ///   - text: The current user message.
    ///   - history: The previous conversation history for context.
    ///   - systemContext: The hidden prompt containing the TrueFit persona and product catalog.
    /// - Returns: The AI's generated text response.
    func sendMessage(_ text: String, history: [ChatBootMessage], systemContext: String) async throws -> String
}
