import Foundation

struct Cart {
    let id: String
    let lines: [CartLine]
    let totalQuantity: Int
    let subtotal: Money
    let total: Money
    let totalTax: Money?
    let discountCodes: [DiscountCode]
    let checkoutURL: URL?
    
    var isEmpty: Bool { lines.isEmpty }
    var hasDiscount: Bool { discountCodes.contains { $0.isApplicable } }
}

struct CartLine {
    let id: String
    let quantity: Int
    let variantId: String
    let variantTitle: String
    let productId: String
    let productTitle: String
    let productHandle: String
    let imageURL: URL?
    let imageAltText: String?
    let unitPrice: Money
    let compareAtPrice: Money?
    let lineTotal: Money
    let compareAtLineTotal: Money?
    var isOnSale: Bool { compareAtPrice != nil && compareAtPrice!.amount > unitPrice.amount }
}

struct Money {
    let amount: Foundation.Decimal
    let currencyCode: String
    
    var formatted: String {
        return PriceFormatter.format(amount)
    }
}

struct DiscountCode {
    let code: String
    let isApplicable: Bool
}
