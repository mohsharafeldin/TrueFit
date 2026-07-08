//
//  GeminiServiceProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

protocol GeminiChatServiceProtocol {
    func sendMessage(_ text: String, history: [ChatBootMessage], systemPrompt: String) async throws -> String
}
