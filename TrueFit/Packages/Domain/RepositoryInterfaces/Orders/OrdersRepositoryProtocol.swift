//
//  OrdersRepositoryProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation

protocol OrdersRepositoryProtocol {
    func fetchOrders() async throws -> [Order]
    func fetchOrderDetails(orderId: String) async throws -> OrderDetails
}
