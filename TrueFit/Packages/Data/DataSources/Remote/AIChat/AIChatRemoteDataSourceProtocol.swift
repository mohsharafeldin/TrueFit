//
//  AIChatRemoteDataSourceProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

protocol AIChatRemoteDataSourceProtocol {
    func sendMessage(_ text: String, history: [ChatMessage], systemPrompt: String) async throws -> String
}
