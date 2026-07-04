//
//  FavoritesViewModel.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 03/07/2026.
//

import Foundation
import SwiftUI

// MARK: - Mock Product Model Extension

// MARK: - Mock Models
struct MockProduct: Identifiable {
    let id: String
    let title: String
    let price: String
    let vendor: String?
    let imageURL: URL?
    let options: [MockProductOption]
    let description: String
}

struct MockProductOption: Identifiable {
    let id: String
    let name: String
    let values: [String]
}

// MARK: - Mock Data Extension
extension MockProduct {
    static let mockFavorites: [MockProduct] = [
        MockProduct(
            id: UUID().uuidString,
            title: "TrueFit Premium Oversized Hoodie",
            price: "89.99",
            vendor: "TrueFit Essentials",
            imageURL: URL(string: "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?q=80&w=300&auto=format&fit=crop"),
            options: [],
            description: "A very comfortable and premium oversized hoodie."
        ),
        MockProduct(
            id: UUID().uuidString,
            title: "Minimalist Leather Sneaker - Urban White",
            price: "120.00",
            vendor: "TrueFit Footwear",
            imageURL: URL(string: "https://images.unsplash.com/photo-1549298916-b41d501d3772?q=80&w=300&auto=format&fit=crop"),
            options: [],
            description: "Sleek, minimalist leather sneakers for urban exploration."
        ),
        MockProduct(
            id: UUID().uuidString,
            title: "Classic Denim Jacket - Vintage Wash",
            price: "75.50",
            vendor: "Denim Co.",
            imageURL: URL(string: "https://images.unsplash.com/photo-1576995853123-5a10305d93c0?q=80&w=300&auto=format&fit=crop"),
            options: [],
            description: "Vintage wash classic denim jacket with timeless appeal."
        ),
        MockProduct(
            id: UUID().uuidString,
            title: "Smart Urban Backpack (Waterproof)",
            price: "45.00",
            vendor: "TrueFit Travel",
            imageURL: URL(string: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=300&auto=format&fit=crop"),
            options: [],
            description: "Waterproof smart urban backpack designed for everyday commuters."
        )
    ]
}

// MARK: - Favorites ViewModel
class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [MockProduct] = []
    @Published var isLoading: Bool = false
    
    @Published var searchQuery: String = ""
    @Published var selectedCategory: String = "All"
    
    let categories = ["All", "Essentials", "Footwear", "Denim", "Travel"]
    
    private let isPreviewMode: Bool
    private let previewState: PreviewState
    
    enum PreviewState {
        case loading, empty, content
    }
    
    init(isPreviewMode: Bool = false, previewState: PreviewState = .content) {
        self.isPreviewMode = isPreviewMode
        self.previewState = previewState
    }
    
    var filteredProducts: [MockProduct] {
        favoriteProducts.filter { product in
            let matchesSearch = searchQuery.isEmpty ||
                                product.title.localizedCaseInsensitiveContains(searchQuery) ||
                                (product.vendor?.localizedCaseInsensitiveContains(searchQuery) ?? false)
            
            let matchesCategory = selectedCategory == "All" ||
                                  (product.vendor?.localizedCaseInsensitiveContains(selectedCategory) ?? false)
            
            return matchesSearch && matchesCategory
        }
    }
    
    func onAppeard() {
        if isPreviewMode {
            setupPreviewState()
        } else {
            fetchFavorites()
        }
    }
    
    private func fetchFavorites() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self else { return }
            self.favoriteProducts = MockProduct.mockFavorites
            self.isLoading = false
        }
    }
    
    private func setupPreviewState() {
        switch previewState {
        case .loading:
            self.isLoading = true
            self.favoriteProducts = []
        case .empty:
            self.isLoading = false
            self.favoriteProducts = []
        case .content:
            self.isLoading = false
            self.favoriteProducts = MockProduct.mockFavorites
        }
    }
    
    func removeFromFavorites(_ id: String) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            favoriteProducts.removeAll { $0.id == id }
        }
    }
    
    func addToCart(_ id: String) {
        print("Product \(id) added to cart! 🛒")
    }
}
