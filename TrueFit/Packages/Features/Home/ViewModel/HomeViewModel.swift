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
    @Published var collections: [ProductCollection] = []
    @Published var isLoadingProducts = false
    @Published var isLoadingCollections = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let fetchNewArrivalsUseCase: FetchNewArrivalsUseCase
    private let fetchCollectionsUseCase: FetchCollectionsUseCase

    // MARK: - Init

    init(
        fetchNewArrivalsUseCase: FetchNewArrivalsUseCase,
        fetchCollectionsUseCase: FetchCollectionsUseCase
    ) {
        self.fetchNewArrivalsUseCase = fetchNewArrivalsUseCase
        self.fetchCollectionsUseCase = fetchCollectionsUseCase
    }

    // MARK: - Public Methods

    func onAppear() {
        Task {
            await loadAllData()
        }
    }

    func refreshData() {
        Task {
            await loadAllData()
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
}
