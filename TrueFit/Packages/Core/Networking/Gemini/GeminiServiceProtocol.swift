//
//  GeminiServiceProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

protocol GeminiServiceProtocol {
    func sendMessage(_ text: String, history: [ChatMessage], systemPrompt: String) async throws -> String
}
