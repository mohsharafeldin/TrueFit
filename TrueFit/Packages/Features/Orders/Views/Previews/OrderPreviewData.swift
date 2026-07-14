//
//  OrderPreviewData.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation

#if DEBUG
struct OrderPreviewData {
    static let mockOrders: [Order] = [
        Order(id: "1", orderNumber: "#TF-90283", date: "Oct 24, 2026 • 10:30 AM", totalAmount: 145.99, status: .processing, itemImageURLs: [URL(string: "https://example.com/1"), URL(string: "https://example.com/2")], totalItemsCount: 2),
        Order(id: "2", orderNumber: "#TF-87120", date: "Oct 12, 2026 • 02:15 PM", totalAmount: 89.50, status: .shipped, itemImageURLs: [URL(string: "https://example.com/3")], totalItemsCount: 1),
        Order(id: "3", orderNumber: "#TF-75211", date: "Sep 05, 2026 • 08:45 PM", totalAmount: 320.00, status: .delivered, itemImageURLs: [URL(string: "https://example.com/4"), URL(string: "https://example.com/5"), URL(string: "https://example.com/6"), URL(string: "https://example.com/7")], totalItemsCount: 5),
        Order(id: "4", orderNumber: "#TF-66329", date: "Aug 20, 2026 • 11:20 AM", totalAmount: 45.00, status: .cancelled, itemImageURLs: [URL(string: "https://example.com/8")], totalItemsCount: 1)
    ]
    
    static let mockOrderDetails = OrderDetails(
        orderNumber: "#TF-75211",
        date: "Sep 05, 2026 • 08:45 PM",
        status: .shipped,
        items: [
            OrderItem(id: "p1", title: "Nike Air Max 270", variant: "Size: 42 | Color: White", price: 150.00, quantity: 1, imageURL: URL(string: "https://example.com/shoe1")),
            OrderItem(id: "p2", title: "Adidas UltraBoost", variant: "Size: 41 | Color: Core Black", price: 180.00, quantity: 2, imageURL: URL(string: "https://example.com/shoe2"))
        ],
        subtotal: 510.00,
        shippingFee: 15.00,
        discount: 25.00,
        total: 500.00,
        shippingAddress: "123 Main Street, Apt 4B, New York, NY 10001",
        paymentMethod: "**** **** **** 4242\nApple Pay"
    )
}
#endif
