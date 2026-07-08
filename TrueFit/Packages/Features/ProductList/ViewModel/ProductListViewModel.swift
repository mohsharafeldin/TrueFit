//
//  ProductListViewModel.swift
//  TrueFit
//
//  Features — ViewModel for the Product List screen (filtered by collection or brand).
//

import Foundation

/// Defines the source for filtering products.
enum ProductListSource: Equatable {
    case collection(id: Int64, title: String)
    case brand(vendor: String)
    case allProducts
}

@MainActor
final class ProductListViewModel: ObservableObject {

    // MARK: - Published State

    @Published var products: [Product] = []
    @Published var state: ViewState<[Product]> = .idle

    // MARK: - Properties

    let source: ProductListSource

    var title: String {
        switch source {
        case .collection(_, let title):
            return title
        case .brand(let vendor):
            return vendor
        case .allProducts:
            return "All Products"
        }
    }

    // MARK: - Dependencies

    private let fetchProductsByCollectionUseCase: FetchProductsByCollectionUseCase
    private let fetchProductsByVendorUseCase: FetchProductsByVendorUseCase
    private let fetchAllProductsUseCase: FetchAllProductsUseCase

    // MARK: - Init

    init(
        source: ProductListSource,
        fetchProductsByCollectionUseCase: FetchProductsByCollectionUseCase,
        fetchProductsByVendorUseCase: FetchProductsByVendorUseCase,
        fetchAllProductsUseCase: FetchAllProductsUseCase
    ) {
        self.source = source
        self.fetchProductsByCollectionUseCase = fetchProductsByCollectionUseCase
        self.fetchProductsByVendorUseCase = fetchProductsByVendorUseCase
        self.fetchAllProductsUseCase = fetchAllProductsUseCase
    }

    // MARK: - Public Methods

    func loadProducts() async {
        state = .loading

        do {
            let fetchedProducts: [Product]

            switch source {
            case .collection(let id, _):
                fetchedProducts = try await fetchProductsByCollectionUseCase.execute(collectionId: id)
            case .brand(let vendor):
                fetchedProducts = try await fetchProductsByVendorUseCase.execute(vendor: vendor)
            case .allProducts:
                fetchedProducts = try await fetchAllProductsUseCase.execute()
            }

            self.products = fetchedProducts
            self.state = .success(fetchedProducts)
        } catch let appError as AppError {
            ErrorLogger.log(appError, context: "ProductListViewModel.loadProducts")
            self.state = .failure(appError)
        } catch {
            let unknownError = AppError.unknown(error.localizedDescription)
            ErrorLogger.log(unknownError, context: "ProductListViewModel.loadProducts")
            self.state = .failure(unknownError)
        }
    }

    func retry() async {
        await loadProducts()
    }
}
