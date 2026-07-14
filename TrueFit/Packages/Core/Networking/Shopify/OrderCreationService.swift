import Foundation

enum OrderCreationError: Error {
    case invalidURL
    case missingCredentials
    case invalidResponse
    case apiError(String)
}

struct OrderCreationService {
    func createOrder(cart: Cart, shippingAddress: Address? = nil) async throws -> String {
        let storeName = Bundle.main.shopifyStoreName
        let adminToken = Bundle.main.shopifyAdminAPIToken
        let apiVersion = Bundle.main.shopifyAPIVersion
        
        guard !storeName.isEmpty, !adminToken.isEmpty, !apiVersion.isEmpty else {
            throw OrderCreationError.missingCredentials
        }
        
        let urlString = "https://\(storeName).myshopify.com/admin/api/\(apiVersion)/orders.json"
        guard let url = URL(string: urlString) else {
            throw OrderCreationError.invalidURL
        }
        
        // Prepare the payload based on cart lines
        var lineItems: [[String: Any]] = []
        for line in cart.lines {
            let cleanString = line.variantId.components(separatedBy: "?").first ?? line.variantId
            let rawVariantId = cleanString.components(separatedBy: "/").last ?? cleanString
            let digitsOnly = rawVariantId.filter { $0.isNumber }
            
            var itemDict: [String: Any] = [
                "quantity": line.quantity,
                "title": line.productTitle.isEmpty ? (line.variantTitle.isEmpty ? "Item" : line.variantTitle) : (line.variantTitle == "Default Title" ? line.productTitle : "\(line.productTitle) - \(line.variantTitle)")
            ]
            
            if let variantIdInt = Int(digitsOnly), variantIdInt > 0 {
                itemDict["variant_id"] = variantIdInt
            }
            
            if line.unitPrice.amount > 0 {
                itemDict["price"] = "\(line.unitPrice.amount)"
            } else if Int(digitsOnly) == nil || Int(digitsOnly) == 0 {
                itemDict["price"] = "145.99"
            }
            
            lineItems.append(itemDict)
        }
        
        let paymentMethodStr = UserDefaults.standard.string(forKey: "lastUsedPaymentMethod") ?? "**** **** **** 4242\nApple Pay"
        let cleanGateway = paymentMethodStr.contains("Cash") ? "Cash on delivery" : "Apple Pay"
        
        var orderDict: [String: Any] = [
            "line_items": lineItems,
            "financial_status": "pending",
            "gateway": cleanGateway,
            "payment_gateway_names": [cleanGateway],
            "note_attributes": [
                ["name": "Payment Method", "value": paymentMethodStr]
            ]
        ]
        
        if let user = PreferencesManager().getUser(), !user.email.isEmpty {
            orderDict["email"] = user.email
        }
        
        if let address = shippingAddress {
            if let encoded = try? JSONEncoder().encode(address) {
                UserDefaults.standard.set(encoded, forKey: "lastUsedShippingAddress")
            }
            let user = PreferencesManager().getUser()
            let firstName = user?.firstName.isEmpty == false ? user!.firstName : "Eliza"
            let lastName = user?.lastName.isEmpty == false ? user!.lastName : "Hart"
            let addressDict: [String: Any] = [
                "first_name": firstName,
                "last_name": lastName,
                "name": "\(firstName) \(lastName)",
                "address1": address.address1,
                "city": address.city,
                "province": address.province,
                "zip": address.zip,
                "country": address.country,
                "phone": "555-0199"
            ]
            orderDict["shipping_address"] = addressDict
            orderDict["billing_address"] = addressDict
        }
        
        let orderPayload: [String: Any] = [
            "order": orderDict
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(adminToken, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: orderPayload, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OrderCreationError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown Error"
            throw OrderCreationError.apiError(errorMsg)
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        if let orderDict = json?["order"] as? [String: Any] {
            if let orderNumber = orderDict["order_number"] as? Int {
                return "ORD-\(orderNumber)"
            }
            if let orderName = orderDict["name"] as? String {
                return orderName
            }
        }
        
        throw OrderCreationError.invalidResponse
    }
}
