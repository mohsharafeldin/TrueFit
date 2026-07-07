//
//  OrdersRemoteDataSourceProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation
import ShopifyAPI

protocol OrdersRemoteDataSourceProtocol {
    func fetchOrders(customerAccessToken: String) async throws -> [GetCustomerOrdersListQuery.Data.Customer.Orders.Edge]
    func fetchOrderDetails(customerAccessToken: String, orderId: String) async throws -> OrderDetailsFields
}
