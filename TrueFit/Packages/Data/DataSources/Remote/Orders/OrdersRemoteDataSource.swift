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
        var targetQueryStr = ""
        if orderId.starts(with: "gid://") {
            if let orders = try? await fetchOrders(customerAccessToken: customerAccessToken),
               let match = orders.first(where: { $0.node.fragments.orderListFields.id == orderId }) {
                targetQueryStr = "name:\(match.node.fragments.orderListFields.name)"
            } else {
                let cleanId = orderId.components(separatedBy: "/").last ?? orderId
                targetQueryStr = "name:#\(cleanId)"
            }
        } else if orderId.starts(with: "#") {
            targetQueryStr = "name:\(orderId)"
        } else {
            targetQueryStr = "name:#\(orderId)"
        }
        let query = GetCustomerOrderDetailsQuery(customerAccessToken: customerAccessToken, orderQuery: targetQueryStr)
        let data = try await apollo.fetch(query: query)
        
        guard let firstEdge = data.customer?.orders.edges.first else {
            throw APIError.noData
        }
        
        let orderDetailsFields = firstEdge.node.fragments.orderDetailsFields
        
        return orderDetailsFields
    }
}
