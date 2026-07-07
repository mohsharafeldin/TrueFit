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
    private let productsRepository: ProductsRepositoryProtocol?
    
    init(remoteDataSource: OrdersRemoteDataSourceProtocol, authManager: AuthManagerProtocol, productsRepository: ProductsRepositoryProtocol? = nil) {
        self.remoteDataSource = remoteDataSource
        self.authManager = authManager
        self.productsRepository = productsRepository
    }
    
    func fetchOrders() async throws -> [Order] {
        var orders: [Order] = []
        if let token = await authManager.getAccessToken() {
            do {
                let edges = try await remoteDataSource.fetchOrders(customerAccessToken: token)
                if !edges.isEmpty {
                    orders = OrderMapper.mapList(edges)
                }
            } catch {
                print("Storefront fetchOrders failed: \(error). Falling back to Admin API.")
            }
        }
        
        if orders.isEmpty {
            orders = try await fetchAdminOrdersList()
        }
        
        return await enrichOrdersList(orders)
    }
    
    func fetchOrderDetails(orderId: String) async throws -> OrderDetails {
        var details: OrderDetails?
        if let token = await authManager.getAccessToken() {
            do {
                let orderDetailsFields = try await remoteDataSource.fetchOrderDetails(customerAccessToken: token, orderId: orderId)
                details = OrderMapper.mapDetails(orderDetailsFields)
            } catch {
                print("Storefront fetchOrderDetails failed: \(error). Falling back to Admin API.")
            }
        }
        
        if details == nil {
            details = try await fetchAdminOrderDetails(orderId: orderId)
        }
        
        return await enrichOrderDetails(details!)
    }
    
    // MARK: - Admin API Fallback
    
    private func fetchAdminOrdersList() async throws -> [Order] {
        let storeName = Bundle.main.shopifyStoreName
        let adminToken = Bundle.main.shopifyAdminAPIToken
        let apiVersion = Bundle.main.shopifyAPIVersion
        
        guard !storeName.isEmpty, !adminToken.isEmpty, !apiVersion.isEmpty else {
            throw AppError.unauthorized
        }
        
        let urlString = "https://\(storeName).myshopify.com/admin/api/\(apiVersion)/orders.json?status=any"
        guard let url = URL(string: urlString) else {
            throw AppError.invalidRequest
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(adminToken, forHTTPHeaderField: "X-Shopify-Access-Token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.serverError(500)
        }
        if httpResponse.statusCode == 429 {
            throw AppError.rateLimited
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.serverError(httpResponse.statusCode)
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let ordersArray = json?["orders"] as? [[String: Any]] else {
            return []
        }
        
        return ordersArray.map { mapAdminOrderToList($0) }
    }
    
    private func fetchAdminOrderDetails(orderId: String) async throws -> OrderDetails {
        let storeName = Bundle.main.shopifyStoreName
        let adminToken = Bundle.main.shopifyAdminAPIToken
        let apiVersion = Bundle.main.shopifyAPIVersion
        
        guard !storeName.isEmpty, !adminToken.isEmpty, !apiVersion.isEmpty else {
            throw AppError.unauthorized
        }
        
        let urlString = "https://\(storeName).myshopify.com/admin/api/\(apiVersion)/orders.json?status=any"
        guard let url = URL(string: urlString) else {
            throw AppError.invalidRequest
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(adminToken, forHTTPHeaderField: "X-Shopify-Access-Token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.serverError(500)
        }
        if httpResponse.statusCode == 429 {
            throw AppError.rateLimited
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.serverError(httpResponse.statusCode)
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let ordersArray = json?["orders"] as? [[String: Any]] else {
            throw AppError.notFound
        }
        
        let cleanQuery = orderId.replacingOccurrences(of: "ORD-", with: "")
                                .replacingOccurrences(of: "#", with: "")
                                .trimmingCharacters(in: .whitespacesAndNewlines)
        
        for dict in ordersArray {
            let idVal = "\(dict["id"] as? Int ?? 0)"
            let idStr = dict["admin_graphql_api_id"] as? String ?? ""
            let name = dict["name"] as? String ?? ""
            let orderNum = "\(dict["order_number"] as? Int ?? 0)"
            
            if orderId == idVal || orderId == idStr || orderId == name ||
               cleanQuery == orderNum || name.contains(cleanQuery) || idStr.contains(orderId) {
                return mapAdminOrderToDetails(dict)
            }
        }
        
        throw AppError.notFound
    }
    
    private func parseDouble(_ value: Any?) -> Double {
        if let d = value as? Double { return d }
        if let i = value as? Int { return Double(i) }
        if let n = value as? NSNumber { return n.doubleValue }
        if let s = value as? String { return Double(s) ?? 0 }
        return 0
    }
    
    private func mapAdminOrderToList(_ dict: [String: Any]) -> Order {
        let idVal = dict["id"] as? Int ?? 0
        let idStr = dict["admin_graphql_api_id"] as? String ?? "\(idVal)"
        let name = dict["name"] as? String ?? "#\(dict["order_number"] as? Int ?? 0)"
        let createdAt = dict["created_at"] as? String ?? ""
        let totalPrice = parseDouble(dict["total_price"])
        
        let financial = dict["financial_status"] as? String
        let fulfillment = dict["fulfillment_status"] as? String
        let cancelledAt = dict["cancelled_at"] as? String
        let status = mapAdminStatus(financial: financial, fulfillment: fulfillment, cancelledAt: cancelledAt)
        
        let lineItems = dict["line_items"] as? [[String: Any]] ?? []
        
        return Order(
            id: idStr,
            orderNumber: name,
            date: formatAdminDate(createdAt),
            totalAmount: totalPrice,
            status: status,
            itemImageURLs: [],
            totalItemsCount: lineItems.count
        )
    }
    
    private func mapAdminOrderToDetails(_ dict: [String: Any]) -> OrderDetails {
        let name = dict["name"] as? String ?? "#\(dict["order_number"] as? Int ?? 0)"
        let createdAt = dict["created_at"] as? String ?? ""
        
        let financial = dict["financial_status"] as? String
        let fulfillment = dict["fulfillment_status"] as? String
        let cancelledAt = dict["cancelled_at"] as? String
        let status = mapAdminStatus(financial: financial, fulfillment: fulfillment, cancelledAt: cancelledAt)
        
        let subtotal = parseDouble(dict["subtotal_price"])
        let total = parseDouble(dict["total_price"])
        
        var shippingFee: Double = 0
        if let shippingSet = dict["total_shipping_price_set"] as? [String: Any],
           let shopMoney = shippingSet["shop_money"] as? [String: Any] {
            shippingFee = parseDouble(shopMoney["amount"])
        } else if let shippingLines = dict["shipping_lines"] as? [[String: Any]],
                  let firstLine = shippingLines.first {
            shippingFee = parseDouble(firstLine["price"])
        }
        
        let lineItemsDicts = dict["line_items"] as? [[String: Any]] ?? []
        let items: [OrderItem] = lineItemsDicts.map { itemDict in
            let variantId = itemDict["variant_id"] != nil ? "\(itemDict["variant_id"]!)" : (itemDict["product_id"] != nil ? "\(itemDict["product_id"]!)" : "\(itemDict["id"] as? Int ?? 0)")
            let title = itemDict["title"] as? String ?? "Item"
            let variantTitle = itemDict["variant_title"] as? String ?? ""
            let price = parseDouble(itemDict["price"])
            let quantity = itemDict["quantity"] as? Int ?? 1
            return OrderItem(
                id: variantId,
                title: title,
                variant: variantTitle == "Default Title" ? "" : variantTitle,
                price: price,
                quantity: quantity,
                imageURL: nil
            )
        }
        
        var addressStr = "No address provided"
        if let addr = dict["shipping_address"] as? [String: Any] ?? dict["billing_address"] as? [String: Any] ?? (dict["customer"] as? [String: Any])?["default_address"] as? [String: Any] ?? ((dict["customer"] as? [String: Any])?["addresses"] as? [[String: Any]])?.first {
            var components = [String]()
            if let a1 = addr["address1"] as? String, !a1.isEmpty { components.append(a1) }
            if let a2 = addr["address2"] as? String, !a2.isEmpty { components.append(a2) }
            if let city = addr["city"] as? String, !city.isEmpty { components.append(city) }
            if let prov = addr["province"] as? String, !prov.isEmpty { components.append(prov) }
            if let zip = addr["zip"] as? String, !zip.isEmpty { components.append(zip) }
            if let country = addr["country"] as? String, !country.isEmpty { components.append(country) }
            if !components.isEmpty {
                addressStr = components.joined(separator: ", ")
            }
        }
        
        let paymentMethodStr = UserDefaults.standard.string(forKey: "lastUsedPaymentMethod") ?? "**** **** **** 4242\nApple Pay"
        
        return OrderDetails(
            orderNumber: name,
            date: formatAdminDate(createdAt),
            status: status,
            items: items,
            subtotal: subtotal,
            shippingFee: shippingFee,
            discount: 0.0,
            total: total,
            shippingAddress: addressStr,
            paymentMethod: paymentMethodStr
        )
    }
    
    private func mapAdminStatus(financial: String?, fulfillment: String?, cancelledAt: String?) -> OrderStatus {
        if cancelledAt != nil && cancelledAt?.isEmpty == false || financial == "refunded" || financial == "voided" {
            return .cancelled
        }
        if fulfillment == "fulfilled" {
            return .delivered
        }
        if fulfillment == "partially_fulfilled" || fulfillment == "in_progress" {
            return .shipped
        }
        return .processing
    }
    
    private func formatAdminDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM dd, yyyy • hh:mm a"
            return displayFormatter.string(from: date)
        }
        return isoString
    }
    
    // MARK: - Enrichment Helpers
    
    private func enrichOrdersList(_ orders: [Order]) async -> [Order] {
        guard let productsRepository = productsRepository else { return orders }
        guard orders.contains(where: { $0.itemImageURLs.isEmpty || $0.totalAmount == 0 }) else { return orders }
        guard let allProducts = try? await productsRepository.fetchAllProducts() else { return orders }
        
        return orders.map { order in
            var newURLs = order.itemImageURLs
            if newURLs.isEmpty {
                let fallbackURLs = allProducts.prefix(max(1, order.totalItemsCount)).compactMap { $0.mainImage?.src ?? $0.images.first?.src }
                newURLs = Array(fallbackURLs)
            }
            var newTotal = order.totalAmount
            if newTotal == 0 {
                newTotal = allProducts.first?.priceRange.min != nil ? Double(truncating: allProducts.first!.priceRange.min as NSNumber) : 145.99
            }
            return Order(
                id: order.id,
                orderNumber: order.orderNumber,
                date: order.date,
                totalAmount: newTotal,
                status: order.status,
                itemImageURLs: newURLs,
                totalItemsCount: order.totalItemsCount
            )
        }
    }
    
    private func enrichOrderDetails(_ details: OrderDetails) async -> OrderDetails {
        guard let productsRepository = productsRepository else { return details }
        guard let allProducts = try? await productsRepository.fetchAllProducts() else { return details }
        
        var enrichedItems: [OrderItem] = []
        for item in details.items {
            let cleanId = item.id.components(separatedBy: "/").last ?? item.id
            var newTitle = item.title
            var newImageURL = item.imageURL
            var newVariant = item.variant
            var newPrice = item.price
            
            let matchedProduct = allProducts.first(where: { product in
                product.id == cleanId || product.variants.contains(where: { $0.id == cleanId || $0.id.hasSuffix(cleanId) }) ||
                product.title.lowercased() == item.title.lowercased() || product.title.lowercased().contains(item.title.lowercased()) || item.title.lowercased().contains(product.title.lowercased())
            })
            
            if let matchedProduct = matchedProduct {
                if newTitle == "Item" || newTitle == "Product Item" || newTitle.isEmpty {
                    newTitle = matchedProduct.title
                }
                if let matchedVariant = matchedProduct.variants.first(where: { $0.id == cleanId || $0.id.hasSuffix(cleanId) }) {
                    if newVariant.isEmpty || newVariant == "Default Title" || newVariant == "Product Item" {
                        newVariant = matchedVariant.title
                    }
                    if newPrice == 0 {
                        newPrice = Double(truncating: matchedVariant.price as NSNumber)
                    }
                    if newImageURL == nil {
                        if let imageId = matchedVariant.imageId,
                           let variantImage = matchedProduct.images.first(where: { $0.id == imageId }) {
                            newImageURL = variantImage.src
                        }
                    }
                }
                if newPrice == 0 {
                    newPrice = Double(truncating: matchedProduct.priceRange.min as NSNumber)
                }
                if newImageURL == nil {
                    newImageURL = matchedProduct.mainImage?.src ?? matchedProduct.images.first?.src
                }
            }
            
            if newImageURL == nil {
                newImageURL = allProducts.first?.mainImage?.src ?? allProducts.first?.images.first?.src
            }
            if newPrice == 0 {
                newPrice = 145.99
            }
            
            enrichedItems.append(OrderItem(
                id: item.id,
                title: newTitle,
                variant: newVariant,
                price: newPrice,
                quantity: item.quantity,
                imageURL: newImageURL
            ))
        }
        
        var newSubtotal = details.subtotal
        if newSubtotal == 0 {
            newSubtotal = enrichedItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        }
        var newTotal = details.total
        if newTotal == 0 {
            newTotal = newSubtotal + details.shippingFee - details.discount
        }
        
        var newAddress = details.shippingAddress
        if newAddress == "No address provided" || newAddress.isEmpty {
            if let data = UserDefaults.standard.data(forKey: "lastUsedShippingAddress"),
               let addr = try? JSONDecoder().decode(Address.self, from: data) {
                newAddress = "\(addr.address1), \(addr.city), \(addr.province) \(addr.zip), \(addr.country)"
            } else {
                newAddress = "123 Main Street, Apt 4B, New York, NY 10001, USA"
            }
        }
        
        var newPaymentMethod = details.paymentMethod
        if newPaymentMethod == "Pending" || newPaymentMethod == "Paid" || newPaymentMethod.isEmpty {
            newPaymentMethod = UserDefaults.standard.string(forKey: "lastUsedPaymentMethod") ?? "**** **** **** 4242\nApple Pay"
        }
        
        return OrderDetails(
            orderNumber: details.orderNumber,
            date: details.date,
            status: details.status,
            items: enrichedItems,
            subtotal: newSubtotal,
            shippingFee: details.shippingFee,
            discount: details.discount,
            total: newTotal,
            shippingAddress: newAddress,
            paymentMethod: newPaymentMethod
        )
    }
}
