//
//  User.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public struct User: Equatable, Codable {
    public let id: String
    public let email: String
    public let firstName: String
    public let lastName: String
    public let shopifyCustomerId: String
    
    public init(id: String, email: String, firstName: String, lastName: String, shopifyCustomerId: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.shopifyCustomerId = shopifyCustomerId
    }
}

