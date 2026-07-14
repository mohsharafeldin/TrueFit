//
//  OrderCompletedViewModel.swift
//  TrueFit
//
//  Created by mohamed sharafeldin on 06/07/2026.
//

import Foundation
import Combine
import SwiftUI

struct OrderCompletedInfo: Hashable, Equatable {
    let orderNumber: String
    let totalAmountText: String
    let estimatedDeliveryText: String
    let shippingAddressText: String
    
    init(orderNumber: String, totalAmountText: String, estimatedDeliveryText: String, shippingAddressText: String) {
        self.orderNumber = orderNumber
        self.totalAmountText = totalAmountText
        self.estimatedDeliveryText = estimatedDeliveryText
        self.shippingAddressText = shippingAddressText
    }
}

@MainActor
final class OrderCompletedViewModel: ObservableObject {
    @Published var info: OrderCompletedInfo
    @Published var showTrackingToast: Bool = false
    
    init(info: OrderCompletedInfo) {
        self.info = info
    }
    
    func trackOrder(appRouter: AppRouter) {
        let orderId = info.orderNumber // This should ideally be a valid Global ID, but we can pass the string
        appRouter.navigate(to: .orderDetails(orderId: orderId))
    }
}
