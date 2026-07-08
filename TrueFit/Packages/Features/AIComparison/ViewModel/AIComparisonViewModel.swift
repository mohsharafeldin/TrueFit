import Foundation
import Combine

struct AIComparisonResult: Codable, Equatable {
    struct ProductAnalysis: Codable, Equatable {
        let productId: String
        let title: String
        let summary: String
        let pros: [String]
        let cons: [String]
        let bestFor: String
    }
    let analyses: [ProductAnalysis]
    let overallSummary: String
}

struct AIFollowUpResult: Codable, Equatable {
    struct KeyPoint: Codable, Equatable, Hashable {
        let pointTitle: String
        let pointDescription: String
    }
    let title: String
    let explanation: String
    let keyPoints: [KeyPoint]
}

@MainActor
class AIComparisonViewModel: ObservableObject {
    let products: [Product]
    
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var comparisonResult: AIComparisonResult? = nil
    @Published var hasStructuredResult: Bool = false
    
    init(products: [Product]) {
        self.products = products
        startComparison()
    }
    
    func startComparison() {
        guard !products.isEmpty else { return }
        
        var promptText = """
        You are an expert shopping assistant. Compare the following products and output your response EXCLUSIVELY in valid JSON format using the exact schema below. Do not include markdown code blocks (like ```json), just return the raw JSON object.

        {
            "analyses": [
                {
                    "productId": "<string>",
                    "title": "<string>",
                    "summary": "<string>",
                    "pros": ["<string>"],
                    "cons": ["<string>"],
                    "bestFor": "<string>"
                }
            ],
            "overallSummary": "<string>"
        }

        Here are the products:

        """
        
        for product in products {
            promptText += "Product ID: \(product.id)\n"
            promptText += "Title: \(product.title)\n"
            promptText += "Price: \(product.price)\n"
            promptText += "Vendor: \(product.vendor ?? "N/A")\n\n"
        }
        
        // Hide the prompt message from the UI usually, or we can just append it
        messages.append(ChatMessage(role: .user, text: promptText))
        fetchInitialComparison(prompt: promptText)
    }
    
    func sendMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        messages.append(ChatMessage(role: .user, text: text))
        fetchFollowUpResponse()
    }
    
    private func fetchInitialComparison(prompt: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let responseText = try await GeminiService.shared.generateContent(messages: messages)
                
                // Try parsing JSON
                let cleanText = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "```json", with: "")
                    .replacingOccurrences(of: "```", with: "")
                
                if let data = cleanText.data(using: .utf8) {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(AIComparisonResult.self, from: data)
                        self.comparisonResult = result
                        self.hasStructuredResult = true
                    } catch {
                        print("Failed to decode JSON: \(error)")
                        // Fallback to text
                        messages.append(ChatMessage(role: .model, text: responseText))
                    }
                } else {
                    messages.append(ChatMessage(role: .model, text: responseText))
                }
            } catch {
                errorMessage = "Failed to get a response from AI. Please make sure the API key is set."
                print(error)
            }
            isLoading = false
        }
    }
    
    private func fetchFollowUpResponse() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                var apiMessages = messages
                if let last = apiMessages.last {
                    let enhancedPrompt = """
                    \(last.text)
                    
                    Please answer the user's question. Output your response EXCLUSIVELY in valid JSON format using the exact schema below. Do not include markdown code blocks (like ```json), just return the raw JSON object.
                    
                    {
                        "title": "<Short title of your answer>",
                        "explanation": "<Detailed explanation>",
                        "keyPoints": [
                            {
                                "pointTitle": "<string>",
                                "pointDescription": "<string>"
                            }
                        ]
                    }
                    """
                    apiMessages[apiMessages.count - 1] = ChatMessage(role: .user, text: enhancedPrompt)
                }
                
                let responseText = try await GeminiService.shared.generateContent(messages: apiMessages)
                
                let cleanText = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "```json", with: "")
                    .replacingOccurrences(of: "```", with: "")
                
                messages.append(ChatMessage(role: .model, text: cleanText))
            } catch {
                errorMessage = "Failed to get a response from AI."
                print(error)
            }
            isLoading = false
        }
    }
}
