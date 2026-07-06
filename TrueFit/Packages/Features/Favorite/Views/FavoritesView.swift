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
            if viewModel.isGuest {
                FavoritesEmptyStateView(isSearching: false, isGuest: true)
            } else if viewModel.isLoading {
                favoritesPlaceholder
            } else if viewModel.filteredProducts.isEmpty {
                FavoritesEmptyStateView(isSearching: !viewModel.searchQuery.isEmpty, isGuest: false)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: Spacing.lg) {
                        ForEach(viewModel.filteredProducts) { favoriteItem in
                            FavoriteProductCard(
                                product: favoriteItem,
                                onRemove: { viewModel.removeFromFavorites(favoriteItem.id) },
                                onAddToCart: { viewModel.addToCart(favoriteItem.id) }
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


// MARK: - Previews
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                FavoritesView(viewModel: PreviewMocks.makeFavoritesViewModel())
            }
            .previewDisplayName("Favorites - With Data")

            NavigationView {
                FavoritesView(viewModel: PreviewMocks.makeFavoritesViewModel(isEmpty: true))
            }
            .previewDisplayName("Favorites - Empty State")
        }
    }
}
