//
//  HomeViewModel.swift
//  TrueFit
//
//  Features — ViewModel for the Home screen.
//

import Foundation
import SwiftUI

enum HomeTab: Int, CaseIterable {
    case home
    case category

    var title: String {
        switch self {
        case .home: return "Home"
        case .category: return "Category"
        }
    }
}

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Published State

    @Published var selectedTab: HomeTab = .home
    @Published var products: [Product] = []
    @Published var favoriteStatuses: [String: Bool] = [:]
    @Published var collections: [ProductCollection] = []
    @Published var isLoadingProducts = false
    @Published var isLoadingCollections = false
    @Published var errorMessage: String?
    @Published var userName: String = "Guest"

    // MARK: - Dependencies

    private let fetchNewArrivalsUseCase: FetchNewArrivalsUseCase
    private let fetchCollectionsUseCase: FetchCollectionsUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let isFavoriteUseCase: IsFavoriteUseCase
    private let preferencesManager: PreferencesManagerProtocol

    // MARK: - Init

    init(
        fetchNewArrivalsUseCase: FetchNewArrivalsUseCase,
        fetchCollectionsUseCase: FetchCollectionsUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase,
        isFavoriteUseCase: IsFavoriteUseCase,
        preferencesManager: PreferencesManagerProtocol
    ) {
        self.fetchNewArrivalsUseCase = fetchNewArrivalsUseCase
        self.fetchCollectionsUseCase = fetchCollectionsUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.preferencesManager = preferencesManager
    }

    // MARK: - Public Methods

    func onAppear() {
        loadUser()
        Task {
            await loadAllData()
        }
    }

    func refreshData() {
        Task {
            await loadAllData()
        }
    }
    
    func toggleFavorite(product: Product) {
        let currentValue = favoriteStatuses[product.id] ?? false
        // Optimistic UI update
        favoriteStatuses[product.id] = !currentValue
        
        Task {
            do {
                let newValue = try await toggleFavoriteUseCase.execute(item: product.toFavoriteItem())
                favoriteStatuses[product.id] = newValue
            } catch {
                // Revert on failure
                favoriteStatuses[product.id] = currentValue
                errorMessage = error.localizedDescription
                ErrorLogger.log(error as? AppError ?? AppError.unknown(error.localizedDescription), context: "HomeViewModel.toggleFavorite")
            }
        }
    }
    
    private func loadUser() {
        if let user = preferencesManager.getUser() {
            userName = user.firstName
        } else {
            userName = "Guest"
        }
    }

    // MARK: - Private

    private func loadAllData() async {
        errorMessage = nil

        async let productsTask: () = loadProducts()
        async let collectionsTask: () = loadCollections()

        _ = await (productsTask, collectionsTask)
    }

    private func loadProducts() async {
        isLoadingProducts = true
        defer { isLoadingProducts = false }

        do {
            products = try await fetchNewArrivalsUseCase.execute(limit: 10)
            await checkFavoriteStatuses()
        } catch {
            #if DEBUG
            print("❌ [HomeViewModel] Failed to load products: \(error.localizedDescription)")
            #endif
            errorMessage = error.localizedDescription
        }
    }

    private func loadCollections() async {
        isLoadingCollections = true
        defer { isLoadingCollections = false }

        do {
            collections = try await fetchCollectionsUseCase.execute()
        } catch {
            #if DEBUG
            print("❌ [HomeViewModel] Failed to load collections: \(error.localizedDescription)")
            #endif
            if errorMessage == nil {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func checkFavoriteStatuses() async {
        for product in products {
            do {
                let isFav = try await isFavoriteUseCase.execute(productId: product.id)
                favoriteStatuses[product.id] = isFav
            } catch {
                favoriteStatuses[product.id] = false
            }
        }
    }
}
