//
//  OrderDetails.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation

struct OrderDetails {
    let orderNumber: String
    let date: String
    let status: OrderStatus
    let items: [OrderItem]
    let subtotal: Double
    let shippingFee: Double
    let discount: Double
    let total: Double
    let shippingAddress: String
    let paymentMethod: String
}
