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
    @Published var searchQuery: String = ""
    @Published var selectedCategory: String = "All"
    @Published var isGuest: Bool = false
    
    // MARK: - Dependencies
    private let getFavoritesUseCase: GetFavoritesUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let authManager: AuthManagerProtocol
    
    // MARK: - Init
    init(
        getFavoritesUseCase: GetFavoritesUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase,
        authManager: AuthManagerProtocol
    ) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.authManager = authManager
        self.isGuest = !authManager.isAuthenticated
    }
    
    // MARK: - Computed Properties
    
    var categories: [String] {
        var vendors = Set(favoriteProducts.compactMap { $0.vendor })
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
        print("Product \(id) added to cart! 🛒")
        // Future: integrate with CartUseCase
    }
}

