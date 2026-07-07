//
//  Bundle+Gemini.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

extension Bundle {
    var geminiAPIKey: String {
        guard let key = object(forInfoDictionaryKey: "GeminiAPIKey") as? String,
              !key.isEmpty,
              key != "YOUR_API_KEY_HERE" else {
            
            #if DEBUG
            fatalError("GeminiAPIKey is missing. Please add it to your Config.xcconfig file.")
            #else
            return ""
            #endif
        }
        return key
    }
}
