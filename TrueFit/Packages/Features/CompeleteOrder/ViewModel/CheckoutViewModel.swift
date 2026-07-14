//
//  CheckoutViewModel.swift
//  TrueFit
//
//  Created by mohamed sharafeldin on 06/07/2026.
//

import Foundation
import Combine
import SwiftUI
import PassKit

struct DeliveryOption: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let priceAmount: Decimal
    
    var priceText: String {
        PriceFormatter.format(priceAmount)
    }
    
    static let standard = DeliveryOption(id: "standard", title: "Standard", subtitle: "3–5 business days", priceAmount: 12)
    static let express = DeliveryOption(id: "express", title: "Express", subtitle: "Next business day", priceAmount: 24)
}

@MainActor
final class CheckoutViewModel: ObservableObject {
    @Published var selectedAddress: Address? = nil
    @Published var errorMessage: String? = nil
    
    @Published var shippingName: String = ""
    @Published var shippingAddressLine: String = ""
    @Published var shippingCityState: String = ""
    @Published var isAlternateAddress: Bool = false
    
    @Published var selectedDeliveryOption: DeliveryOption = .standard
    @Published var selectedPaymentMethod: PaymentMethodType = .applePay
    @Published var isApplePayAvailable: Bool = false
    @Published var isPlacingOrder: Bool = false
    @Published var isLoadingCart: Bool = false
    
    @Published private var cartSubtotal: Decimal = 512.00
    
    private let getCartUseCase: GetCartUseCase?
    private let getAddressesUseCase: GetAddressesUseCase?
    private let processPaymentUseCase: ProcessPaymentUseCase?
    private let authManager: AuthManagerProtocol?
    private var preferencesManager: PreferencesManagerProtocol?
    
    let deliveryOptions: [DeliveryOption] = [.standard, .express]
    
    init(
        getCartUseCase: GetCartUseCase? = nil,
        getAddressesUseCase: GetAddressesUseCase? = nil,
        processPaymentUseCase: ProcessPaymentUseCase? = nil,
        authManager: AuthManagerProtocol? = nil,
        preferencesManager: PreferencesManagerProtocol? = nil
    ) {
        self.getCartUseCase = getCartUseCase
        self.getAddressesUseCase = getAddressesUseCase
        self.processPaymentUseCase = processPaymentUseCase
        self.authManager = authManager
        self.preferencesManager = preferencesManager
        self.isApplePayAvailable = checkApplePayAvailability()
    }
    
    private func checkApplePayAvailability() -> Bool {
        PKPaymentAuthorizationController.canMakePayments(
            usingNetworks: PaymentConfiguration.supportedNetworks
        )
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
    
    func loadInitialData() async {
        await loadCartData()
        await loadDefaultAddress()
    }
    
    func loadDefaultAddress() async {
        guard selectedAddress == nil,
              let getAddressesUseCase = getAddressesUseCase,
              let token = authManager?.getAccessToken() else {
            return
        }
        
        do {
            let addresses = try await getAddressesUseCase(customerAccessToken: token)
            if let first = addresses.first {
                self.updateShippingAddress(first)
            }
        } catch {
            print("Failed to fetch default address: \(error)")
        }
    }
    
    func updateShippingAddress(_ address: Address) {
        selectedAddress = address
        if let encoded = try? JSONEncoder().encode(address) {
            UserDefaults.standard.set(encoded, forKey: "lastUsedShippingAddress")
        }
        shippingName = "Eliza Hart"
        shippingAddressLine = "\(address.address1)"
        shippingCityState = "\(address.city), \(address.province) \(address.zip)"
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
        guard selectedAddress != nil else {
            self.errorMessage = "Please add or select a shipping address before placing your order."
            return
        }
        isPlacingOrder = true
        
        let pmText = selectedPaymentMethod == .applePay ? "**** **** **** 4242\nApple Pay" : "Cash on delivery"
        UserDefaults.standard.set(pmText, forKey: "lastUsedPaymentMethod")
        
        let deliveryText = estimatedDeliveryDateRangeText
        let addressText = shortShippingAddress
        let totalText = totalAmountText
        
        Task {
            do {
                guard let getCartUseCase = self.getCartUseCase,
                      let cartId = self.preferencesManager?.cartId, !cartId.isEmpty else {
                    throw NSError(domain: "Checkout", code: -1, userInfo: [NSLocalizedDescriptionKey: "Cart not found"])
                }
                
                let cart = try await getCartUseCase.execute(cartId: cartId)
                
                let orderService = OrderCreationService()
                let orderNumber = try await orderService.createOrder(cart: cart, shippingAddress: self.selectedAddress)
                
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
            } catch {
                print("Failed to place order: \(error)")
                await MainActor.run {
                    self.isPlacingOrder = false
                    if let appError = error as? AppError {
                        self.errorMessage = appError.userMessage
                    } else if let orderError = error as? OrderCreationError {
                        switch orderError {
                        case .apiError(let msg):
                            self.errorMessage = "Could not place order: \(msg)"
                        case .missingCredentials:
                            self.errorMessage = "Store configuration is missing."
                        case .invalidURL, .invalidResponse:
                            self.errorMessage = "Failed to communicate with store server."
                        }
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func startApplePayment(appRouter: AppRouter, cartState: CartState) {
        guard selectedAddress != nil else {
            self.errorMessage = "Please add or select a shipping address before placing your order."
            return
        }
        guard isApplePayAvailable else {
            self.errorMessage = PaymentError.applePayUnavailable.errorDescription
            return
        }
        guard totalAmountDecimal > 0 else {
            self.errorMessage = PaymentError.invalidRequest.errorDescription
            return
        }
        
        isPlacingOrder = true
        
        let convertedAmount = CurrencyManager.shared.convert(totalAmountDecimal)
        let currencyCode = CurrencyManager.shared.selectedCurrency
        
        let summaryItem = PKPaymentSummaryItem(
            label: "TrueFit Order",
            amount: NSDecimalNumber(decimal: convertedAmount)
        )
        let merchantItem = PKPaymentSummaryItem(
            label: PaymentConfiguration.merchantDisplayName,
            amount: NSDecimalNumber(decimal: convertedAmount)
        )
        
        let dto = PaymentRequestDTO(
            merchantIdentifier: PaymentConfiguration.merchantIdentifier,
            supportedNetworks: PaymentConfiguration.supportedNetworks,
            merchantCapabilities: PaymentConfiguration.merchantCapabilities,
            countryCode: PaymentConfiguration.countryCode,
            currencyCode: currencyCode,
            paymentSummaryItems: [summaryItem, merchantItem]
        )
        
        Task {
            do {
                if let processPayment = processPaymentUseCase {
                    let result = try await processPayment(request: dto)
                    switch result {
                    case .success:
                        await MainActor.run {
                            self.placeOrder(appRouter: appRouter, cartState: cartState)
                        }
                    case .cancelled:
                        await MainActor.run {
                            self.isPlacingOrder = false
                        }
                    case .failed(let reason):
                        await MainActor.run {
                            self.isPlacingOrder = false
                            self.errorMessage = reason
                        }
                    }
                } else {
                    await MainActor.run {
                        self.placeOrder(appRouter: appRouter, cartState: cartState)
                    }
                }
            } catch let error as PaymentError {
                await MainActor.run {
                    self.isPlacingOrder = false
                    self.errorMessage = error.errorDescription
                }
            } catch {
                await MainActor.run {
                    self.isPlacingOrder = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func startCashOnDelivery(appRouter: AppRouter, cartState: CartState) {
        guard selectedAddress != nil else {
            self.errorMessage = "Please add or select a shipping address before placing your order."
            return
        }
        guard totalAmountDecimal > 0 else {
            self.errorMessage = PaymentError.invalidRequest.errorDescription
            return
        }
        
        isPlacingOrder = true
        
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            await MainActor.run {
                self.placeOrder(appRouter: appRouter, cartState: cartState)
            }
        }
    }
}
