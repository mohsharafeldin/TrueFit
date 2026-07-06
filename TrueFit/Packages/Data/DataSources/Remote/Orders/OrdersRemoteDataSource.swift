//
//  OrdersRemoteDataSource.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation
import ShopifyAPI

final class OrdersRemoteDataSource: OrdersRemoteDataSourceProtocol {
    private let apollo: ApolloManager
    
    init(apollo: ApolloManager) {
        self.apollo = apollo
    }
    
    func fetchOrders(customerAccessToken: String) async throws -> [GetCustomerOrdersListQuery.Data.Customer.Orders.Edge] {
        let query = GetCustomerOrdersListQuery(customerAccessToken: customerAccessToken, first: 50)
        let data = try await apollo.fetch(query: query)
        
        guard let edges = data.customer?.orders.edges else {
            throw APIError.noData
        }
        
        return edges
    }
    
    func fetchOrderDetails(customerAccessToken: String, orderId: String) async throws -> OrderDetailsFields {
        // Use query string to filter orders by the specific global ID
        let orderQueryStr = "id:\(orderId)"
        let query = GetCustomerOrderDetailsQuery(customerAccessToken: customerAccessToken, orderQuery: orderQueryStr)
        let data = try await apollo.fetch(query: query)
        
        guard let firstEdge = data.customer?.orders.edges.first else {
            throw APIError.noData
        }
        
        let orderDetailsFields = firstEdge.node.fragments.orderDetailsFields
        
        return orderDetailsFields
    }
}
