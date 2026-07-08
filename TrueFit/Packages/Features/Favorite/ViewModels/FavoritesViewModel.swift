//
//  FavoritesViewModel.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import Foundation
import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    // MARK: - Published State
    @Published var favoriteProducts: [FavoriteItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var toastMessage: String?
    @Published var toastStyle: ToastStyle = .success
    @Published var searchQuery: String = ""
    @Published var selectedCategory: String = "All"
    @Published var isGuest: Bool = false
    
    // MARK: - Dependencies
    private let getFavoritesUseCase: GetFavoritesUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let authManager: AuthManagerProtocol
    private let addToCartUseCase: AddToCartUseCase
    private let getProductUseCase: GetProductUseCase
    private var preferencesManager: PreferencesManagerProtocol
    private let cartState: CartState
    
    // MARK: - Init
    init(
        getFavoritesUseCase: GetFavoritesUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase,
        authManager: AuthManagerProtocol,
        addToCartUseCase: AddToCartUseCase,
        getProductUseCase: GetProductUseCase,
        preferencesManager: PreferencesManagerProtocol,
        cartState: CartState
    ) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.authManager = authManager
        self.addToCartUseCase = addToCartUseCase
        self.getProductUseCase = getProductUseCase
        self.preferencesManager = preferencesManager
        self.cartState = cartState
        self.isGuest = !authManager.isAuthenticated
    }
    
    // MARK: - Computed Properties
    
    var categories: [String] {
        let vendors = Set(favoriteProducts.compactMap { $0.vendor })
        var sortedVendors = Array(vendors).sorted()
        sortedVendors.insert("All", at: 0)
        return sortedVendors
    }
    
    var filteredProducts: [FavoriteItem] {
        favoriteProducts.filter { product in
            let matchesSearch = searchQuery.isEmpty ||
                                product.title.localizedCaseInsensitiveContains(searchQuery) ||
                                (product.vendor?.localizedCaseInsensitiveContains(searchQuery) ?? false)
            
            let matchesCategory = selectedCategory == "All" ||
                                  (product.vendor == selectedCategory)
            
            return matchesSearch && matchesCategory
        }
    }
    
    // MARK: - Actions
    
    func onAppeard() {
        if !isGuest {
            loadFavorites()
        }
    }
    
    private func loadFavorites() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                favoriteProducts = try await getFavoritesUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
                ErrorLogger.log(error as? AppError ?? AppError.unknown(error.localizedDescription), context: "FavoritesViewModel.loadFavorites")
            }
            isLoading = false
        }
    }
    
    func removeFromFavorites(_ id: String) {
        // Optimistic UI update
        guard let index = favoriteProducts.firstIndex(where: { $0.id == id }) else { return }
        let removedItem = favoriteProducts[index]
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            _ = favoriteProducts.remove(at: index)
        }
        
        Task {
            do {
                let _ = try await toggleFavoriteUseCase.execute(item: removedItem)
            } catch {
                // Rollback on failure
                withAnimation {
                    favoriteProducts.insert(removedItem, at: index)
                }
                errorMessage = error.localizedDescription
                ErrorLogger.log(error as? AppError ?? AppError.unknown(error.localizedDescription), context: "FavoritesViewModel.removeFromFavorites")
            }
        }
    }
    
    func addToCart(_ id: String) {
        guard let cartId = preferencesManager.cartId else { return }
        
        Task {
            do {
                let product = try await getProductUseCase.execute(productId: id)
                guard let variant = product.variants.first(where: { $0.isAvailable }) ?? product.variants.first else { return }
                
                let globalVariantId = variant.id.hasPrefix("gid://") ? variant.id : "gid://shopify/ProductVariant/\(variant.id)"
                
                let updatedCart = try await addToCartUseCase.execute(cartId: cartId, variantId: globalVariantId, quantity: 1)
                preferencesManager.cartId = updatedCart.id
                cartState.updateCount(updatedCart.totalQuantity)
                
                toastStyle = .success
                toastMessage = "Item added to cart"
            } catch {
                toastStyle = .error
                toastMessage = error.localizedDescription
                errorMessage = error.localizedDescription
                ErrorLogger.log(error as? AppError ?? AppError.unknown(error.localizedDescription), context: "FavoritesViewModel.addToCart")
            }
        }
    }
}

