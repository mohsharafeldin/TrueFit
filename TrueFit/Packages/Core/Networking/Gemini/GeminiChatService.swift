//
//  GeminiService.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation
import GoogleGenerativeAI

final class GeminiChatService: GeminiChatServiceProtocol {
    private let modelName = "models/gemini-2.5-flash"
    
    func sendMessage(_ text: String, history: [ChatBootMessage], systemPrompt: String) async throws -> String {
        let apiKey = Bundle.main.geminiAPIKey
        
        // Ensure the API Key is available and valid
        guard !apiKey.isEmpty, apiKey != "YOUR_API_KEY_HERE" else {
            throw GeminiError.invalidAPIKey
        }
        
        // Model configuration
        let config = GenerationConfig(
            temperature: 0.7
        )
        
        // Use native systemInstruction available in v1beta endpoint
        let systemContent = ModelContent(role: "system", parts: [.text(systemPrompt)])
        
        // Initialize the generative model using default v1beta which supports systemInstruction
        let model = GenerativeModel(
            name: modelName,
            apiKey: apiKey,
            generationConfig: config,
            systemInstruction: systemContent
        )
        
        // Map our app's message models to the format understood by the Google SDK
        let mappedHistory = history.map { message in
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
        } catch let geminiError as GeminiError {
            throw geminiError
        } catch let error as GenerateContentError {
            if case .responseStoppedEarly(let reason, let response) = error {
                print("🚨 GEMINI STOPPED EARLY! Reason: \(reason)")
                print("🚨 Response text (if any): \(response.text ?? "nil")")
            } else {
                print("🚨 GEMINI ERROR CASE: \(error)")
            }
            throw GeminiError.networkError(error)
        } catch {
            let nsError = error as NSError
            print("🚨 DETAILED GEMINI ERROR:")
            print("Domain: \(nsError.domain)")
            print("Code: \(nsError.code)")
            print("User Info: \(nsError.userInfo)")
            throw GeminiError.networkError(error)
        }
    }
}
