//
//  OrderDetailsViewModel.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation
import SwiftUI

@MainActor
class OrderDetailsViewModel: ObservableObject {
    @Published var orderDetails: OrderDetails?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let fetchOrderDetailsUseCase: FetchOrderDetailsUseCase
    private let orderId: String
    
    init(fetchOrderDetailsUseCase: FetchOrderDetailsUseCase, orderId: String) {
        self.fetchOrderDetailsUseCase = fetchOrderDetailsUseCase
        self.orderId = orderId
    }
    
    func onAppear() {
        fetchOrderDetails()
    }
    
    func fetchOrderDetails() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                self.orderDetails = try await fetchOrderDetailsUseCase.execute(orderId: orderId)
            } catch let error as AppError {
                self.errorMessage = error.localizedDescription
                print("OrderDetailsViewModel: AppError: \(error)")
            } catch {
                self.errorMessage = "An unexpected error occurred."
                print("OrderDetailsViewModel: Unknown error: \(error)")
            }
            isLoading = false
        }
    }
}
