//
//  FavoritesView.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 03/07/2026.
//

import SwiftUI

// MARK: - Favorites View
struct FavoritesView: View {
    @StateObject var viewModel: FavoritesViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            FavoritesHeaderView(count: viewModel.filteredProducts.count)
            
            // Search Bar
            FavoritesSearchBar(text: $viewModel.searchQuery)
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.sm)
                .padding(.bottom, Spacing.xs)
            
            // Filter Categories Row
            FilterCategoriesRow(
                selectedCategory: $viewModel.selectedCategory,
                categories: viewModel.categories
            )
            .padding(.bottom, Spacing.sm)
            
            // Content Area
            if viewModel.isLoading {
                favoritesPlaceholder
            } else if viewModel.filteredProducts.isEmpty {
                FavoritesEmptyStateView(isSearching: !viewModel.searchQuery.isEmpty)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: Spacing.lg) {
                        ForEach(viewModel.filteredProducts) { mockProduct in
                            FavoriteProductCard(
                                product: mockProduct,
                                onRemove: { viewModel.removeFromFavorites(mockProduct.id) },
                                onAddToCart: { viewModel.addToCart(mockProduct.id) }
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.xs)
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color.trueFitBackground)
        .onAppear {
            viewModel.onAppeard()
        }
    }
    
    @ViewBuilder
    private var favoritesPlaceholder: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: Spacing.lg) {
                ForEach(0..<4, id: \.self) { _ in
                    ShimmerFavoriteCard()
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }
}

// MARK: - Favorites Header Component
struct FavoritesHeaderView: View {
    let count: Int
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text("My Wishlist")
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                    .bold()
                
                Text("\(count) items saved")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.system(size: 22))
                .foregroundColor(.statusWishlistActive)
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.md)
        .background(Color.surface)
    }
}

// MARK: - Custom Search Bar Component
struct FavoritesSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textTertiary)
            
            TextField("Search inside favorites...", text: $text)
                .trueFitTextStyle(.body)
                .foregroundColor(.textPrimary)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.md))
        .overlay(
            RoundedRectangle.trueFit(Radius.md)
                .stroke(Color.textTertiary.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Filter Categories Row Component
struct FilterCategoriesRow: View {
    @Binding var selectedCategory: String
    let categories: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = selectedCategory == category
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }) {
                        Text(category)
                            .trueFitTextStyle(.callout)
                            .fontWeight(isSelected ? .bold : .regular)
                            .padding(.horizontal, Spacing.lg)
                            .padding(.vertical, Spacing.xs)
                            .foregroundColor(isSelected ? .surface : .textPrimary)
                            .background(isSelected ? Color.brandPrimary : Color.surface)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(isSelected ? Color.clear : Color.textTertiary.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Favorite Product Card
struct FavoriteProductCard: View {
    let product: MockProduct
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
        if let value = Double(product.price) {
            return String(format: "$%.2f", value)
        }
        return "$\(product.price)"
    }
}

// MARK: - Empty State View
struct FavoritesEmptyStateView: View {
    
    let isSearching: Bool
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.statusWishlistActive.opacity(0.08))
                    .frame(width: 140, height: 140)
                
                Image(systemName: "heart.slash")
                    .font(.system(size: 56, weight: .light))
                    .foregroundColor(.statusWishlistActive)
            }
            
            VStack(spacing: Spacing.sm) {
                Text("No Favorites Yet!")
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                    .bold()
                
                Text("Tap the heart icon on products you love to save them here for later.")
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xxxl)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Shimmer Placeholder (Loading Cycle)
struct ShimmerFavoriteCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            RoundedRectangle.trueFit(Radius.md)
                .fill(Color.surface)
                .frame(width: 95, height: 95)
                .overlay(shimmerGradient)
                .clipped()
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(height: 14)
                    .overlay(shimmerGradient)
                    .clipped()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(width: 70, height: 10)
                    .overlay(shimmerGradient)
                    .clipped()
                
                Spacer()
                
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.surface)
                        .frame(width: 50, height: 16)
                        .overlay(shimmerGradient)
                        .clipped()
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.surface)
                        .frame(width: 65, height: 26)
                        .overlay(shimmerGradient)
                        .clipped()
                }
            }
            .padding(.vertical, Spacing.xs)
        }
        .padding(Spacing.sm)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .onAppear {
            withAnimation(.linear(duration: TrueFitMotion.loadingCycle).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
    
    private var shimmerGradient: some View {
        LinearGradient(colors: [.clear, .white.opacity(0.35), .clear], startPoint: .leading, endPoint: .trailing)
            .offset(x: isAnimating ? 250 : -250)
    }
}


// MARK: - Previews
#Preview("Favorites View") {
    FavoritesView(viewModel: FavoritesViewModel(isPreviewMode: true, previewState: .content))
}

#Preview("Loading (Shimmer)") {
    FavoritesView(viewModel: FavoritesViewModel(isPreviewMode: true, previewState: .loading))
}

#Preview("Empty State") {
    FavoritesView(viewModel: FavoritesViewModel(isPreviewMode: true, previewState: .empty))
}
