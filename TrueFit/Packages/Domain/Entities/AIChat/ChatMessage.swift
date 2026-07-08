//
//  ChatMessage.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

struct ChatBootMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let date: Date
    
    init(text: String, isUser: Bool, date: Date = Date()) {
        self.text = text
        self.isUser = isUser
        self.date = date
    }
}
