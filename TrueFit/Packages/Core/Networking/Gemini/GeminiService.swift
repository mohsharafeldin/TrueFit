//
//  GeminiService.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation
import GoogleGenerativeAI

class GeminiService: GeminiServiceProtocol {
    private let modelName = "gemini-1.5-flash"
    
    func sendMessage(_ text: String, history: [ChatMessage], systemPrompt: String) async throws -> String {
        let apiKey = Bundle.main.geminiAPIKey
        
        // Ensure the API Key is available and valid
        guard !apiKey.isEmpty, apiKey != "YOUR_API_KEY_HERE" else {
            throw GeminiError.invalidAPIKey
        }
        
        // Model configuration (creativity level and maximum response length)
        let config = GenerationConfig(
            temperature: 0.7,
            maxOutputTokens: 500
        )
        
        // Inject system instructions (System Prompt)
        let systemInstruction = ModelContent(role: "system", parts: [.text(systemPrompt)])
        
        // Initialize the generative model
        let model = GenerativeModel(
            name: modelName,
            apiKey: apiKey,
            generationConfig: config,
            systemInstruction: systemInstruction
        )
        
        // Map our app's message models to the format understood by the Google SDK (ModelContent)
        let mappedHistory: [ModelContent] = history.map { message in
            let role = message.isUser ? "user" : "model"
            return ModelContent(role: role, parts: [.text(message.text)])
        }
        
        // Start a chat session so the AI retains the conversation history and context
        let chat = model.startChat(history: mappedHistory)
        
        // Send the new message and await the response
        do {
            let response = try await chat.sendMessage(text)
            
            guard let responseText = response.text, !responseText.isEmpty else {
                throw GeminiError.responseEmpty
            }
            
            return responseText
        } catch {
            throw GeminiError.networkError(error)
        }
    }
}
