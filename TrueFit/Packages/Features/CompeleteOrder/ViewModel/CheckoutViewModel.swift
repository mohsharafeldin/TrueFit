//
//  CheckoutViewModel.swift
//  TrueFit
//
//  Created by mohamed sharafeldin on 06/07/2026.
//

import Foundation
import Combine
import SwiftUI

struct DeliveryOption: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let priceText: String
    let priceAmount: Decimal
    
    static let standard = DeliveryOption(id: "standard", title: "Standard", subtitle: "3–5 business days", priceText: "$12", priceAmount: 12)
    static let express = DeliveryOption(id: "express", title: "Express", subtitle: "Next business day", priceText: "$24", priceAmount: 24)
}

struct PaymentMethod: Identifiable, Equatable {
    let id: String
    let title: String
    let iconName: String
    let isApplePay: Bool
    
    static let visa = PaymentMethod(id: "visa", title: "Visa ending 4242", iconName: "creditcard", isApplePay: false)
    static let applePay = PaymentMethod(id: "applePay", title: "Apple Pay", iconName: "applelogo", isApplePay: true)
    static let cashOnDelivery = PaymentMethod(id: "cashOnDelivery", title: "Cash on delivery", iconName: "banknote", isApplePay: false)
}

@MainActor
final class CheckoutViewModel: ObservableObject {
    @Published var shippingName: String = "Eliza Hart"
    @Published var shippingAddressLine: String = "184 Linden Avenue, Apt 4B"
    @Published var shippingCityState: String = "Brooklyn, NY 11217"
    @Published var isAlternateAddress: Bool = false
    
    @Published var selectedDeliveryOption: DeliveryOption = .standard
    @Published var selectedPaymentMethod: PaymentMethod = .visa
    @Published var isPlacingOrder: Bool = false
    @Published var isLoadingCart: Bool = false
    
    @Published private var cartSubtotal: Decimal = 512.00
    
    private let getCartUseCase: GetCartUseCase?
    private var preferencesManager: PreferencesManagerProtocol?
    
    let deliveryOptions: [DeliveryOption] = [.standard, .express]
    let paymentMethods: [PaymentMethod] = [.visa, .applePay, .cashOnDelivery]
    
    init(getCartUseCase: GetCartUseCase? = nil, preferencesManager: PreferencesManagerProtocol? = nil) {
        self.getCartUseCase = getCartUseCase
        self.preferencesManager = preferencesManager
    }
    
    func loadCartData() async {
        guard let getCartUseCase = getCartUseCase,
              let cartId = preferencesManager?.cartId, !cartId.isEmpty else {
            return
        }
        isLoadingCart = true
        defer { isLoadingCart = false }
        
        do {
            let cart = try await getCartUseCase.execute(cartId: cartId)
            if cart.subtotal.amount > 0 {
                self.cartSubtotal = cart.subtotal.amount
            }
        } catch {
            print("Failed to load cart for checkout: \(error)")
        }
    }
    
    func toggleAddress() {
        isAlternateAddress.toggle()
        if isAlternateAddress {
            shippingName = "Eliza Hart"
            shippingAddressLine = "742 Evergreen Terrace, Apt 2A"
            shippingCityState = "Manhattan, NY 10001"
        } else {
            shippingName = "Eliza Hart"
            shippingAddressLine = "184 Linden Avenue, Apt 4B"
            shippingCityState = "Brooklyn, NY 11217"
        }
    }
    
    var totalAmountDecimal: Decimal {
        cartSubtotal + selectedDeliveryOption.priceAmount
    }
    
    var totalAmountText: String {
        PriceFormatter.format(totalAmountDecimal)
    }
    
    var formattedShippingAddress: String {
        "\(shippingAddressLine)\n\(shippingCityState)"
    }
    
    var shortShippingAddress: String {
        let street = shippingAddressLine.components(separatedBy: ",").first ?? shippingAddressLine
        let city = shippingCityState.components(separatedBy: ",").first ?? "Brooklyn"
        return "\(street), \(city)"
    }
    
    var estimatedDeliveryDateRangeText: String {
        let calendar = Calendar.current
        let today = Date()
        let startDays = selectedDeliveryOption.id == "express" ? 1 : 3
        let endDays = selectedDeliveryOption.id == "express" ? 2 : 5
        
        guard let startDate = calendar.date(byAdding: .day, value: startDays, to: today),
              let endDate = calendar.date(byAdding: .day, value: endDays, to: today) else {
            return "Jun 26 — Jun 28"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let startStr = formatter.string(from: startDate)
        let endStr = formatter.string(from: endDate)
        return "\(startStr) — \(endStr)"
    }
    
    func placeOrder(appRouter: AppRouter, cartState: CartState) {
        isPlacingOrder = true
        
        let orderNumber = "ORD-\(Int.random(in: 1000...9999))"
        let totalText = totalAmountText
        let deliveryText = estimatedDeliveryDateRangeText
        let addressText = shortShippingAddress
        
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            
            await MainActor.run {
                self.isPlacingOrder = false
                self.preferencesManager?.cartId = nil
                cartState.updateCount(0)
                
                let info = OrderCompletedInfo(
                    orderNumber: orderNumber,
                    totalAmountText: totalText,
                    estimatedDeliveryText: deliveryText,
                    shippingAddressText: addressText
                )
                appRouter.navigate(to: .orderCompleted(info))
            }
        }
    }
}
