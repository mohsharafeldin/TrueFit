import ShopifyAPI
import Foundation

enum CartMapper {
    static func map(_ data: CartFields) -> Cart {
        let lines = data.lines.edges.compactMap { $0.node.asCartLine?.fragments.cartLineFields }.map { mapLine($0) }
        let totalQuantity = data.totalQuantity
        
        let subtotal = mapMoney(data.cost.subtotalAmount.fragments.moneyFields)
        let total = mapMoney(data.cost.totalAmount.fragments.moneyFields)
        let totalTax = data.cost.totalTaxAmount.map { mapMoney($0.fragments.moneyFields) }
        
        let discountCodes = data.discountCodes.map { mapDiscount($0) }
        let checkoutURL = URL(string: data.checkoutUrl)
        
        return Cart(
            id: data.id,
            lines: lines,
            totalQuantity: totalQuantity,
            subtotal: subtotal,
            total: total,
            totalTax: totalTax,
            discountCodes: discountCodes,
            checkoutURL: checkoutURL
        )
    }
    
    static func mapLine(_ node: CartLineFields) -> CartLine {
        // Safe access based on standard Apollo Codegen for unions/interfaces
        let merchandise = node.merchandise.asProductVariant
        
        let unitPrice: Money
        if let fields = merchandise?.price.fragments.moneyFields {
            unitPrice = mapMoney(fields)
        } else {
            unitPrice = Money(amount: 0, currencyCode: "USD")
        }
        let compareAtPrice = merchandise?.compareAtPrice.map { mapMoney($0.fragments.moneyFields) }
        
        let lineTotal = mapMoney(node.cost.totalAmount.fragments.moneyFields)
        let compareAtLineTotal = node.cost.compareAtAmountPerQuantity.map { mapMoney($0.fragments.moneyFields) }
        
        let rawProductTitle = merchandise?.product.title ?? ""
        let rawVariantTitle = merchandise?.title ?? ""
        
        let finalProductTitle: String = {
            if !rawProductTitle.isEmpty { return rawProductTitle }
            if !rawVariantTitle.isEmpty, rawVariantTitle != "Default Title" { return rawVariantTitle }
            return "Product Item"
        }()
        
        let finalVariantTitle: String = {
            if !rawVariantTitle.isEmpty, rawVariantTitle != "Default Title", rawVariantTitle != finalProductTitle {
                return rawVariantTitle
            }
            return ""
        }()

        return CartLine(
            id: node.id,
            quantity: node.quantity,
            variantId: merchandise?.id ?? "",
            variantTitle: finalVariantTitle,
            productId: merchandise?.product.id ?? "",
            productTitle: finalProductTitle,
            productHandle: merchandise?.product.handle ?? "",
            imageURL: merchandise?.product.featuredImage.flatMap { URL(string: $0.url) },
            imageAltText: merchandise?.product.featuredImage?.altText,
            unitPrice: unitPrice,
            compareAtPrice: compareAtPrice,
            lineTotal: lineTotal,
            compareAtLineTotal: compareAtLineTotal
        )
    }
    
    static func mapMoney(_ money: MoneyFields) -> Money {
        let amount = Foundation.Decimal(string: money.amount) ?? 0
        return Money(amount: amount, currencyCode: money.currencyCode.rawValue)
    }
    
    static func mapDiscount(_ code: CartFields.DiscountCode) -> DiscountCode {
        return DiscountCode(code: code.code, isApplicable: code.applicable)
    }
}
