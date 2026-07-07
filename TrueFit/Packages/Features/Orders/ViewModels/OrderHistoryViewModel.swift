//
//  OrderHistoryViewModel.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation
import SwiftUI

@MainActor
class OrderHistoryViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var selectedStatus: OrderStatus = .all
    
    private let fetchOrdersUseCase: FetchOrdersUseCase
    private let authManager: AuthManagerProtocol
    
    init(fetchOrdersUseCase: FetchOrdersUseCase, authManager: AuthManagerProtocol) {
        self.fetchOrdersUseCase = fetchOrdersUseCase
        self.authManager = authManager
    }
    
    var isGuest: Bool {
        authManager.getAccessToken() == nil
    }
    
    var filteredOrders: [Order] {
        if selectedStatus == .all {
            return orders
        } else {
            return orders.filter { $0.status == selectedStatus }
        }
    }
    
    func onAppear() {
        if !isGuest {
            fetchOrders()
        }
    }
    
    func fetchOrders() {
        guard !isGuest else { return }
        
        Task {
            isLoading = true
            errorMessage = nil
            do {
                self.orders = try await fetchOrdersUseCase.execute()
            } catch let error as AppError {
                self.errorMessage = error.localizedDescription
                print("OrderHistoryViewModel: AppError: \(error)")
            } catch {
                self.errorMessage = "An unexpected error occurred."
                print("OrderHistoryViewModel: Unknown error: \(error)")
            }
            isLoading = false
        }
    }
}
