//
//  FavoriteProductCard.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import SwiftUI

struct FavoriteProductCard: View {
    let product: FavoriteItem
    var onRemove: () -> Void
    var onAddToCart: () -> Void
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Product Image
            AsyncImage(url: product.imageURL) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle.trueFit(Radius.md)
                        .fill(Color.trueFitBackground)
                        .overlay(ProgressView().tint(.brandPrimary))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    RoundedRectangle.trueFit(Radius.md)
                        .fill(Color.trueFitBackground)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(.textTertiary)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            
            // Product Info
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack(alignment: .top) {
                    Text(product.title)
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                        .lineLimit(2)
                    
                    Spacer(minLength: Spacing.xs)
                    
                    // Remove Button
                    Button(action: onRemove) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.statusWishlistActive)
                            .padding(Spacing.xs)
                            .background(Color.statusWishlistActive.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                
                Text(product.vendor ?? "TrueFit")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
                
                Spacer(minLength: Spacing.xs)
                
                HStack(alignment: .bottom) {
                    Text(formattedPrice)
                        .trueFitTextStyle(.title3)
                        .foregroundColor(.textPrimary)
                        .bold()
                    
                    Spacer()
                    
                    // Add to Cart Button
                    Button(action: onAddToCart) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.surface)
                            .frame(width: 36, height: 36)
                            .background(Color.brandPrimary)
                            .clipShape(Circle())
                            .trueFitShadow(.xs)
                    }
                }
            }
            .padding(.vertical, Spacing.xs)
        }
        .padding(Spacing.sm)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.sm)
    }
    
    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSDecimalNumber(decimal: product.price)) ?? "$\(product.price)"
    }
}
