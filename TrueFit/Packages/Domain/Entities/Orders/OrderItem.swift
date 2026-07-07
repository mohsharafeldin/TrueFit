//
//  OrderItem.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation

struct OrderItem: Identifiable {
    let id: String
    let title: String
    let variant: String
    let price: Double
    let quantity: Int
    let imageURL: URL?
}
