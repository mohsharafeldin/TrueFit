//
//  OrderMapper.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import Foundation
import ShopifyAPI

enum OrderMapper {
    
    // MARK: - List Mapper
    
    static func mapList(_ edges: [GetCustomerOrdersListQuery.Data.Customer.Orders.Edge]) -> [Order] {
        return edges.map { mapList($0.node.fragments.orderListFields) }
    }
    
    static func mapList(_ fields: OrderListFields) -> Order {
        let financial = fields.financialStatus?.rawValue
        let fulfillment = fields.fulfillmentStatus.rawValue
        let status = mapStatus(financial: financial, fulfillment: fulfillment, cancelledAt: nil)
        
        var imageURLs: [Foundation.URL?] = []
        if let firstEdge = fields.lineItems.edges.first {
            if let urlStr = firstEdge.node.variant?.image?.url, let url = Foundation.URL(string: urlStr) {
                imageURLs.append(url)
            }
        }
        
        let amountStr = fields.currentTotalPrice.fragments.moneyFields.amount
        let amount = Double(amountStr) ?? 0
        
        return Order(
            id: fields.id,
            orderNumber: fields.name,
            date: formatDate(fields.processedAt),
            totalAmount: amount,
            status: status,
            itemImageURLs: imageURLs,
            totalItemsCount: fields.lineItems.edges.count // Approximate for list
        )
    }
    
    // MARK: - Details Mapper
    
    static func mapDetails(_ fields: OrderDetailsFields) -> OrderDetails {
        let financial = fields.financialStatus?.rawValue
        let fulfillment = fields.fulfillmentStatus.rawValue
        let cancelledAtStr = fields.canceledAt
        let status = mapStatus(financial: financial, fulfillment: fulfillment, cancelledAt: cancelledAtStr?.isEmpty == false ? cancelledAtStr : nil)
        
        let items = fields.lineItems.edges.map { mapLineItem($0.node) }
        
        let subtotal = Double(fields.currentSubtotalPrice.fragments.moneyFields.amount) ?? 0
        let total = Double(fields.currentTotalPrice.fragments.moneyFields.amount) ?? 0
        let shippingFee = Double(fields.totalShippingPrice.fragments.moneyFields.amount) ?? 0
        let discount = 0.0
        
        let paymentMethodStr = UserDefaults.standard.string(forKey: "lastUsedPaymentMethod") ?? "**** **** **** 4242\nApple Pay"
        
        return OrderDetails(
            orderNumber: fields.name,
            date: formatDate(fields.processedAt),
            status: status,
            items: items,
            subtotal: subtotal,
            shippingFee: shippingFee,
            discount: discount,
            total: total,
            shippingAddress: formatAddress(fields.shippingAddress),
            paymentMethod: paymentMethodStr
        )
    }
    
    private static func mapLineItem(_ node: OrderDetailsFields.LineItems.Edge.Node) -> OrderItem {
        let variantUrl = node.variant?.image?.url
        let price = Double(node.discountedTotalPrice.fragments.moneyFields.amount) ?? 0
        
        return OrderItem(
            id: node.variant?.id ?? UUID().uuidString,
            title: node.variant?.title ?? node.title,
            variant: node.variant?.title ?? "",
            price: price,
            quantity: node.quantity,
            imageURL: variantUrl != nil ? Foundation.URL(string: variantUrl!) : nil
        )
    }
    
    // MARK: - Helpers
    
    private static func mapStatus(financial: String?, fulfillment: String?, cancelledAt: String?) -> OrderStatus {
        if cancelledAt != nil || financial == "REFUNDED" || financial == "VOIDED" {
            return .cancelled
        }
        
        if fulfillment == "FULFILLED" {
            return .delivered
        }
        
        if fulfillment == "PARTIALLY_FULFILLED" || fulfillment == "IN_PROGRESS" {
            return .shipped
        }
        
        if financial == "PAID" {
            return .processing
        }
        
        return .processing
    }
    
    private static func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM dd, yyyy • hh:mm a"
            return displayFormatter.string(from: date)
        }
        return isoString
    }
    
    private static func formatAddress(_ address: OrderDetailsFields.ShippingAddress?) -> String {
        var components = [String]()
        if let addr = address {
            if let a1 = addr.address1, !a1.isEmpty { components.append(a1) }
            if let a2 = addr.address2, !a2.isEmpty { components.append(a2) }
            if let city = addr.city, !city.isEmpty { components.append(city) }
            if let prov = addr.province, !prov.isEmpty { components.append(prov) }
            if let zip = addr.zip, !zip.isEmpty { components.append(zip) }
            if let country = addr.country, !country.isEmpty { components.append(country) }
        }
        
        if components.isEmpty {
            if let data = UserDefaults.standard.data(forKey: "lastUsedShippingAddress"),
               let addr = try? JSONDecoder().decode(Address.self, from: data) {
                return "\(addr.address1), \(addr.city), \(addr.province) \(addr.zip), \(addr.country)"
            }
            return "123 Main Street, Apt 4B, New York, NY 10001, USA"
        }
        return components.joined(separator: ", ")
    }
}
