//
//  SearchViewModel.swift
//  TrueFit
//
//  Features — ViewModel for the Search & Filter screen.
//

import Foundation
import Combine

// MARK: - Sort Option

enum SearchSortOption: Int, CaseIterable {
    case all
    case latest
    case mostPopular
    case cheapest

    var title: String {
        switch self {
        case .all: return "All"
        case .latest: return "Latest"
        case .mostPopular: return "Most Popular"
        case .cheapest: return "Cheapest"
        }
    }
}

// MARK: - Popular Search Item

struct PopularSearchItem: Identifiable {
    let id = UUID()
    let title: String
    let searchCount: String
    let badge: PopularBadge?
    let imageSystemName: String
}

enum PopularBadge: String {
    case hot = "Hot"
    case new = "New"
    case popular = "Popular"
}

// MARK: - ViewModel

@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Published State

    @Published var searchText: String = ""
    @Published var state: ViewState<[Product]> = .idle
    @Published var selectedSort: SearchSortOption = .all
    @Published var showFilterSheet = false

    // Filter state
    @Published var selectedBrands: Set<String> = []
    @Published var selectedCategory: ProductCollection? = nil
    @Published var selectedSubCategories: Set<String> = []
    @Published var priceRangeMin: Double = 0
    @Published var priceRangeMax: Double = 500
    @Published var currentPriceMin: Double = 0
    @Published var currentPriceMax: Double = 500

    // Data
    @Published var allProducts: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var brands: [Brand] = []
    @Published var collections: [ProductCollection] = []
    @Published var collectionProducts: [Int64: [Product]] = [:]
    @Published var availableSubCategories: [String] = []
    @Published var searchHistory: [String] = []
    @Published var isLoading = false

    // MARK: - Properties

    var hasActiveFilters: Bool {
        !selectedBrands.isEmpty ||
        selectedCategory != nil ||
        !selectedSubCategories.isEmpty ||
        currentPriceMin > priceRangeMin ||
        currentPriceMax < priceRangeMax
    }

    var activeFilterCount: Int {
        var count = 0
        if !selectedBrands.isEmpty { count += 1 }
        if selectedCategory != nil { count += 1 }
        if !selectedSubCategories.isEmpty { count += 1 }
        if currentPriceMin > priceRangeMin || currentPriceMax < priceRangeMax { count += 1 }
        return count
    }

    // MARK: - Dependencies

    private let fetchAllProductsUseCase: FetchAllProductsUseCase
    private let fetchBrandsUseCase: FetchBrandsUseCase
    private let fetchCollectionsUseCase: FetchCollectionsUseCase
    private let fetchProductsByCollectionUseCase: FetchProductsByCollectionUseCase
    private var searchCancellable: AnyCancellable?

    private let searchHistoryKey = "TrueFit.SearchHistory"

    // MARK: - Popular Searches

    let popularSearches: [PopularSearchItem] = [
        PopularSearchItem(title: "Running Shoes", searchCount: "1.6k Search today", badge: .hot, imageSystemName: "shoe.fill"),
        PopularSearchItem(title: "Sneakers", searchCount: "1k Search today", badge: .new, imageSystemName: "shoe.2.fill"),
        PopularSearchItem(title: "Backpack", searchCount: "1.23k Search today", badge: .popular, imageSystemName: "backpack.fill"),
        PopularSearchItem(title: "Sport Wear", searchCount: "1.1k Search today", badge: .new, imageSystemName: "tshirt.fill")
    ]

    // MARK: - Init

    init(
        fetchAllProductsUseCase: FetchAllProductsUseCase,
        fetchBrandsUseCase: FetchBrandsUseCase,
        fetchCollectionsUseCase: FetchCollectionsUseCase,
        fetchProductsByCollectionUseCase: FetchProductsByCollectionUseCase
    ) {
        self.fetchAllProductsUseCase = fetchAllProductsUseCase
        self.fetchBrandsUseCase = fetchBrandsUseCase
        self.fetchCollectionsUseCase = fetchCollectionsUseCase
        self.fetchProductsByCollectionUseCase = fetchProductsByCollectionUseCase

        loadSearchHistory()
        setupSearchDebounce()
    }

    // MARK: - Setup

    private func setupSearchDebounce() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                Task { @MainActor in
                    self.applyFiltersAndSearch()
                }
            }
    }

    // MARK: - Data Loading

    func loadData() async {
        guard allProducts.isEmpty else { return }
        isLoading = true
        state = .loading

        do {
            async let productsTask = fetchAllProductsUseCase.execute()
            async let brandsTask = fetchBrandsUseCase.execute()
            async let collectionsTask = fetchCollectionsUseCase.execute()

            let (products, fetchedBrands, fetchedCollections) = try await (productsTask, brandsTask, collectionsTask)

            self.allProducts = products
            self.brands = fetchedBrands
            self.collections = fetchedCollections

            // Calculate price range from actual data
            let prices = products.compactMap { Double(truncating: $0.priceRange.min as NSDecimalNumber) }
            if let minPrice = prices.min(), let maxPrice = prices.max() {
                self.priceRangeMin = floor(minPrice)
                self.priceRangeMax = ceil(maxPrice)
                self.currentPriceMin = self.priceRangeMin
                self.currentPriceMax = self.priceRangeMax
            }

            // Extract unique sub-categories (productType)
            self.availableSubCategories = Array(
                Set(products.compactMap { $0.productType }.filter { !$0.isEmpty })
            ).sorted()

            self.isLoading = false
            self.state = .success(products)
            self.filteredProducts = products
        } catch let appError as AppError {
            ErrorLogger.log(appError, context: "SearchViewModel.loadData")
            self.isLoading = false
            self.state = .failure(appError)
        } catch {
            let unknownError = AppError.unknown(error.localizedDescription)
            ErrorLogger.log(unknownError, context: "SearchViewModel.loadData")
            self.isLoading = false
            self.state = .failure(unknownError)
        }
    }

    func retry() async {
        allProducts = []
        await loadData()
    }

    // MARK: - Search & Filter Logic

    func applyFiltersAndSearch() {
        var results = allProducts

        // 1. Text search
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !query.isEmpty {
            results = filterProducts(results, matching: query)
        }

        // 1.5. Category filter
        if let selectedCategory = selectedCategory {
            if let catProducts = collectionProducts[selectedCategory.id] {
                let catProductIds = Set(catProducts.map { $0.id })
                results = results.filter { catProductIds.contains($0.id) }
            } else {
                results = [] // Not loaded yet
            }
        }

        // 2. Brand filter
        if !selectedBrands.isEmpty {
            results = results.filter { product in
                guard let vendor = product.vendor else { return false }
                return selectedBrands.contains(vendor)
            }
        }

        // 3. Sub-category filter (productType)
        if !selectedSubCategories.isEmpty {
            results = results.filter { product in
                guard let productType = product.productType else { return false }
                return selectedSubCategories.contains(productType)
            }
        }

        // 4. Price range filter
        results = results.filter { product in
            let price = Double(truncating: product.priceRange.min as NSDecimalNumber)
            return price >= currentPriceMin && price <= currentPriceMax
        }

        // 5. Sorting
        switch selectedSort {
        case .all:
            break // Keep relevance order
        case .latest:
            results.sort { (a, b) in
                guard let dateA = a.createdAt, let dateB = b.createdAt else { return false }
                return dateA > dateB
            }
        case .mostPopular:
            // Sort by vendor product count as a proxy for popularity
            let vendorCounts = Dictionary(grouping: allProducts) { $0.vendor ?? "" }
                .mapValues { $0.count }
            results.sort { (a, b) in
                let countA = vendorCounts[a.vendor ?? ""] ?? 0
                let countB = vendorCounts[b.vendor ?? ""] ?? 0
                return countA > countB
            }
        case .cheapest:
            results.sort { (a, b) in
                a.priceRange.min < b.priceRange.min
            }
        }

        filteredProducts = results
    }

    // MARK: - Sort

    func selectSort(_ option: SearchSortOption) {
        selectedSort = option
        applyFiltersAndSearch()
    }

    // MARK: - Filter Actions

    func toggleBrand(_ brand: String) {
        if selectedBrands.contains(brand) {
            selectedBrands.remove(brand)
        } else {
            selectedBrands.insert(brand)
        }
    }

    func selectCategory(_ collection: ProductCollection?) {
        if selectedCategory?.id == collection?.id {
            selectedCategory = nil
            updateSubCategories()
            applyFiltersAndSearch()
        } else {
            selectedCategory = collection
            updateSubCategories()

            if let collection = collection {
                if collectionProducts[collection.id] == nil {
                    isLoading = true
                    Task {
                        do {
                            let products = try await fetchProductsByCollectionUseCase.execute(collectionId: collection.id)
                            collectionProducts[collection.id] = products
                            isLoading = false
                            updateSubCategories()
                            applyFiltersAndSearch()
                        } catch {
                            isLoading = false
                            collectionProducts[collection.id] = []
                            updateSubCategories()
                            applyFiltersAndSearch()
                        }
                    }
                } else {
                    applyFiltersAndSearch()
                }
            } else {
                applyFiltersAndSearch()
            }
        }
    }

    func toggleSubCategory(_ subCategory: String) {
        if selectedSubCategories.contains(subCategory) {
            selectedSubCategories.remove(subCategory)
        } else {
            selectedSubCategories.insert(subCategory)
        }
    }

    private func updateSubCategories() {
        let products: [Product]
        if let selectedCategory = selectedCategory {
            products = collectionProducts[selectedCategory.id] ?? []
        } else {
            products = allProducts
        }

        availableSubCategories = Array(
            Set(products.compactMap { $0.productType }.filter { !$0.isEmpty })
        ).sorted()

        // Prune subcategories that are no longer available in the selected category
        let availableSet = Set(availableSubCategories)
        selectedSubCategories = selectedSubCategories.filter { availableSet.contains($0) }
    }

    func applyFilters() {
        showFilterSheet = false
        applyFiltersAndSearch()
    }

    func resetFilters() {
        selectedBrands = []
        selectedCategory = nil
        selectedSubCategories = []
        currentPriceMin = priceRangeMin
        currentPriceMax = priceRangeMax
        updateSubCategories()
        applyFiltersAndSearch()
    }

    // MARK: - Search History

    func commitSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }

        // Add to history (deduplicate, keep most recent first)
        searchHistory.removeAll { $0.lowercased() == query.lowercased() }
        searchHistory.insert(query, at: 0)
        if searchHistory.count > 10 {
            searchHistory = Array(searchHistory.prefix(10))
        }
        saveSearchHistory()
    }

    func removeFromHistory(_ item: String) {
        searchHistory.removeAll { $0 == item }
        saveSearchHistory()
    }

    func clearHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }

    func selectHistoryItem(_ item: String) {
        searchText = item
        commitSearch()
        applyFiltersAndSearch()
    }

    func selectPopularSearch(_ item: PopularSearchItem) {
        searchText = item.title
        commitSearch()
        applyFiltersAndSearch()
    }

    private func loadSearchHistory() {
        searchHistory = UserDefaults.standard.stringArray(forKey: searchHistoryKey) ?? []
    }

    private func saveSearchHistory() {
        UserDefaults.standard.set(searchHistory, forKey: searchHistoryKey)
    }

    // MARK: - Intelligent Search Helpers

    private func filterProducts(_ products: [Product], matching query: String) -> [Product] {
        let tokens = query
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }

        guard !tokens.isEmpty else { return products }

        // Expand each token with stemming and e-commerce domain synonyms
        let expandedTokens: [[String]] = tokens.map { expandToken($0) }

        // Tier 1: Try to match ALL tokens (strong/exact match)
        let allTokensMatches = products.filter { product in
            expandedTokens.allSatisfy { termGroup in
                productMatchesAnyTerm(product: product, terms: termGroup)
            }
        }

        if !allTokensMatches.isEmpty {
            return allTokensMatches
        }

        // Tier 2: Fallback to matching ANY token (partial/broad match)
        let anyTokenMatches = products.filter { product in
            expandedTokens.contains { termGroup in
                productMatchesAnyTerm(product: product, terms: termGroup)
            }
        }

        if !anyTokenMatches.isEmpty {
            return anyTokenMatches
        }

        // Tier 3: For Popular Searches or category queries where no direct items exist in the store,
        // return a curated fallback (e.g., all active products) so the user never sees an empty screen.
        let isPopularSearch = popularSearches.contains { $0.title.lowercased() == query } ||
                              ["shoes", "shoe", "sneakers", "sneaker", "running", "backpack", "backpacks", "bag", "bags", "sport", "wear", "sportswear"].contains(query)
        if isPopularSearch {
            return products
        }

        return []
    }

    private func productMatchesAnyTerm(product: Product, terms: [String]) -> Bool {
        let title = product.title.lowercased()
        let vendor = (product.vendor ?? "").lowercased()
        let productType = (product.productType ?? "").lowercased()
        let description = product.description.lowercased()
        let tags = product.tags.map { $0.lowercased() }
        let optionValues = product.options.flatMap { $0.values }.map { $0.lowercased() }
        let variantTitles = product.variants.map { $0.title.lowercased() }

        return terms.contains { term in
            guard !term.isEmpty else { return false }
            if title.contains(term) || vendor.contains(term) || productType.contains(term) || description.contains(term) {
                return true
            }
            if tags.contains(where: { $0.contains(term) }) {
                return true
            }
            if optionValues.contains(where: { $0.contains(term) }) || variantTitles.contains(where: { $0.contains(term) }) {
                return true
            }
            return false
        }
    }

    private func expandToken(_ token: String) -> [String] {
        var terms: Set<String> = [token]

        // 1. Basic stemming (singular/plural tolerance)
        if token.hasSuffix("ies") && token.count > 4 {
            let base = String(token.dropLast(3))
            terms.insert(base + "y")
            terms.insert(base + "i")
        } else if token.hasSuffix("es") && token.count > 4 {
            terms.insert(String(token.dropLast(2)))
            terms.insert(String(token.dropLast(1)))
        } else if token.hasSuffix("s") && !token.hasSuffix("ss") && token.count > 3 {
            terms.insert(String(token.dropLast(1)))
        } else if !token.hasSuffix("s") && token.count > 2 {
            terms.insert(token + "s")
            terms.insert(token + "es")
        }

        // 2. Domain-specific e-commerce synonym expansion
        let shoeTerms: Set<String> = ["shoe", "shoes", "sneaker", "sneakers", "footwear", "boot", "boots", "sandal", "sandals", "slide", "slides", "trainer", "trainers", "skool", "air", "gel", "boost", "canvas", "suede", "leather", "high", "low", "top", "chuck", "taylor", "martens", "palladium", "supra", "timberland", "vans", "asics", "adidas", "nike", "puma", "converse"]
        let runningTerms: Set<String> = ["running", "run", "runner", "jogging", "athletic", "sport", "sports", "trainer", "trainers", "adizero", "ultraboost", "gel", "zoom", "pegasus", "shoe", "shoes", "sneaker", "sneakers", "adidas", "nike", "asics", "puma"]
        let sportTerms: Set<String> = ["sport", "sports", "sportswear", "wear", "activewear", "apparel", "clothing", "shirt", "tshirt", "t-shirt", "hoodie", "jacket", "pants", "shorts", "jersey", "track", "gym", "fitness", "athletic", "adidas", "nike", "puma", "asics", "under armour", "reebok"]
        let backpackTerms: Set<String> = ["backpack", "backpacks", "bag", "bags", "rucksack", "pack", "tote", "duffel", "luggage", "accessory", "accessories", "gear", "storage"]

        if !shoeTerms.isDisjoint(with: terms) {
            terms.formUnion(shoeTerms)
        }
        if !runningTerms.isDisjoint(with: terms) {
            terms.formUnion(runningTerms)
        }
        if !sportTerms.isDisjoint(with: terms) {
            terms.formUnion(sportTerms)
        }
        if !backpackTerms.isDisjoint(with: terms) {
            terms.formUnion(backpackTerms)
        }

        return Array(terms)
    }
}
