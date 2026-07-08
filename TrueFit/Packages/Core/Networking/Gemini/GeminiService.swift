//
//  GeminiService.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation
import GoogleGenerativeAI

final class GeminiService: GeminiServiceProtocol {
    private let modelName = "models/gemini-2.5-flash"
    
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
        
        // Explicitly set the API version to "v1" instead of the default "v1beta"
        let requestOptions = RequestOptions(apiVersion: "v1")
        
        // Initialize the generative model WITHOUT the systemInstruction field
        // as the v1 endpoint does not support it for this model.
        let model = GenerativeModel(
            name: modelName,
            apiKey: apiKey,
            generationConfig: config,
            requestOptions: requestOptions
        )
        
        // Inject system instructions (System Prompt) as the first turn in the conversation history
        // to bypass the unsupported "system_instruction" JSON payload issue.
        var mappedHistory: [ModelContent] = [
            ModelContent(role: "user", parts: [.text(systemPrompt)]),
            ModelContent(role: "model", parts: [.text("Understood. I am the TrueFit shopping assistant and will strictly follow these instructions and only recommend products from the provided catalog.")])
        ]
        
        // Map our app's message models to the format understood by the Google SDK
        let actualHistory = history.map { message in
            let role = message.isUser ? "user" : "model"
            return ModelContent(role: role, parts: [.text(message.text)])
        }
        
        mappedHistory.append(contentsOf: actualHistory)
        
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
