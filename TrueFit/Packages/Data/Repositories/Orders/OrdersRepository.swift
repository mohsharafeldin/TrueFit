//
//  OrdersRepository.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation
import ShopifyAPI

final class OrdersRepository: OrdersRepositoryProtocol {
    private let remoteDataSource: OrdersRemoteDataSourceProtocol
    private let authManager: AuthManagerProtocol
    
    init(remoteDataSource: OrdersRemoteDataSourceProtocol, authManager: AuthManagerProtocol) {
        self.remoteDataSource = remoteDataSource
        self.authManager = authManager
    }
    
    func fetchOrders() async throws -> [Order] {
        guard let token = await authManager.getAccessToken() else {
            throw AppError.unauthorized
        }
        
        do {
            let edges = try await remoteDataSource.fetchOrders(customerAccessToken: token)
            return OrderMapper.mapList(edges)
        } catch let apiError as APIError {
            throw APIErrorMapper.map(apiError)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func fetchOrderDetails(orderId: String) async throws -> OrderDetails {
        guard let token = await authManager.getAccessToken() else {
            throw AppError.unauthorized
        }
        
        do {
            let orderDetailsFields = try await remoteDataSource.fetchOrderDetails(customerAccessToken: token, orderId: orderId)
            return OrderMapper.mapDetails(orderDetailsFields)
        } catch let apiError as APIError {
            throw APIErrorMapper.map(apiError)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
