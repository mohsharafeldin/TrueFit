//
//  OrderHistoryCard.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

struct OrderHistoryCard: View {
    let order: Order
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Top Section: Order ID & Status
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Order \(order.orderNumber)")
                            .trueFitTextStyle(.headline)
                            .foregroundColor(.textPrimary)
                            .bold()
                        
                        Text(order.date)
                            .trueFitTextStyle(.caption)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Status Badge
                    Text(order.status.rawValue)
                        .trueFitTextStyle(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(order.status.color)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, 6)
                        .background(order.status.color.opacity(0.12))
                        .clipShape(RoundedRectangle.trueFit(Radius.pill))
                }
                .padding(Spacing.md)
                
                Divider()
                    .background(Color.borderColor)
                    .padding(.horizontal, Spacing.md)
                
                // Middle Section: Items Images Preview & Details
                HStack(alignment: .center) {
                    OrderImagesOverlapView(imageURLs: order.itemImageURLs, totalItems: order.totalItemsCount)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textTertiary)
                }
                .padding(Spacing.md)
                
                // Bottom Section: Total Price & CTA
                HStack {
                    Text("Total:")
                        .trueFitTextStyle(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Text(formattedPrice)
                        .trueFitTextStyle(.title3)
                        .foregroundColor(.textPrimary)
                        .bold()
                    
                    Spacer()
                    
                    // Reorder / Details Button (Stylized)
                    Text(order.status == .delivered ? "Reorder" : "Track")
                        .trueFitTextStyle(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.xs)
                        .overlay(
                            RoundedRectangle.trueFit(Radius.pill)
                                .stroke(Color.brandPrimary, lineWidth: 1.5)
                        )
                }
                .padding(Spacing.md)
                .background(Color.trueFitBackground.opacity(0.5))
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .trueFitShadow(.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSDecimalNumber(value: order.totalAmount)) ?? "$\(order.totalAmount)"
    }
}

struct OrderHistoryCard_Previews: PreviewProvider {
    static var previews: some View {

        OrderHistoryCard(order: OrderPreviewData.mockOrders[0], onTap: {})
            .padding()
            .background(Color.trueFitBackground)

    }
}
