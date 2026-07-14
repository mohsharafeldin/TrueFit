//
//  OrderItemCard.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

struct OrderItemCard: View {
    let item: OrderItem
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color.trueFitBackground
                        .overlay(Image(systemName: "photo").foregroundColor(.textTertiary))
                }
            }
            .frame(width: 75, height: 75)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(item.variant)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
                
                HStack {
                    Text(formatPrice(item.price))
                        .trueFitTextStyle(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                    
                    Spacer()
                    
                    Text("Qty: \(item.quantity)")
                        .trueFitTextStyle(.caption)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.trueFitBackground)
                        .clipShape(RoundedRectangle.trueFit(Radius.sm))
                }
                .padding(.top, 4)
            }
        }
        .padding(Spacing.sm)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.xs)
    }
    
    private func formatPrice(_ amount: Double) -> String {
        "$\(String(format: "%.2f", amount))"
    }
}

struct OrderItemCard_Previews: PreviewProvider {
    static var previews: some View {

        OrderItemCard(item: OrderPreviewData.mockOrderDetails.items[0])
            .padding()

    }
}
