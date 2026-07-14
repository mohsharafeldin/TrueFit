//
//  Order.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation

struct Order: Identifiable {
    let id: String
    let orderNumber: String
    let date: String
    let totalAmount: Double
    let status: OrderStatus
    let itemImageURLs: [URL?]
    let totalItemsCount: Int
}
