//
//  SearchView.swift
//  TrueFit
//
//  Features — Search screen with global search, filters, and sorting.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @EnvironmentObject var appRouter: AppRouter
    @ObservedObject var currencyManager = CurrencyManager.shared
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Search Header
                searchHeader

                // Content
                switch viewModel.state {
                case .idle, .loading:
                    if viewModel.isLoading {
                        loadingContent
                    } else {
                        initialContent
                    }

                case .failure(let error):
                    Spacer()
                    ErrorView(
                        message: error.userMessage,
                        showRetry: true,
                        onRetry: {
                            Task { await viewModel.retry() }
                        }
                    )
                    Spacer()

                case .success:
                    if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !viewModel.hasActiveFilters {
                        initialContent
                    } else {
                        searchResultsContent
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadData()
        }
        .sheet(isPresented: $viewModel.showFilterSheet) {
            FilterSheetView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            isSearchFocused = true
        }
    }

    // MARK: - Search Header

    private var searchHeader: some View {
        HStack(spacing: Spacing.sm) {
            // Back button
            Button(action: {
                appRouter.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)
            }

            // Search field
            HStack(spacing: Spacing.xs) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textTertiary)

                TextField("Search products, brands...", text: $viewModel.searchText)
                    .trueFitTextStyle(.body)
                    .foregroundColor(.textPrimary)
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        isSearchFocused = false
                        viewModel.commitSearch()
                    }

                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                        viewModel.applyFiltersAndSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.textTertiary)
                    }
                }
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.sm)
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.md))
            .trueFitShadow(.xs)

            // Filter button
            Button(action: {
                viewModel.showFilterSheet = true
            }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(Color.surface)
                            .clipShape(Circle())
                            .trueFitShadow(.xs)

                        // Badge showing active filter count
                        if viewModel.activeFilterCount > 0 {
                            Text("\(viewModel.activeFilterCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(Color.brandPrimary)
                                .clipShape(Circle())
                                .offset(x: 2, y: -2)
                        }
                    }
                }
                .transition(.scale.combined(with: .opacity))
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.sm)
        .animation(TrueFitMotion.springDefault, value: viewModel.searchText.isEmpty)
    }

    // MARK: - Initial Content (Empty Query)

    private var initialContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // Last Search Section
                if !viewModel.searchHistory.isEmpty {
                    lastSearchSection
                }

                // Popular Search Section
                popularSearchSection
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, Spacing.md)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Last Search Section

    private var lastSearchSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("Last Search")
                    .trueFitTextStyle(.title3)
                    .foregroundColor(.textPrimary)

                Spacer()

                Button(action: {
                    withAnimation(TrueFitMotion.springDefault) {
                        viewModel.clearHistory()
                    }
                }) {
                    Text("Clear All")
                        .trueFitTextStyle(.subheadline)
                        .foregroundColor(.brandPrimary)
                }
            }

            // Chip pills — wrapping layout
            FlowLayout(spacing: Spacing.xs) {
                ForEach(viewModel.searchHistory, id: \.self) { item in
                    SearchHistoryChip(
                        text: item,
                        onTap: {
                            isSearchFocused = false
                            viewModel.selectHistoryItem(item)
                        },
                        onRemove: {
                            withAnimation(TrueFitMotion.springDefault) {
                                viewModel.removeFromHistory(item)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Popular Search Section

    private var popularSearchSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Popular Search")
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)

            VStack(spacing: 0) {
                ForEach(viewModel.popularSearches) { item in
                    Button(action: {
                        isSearchFocused = false
                        viewModel.selectPopularSearch(item)
                    }) {
                        PopularSearchRow(item: item)
                    }

                    if item.id != viewModel.popularSearches.last?.id {
                        Divider()
                            .background(Color.borderColor)
                            .padding(.leading, 68)
                    }
                }
            }
            .background(Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .trueFitShadow(.xs)
        }
    }

    // MARK: - Search Results

    private var searchResultsContent: some View {
        VStack(spacing: 0) {
            // Sort Tabs
            sortTabsBar

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Spacing.md) {
                    // Results count
                    HStack {
                        Text("\(viewModel.filteredProducts.count) Product\(viewModel.filteredProducts.count == 1 ? "" : "s") Found")
                            .trueFitTextStyle(.caption)
                            .foregroundColor(.textSecondary)
                        Spacer()
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.xs)

                    // Active filters preview
                    if viewModel.hasActiveFilters {
                        activeFiltersBar
                    }

                    if viewModel.filteredProducts.isEmpty {
                        emptyResultsView
                    } else {
                        productGrid
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }

    // MARK: - Sort Tabs

    private var sortTabsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                ForEach(SearchSortOption.allCases, id: \.self) { option in
                    SortChip(
                        title: option.title,
                        isSelected: viewModel.selectedSort == option,
                        action: { viewModel.selectSort(option) }
                    )
                }
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.sm)
        }
    }

    // MARK: - Active Filters Bar

    private var activeFiltersBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.xs) {
                if !viewModel.selectedBrands.isEmpty {
                    ForEach(Array(viewModel.selectedBrands).sorted(), id: \.self) { brand in
                        ActiveFilterChip(text: brand) {
                            withAnimation(TrueFitMotion.springDefault) {
                                viewModel.toggleBrand(brand)
                                viewModel.applyFiltersAndSearch()
                            }
                        }
                    }
                }

                if !viewModel.selectedSubCategories.isEmpty {
                    ForEach(Array(viewModel.selectedSubCategories).sorted(), id: \.self) { sub in
                        ActiveFilterChip(text: sub) {
                            withAnimation(TrueFitMotion.springDefault) {
                                viewModel.toggleSubCategory(sub)
                                viewModel.applyFiltersAndSearch()
                            }
                        }
                    }
                }

                if viewModel.currentPriceMin > viewModel.priceRangeMin ||
                   viewModel.currentPriceMax < viewModel.priceRangeMax {
                    ActiveFilterChip(
                        text: "\(PriceFormatter.format(Decimal(viewModel.currentPriceMin))) – \(PriceFormatter.format(Decimal(viewModel.currentPriceMax)))"
                    ) {
                        withAnimation(TrueFitMotion.springDefault) {
                            viewModel.currentPriceMin = viewModel.priceRangeMin
                            viewModel.currentPriceMax = viewModel.priceRangeMax
                            viewModel.applyFiltersAndSearch()
                        }
                    }
                }

                // Clear all filters
                if viewModel.hasActiveFilters {
                    Button(action: {
                        withAnimation(TrueFitMotion.springDefault) {
                            viewModel.resetFilters()
                        }
                    }) {
                        Text("Clear All")
                            .trueFitTextStyle(.caption)
                            .foregroundColor(.semanticDanger)
                    }
                    .padding(.leading, Spacing.xxs)
                }
            }
            .padding(.horizontal, Spacing.lg)
        }
    }

    // MARK: - Product Grid

    private var productGrid: some View {
        let columns = [
            GridItem(.flexible(), spacing: Spacing.md),
            GridItem(.flexible(), spacing: Spacing.md)
        ]

        return LazyVGrid(columns: columns, spacing: Spacing.lg) {
            ForEach(Array(viewModel.filteredProducts.enumerated()), id: \.element.id) { index, product in
                HomeProductCard(product: product)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .opacity
                    ))
                    .animation(
                        TrueFitMotion.springDefault.delay(Double(index) * TrueFitMotion.staggerDelay),
                        value: viewModel.filteredProducts.count
                    )
            }
        }
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Empty Results

    private var emptyResultsView: some View {
        VStack(spacing: Spacing.md) {
            Spacer().frame(height: Spacing.xxxl)

            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)

            Text("No results found")
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)

            Text("Try adjusting your search or filters\nto find what you're looking for.")
                .trueFitTextStyle(.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)

            if viewModel.hasActiveFilters {
                Button(action: {
                    withAnimation(TrueFitMotion.springDefault) {
                        viewModel.resetFilters()
                    }
                }) {
                    Text("Clear Filters")
                        .trueFitTextStyle(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.vertical, Spacing.sm)
                        .background(Color.brandPrimary)
                        .clipShape(RoundedRectangle.trueFit(Radius.pill))
                }
                .padding(.top, Spacing.sm)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Loading Content

    private var loadingContent: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Shimmer for search suggestions
                ForEach(0..<5, id: \.self) { _ in
                    HStack(spacing: Spacing.md) {
                        RoundedRectangle.trueFit(Radius.md)
                            .fill(Color.surface)
                            .frame(width: 48, height: 48)

                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.surface)
                                .frame(width: 140, height: 14)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.surface)
                                .frame(width: 100, height: 12)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, Spacing.lg)
                }
            }
            .padding(.top, Spacing.lg)
        }
    }
}

// MARK: - Search History Chip

struct SearchHistoryChip: View {
    let text: String
    var onTap: () -> Void
    var onRemove: () -> Void

    var body: some View {
        HStack(spacing: Spacing.xxs) {
            Button(action: onTap) {
                Text(text)
                    .trueFitTextStyle(.footnote)
                    .foregroundColor(.textPrimary)
            }

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(Color.surface)
        .clipShape(RoundedRectangle.trueFit(Radius.pill))
        .overlay(
            RoundedRectangle.trueFit(Radius.pill)
                .stroke(Color.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Popular Search Row

struct PopularSearchRow: View {
    let item: PopularSearchItem

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Icon
            Image(systemName: item.imageSystemName)
                .font(.system(size: 22))
                .foregroundColor(.brandPrimary)
                .frame(width: 48, height: 48)
                .background(Color.brandPrimary.opacity(0.1))
                .clipShape(RoundedRectangle.trueFit(Radius.md))

            // Text
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(item.title)
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.textPrimary)

                Text(item.searchCount)
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            // Badge
            if let badge = item.badge {
                Text(badge.rawValue)
                    .trueFitTextStyle(.caption2)
                    .foregroundColor(badgeTextColor(badge))
                    .padding(.horizontal, Spacing.xs)
                    .padding(.vertical, Spacing.xxs)
                    .background(badgeBackgroundColor(badge))
                    .clipShape(RoundedRectangle.trueFit(Radius.sm))
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }

    private func badgeTextColor(_ badge: PopularBadge) -> Color {
        switch badge {
        case .hot: return .statusSale
        case .new: return .statusNew
        case .popular: return .categoryAccessories
        }
    }

    private func badgeBackgroundColor(_ badge: PopularBadge) -> Color {
        switch badge {
        case .hot: return .statusSale.opacity(0.12)
        case .new: return .statusNew.opacity(0.12)
        case .popular: return .categoryAccessories.opacity(0.12)
        }
    }
}

// MARK: - Sort Chip

struct SortChip: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .trueFitTextStyle(.footnote)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.xs)
                .background(isSelected ? Color.brandPrimary : Color.surface)
                .clipShape(RoundedRectangle.trueFit(Radius.pill))
                .overlay(
                    RoundedRectangle.trueFit(Radius.pill)
                        .stroke(isSelected ? Color.clear : Color.borderColor, lineWidth: 1)
                )
        }
        .animation(TrueFitMotion.springSnappy, value: isSelected)
    }
}

// MARK: - Active Filter Chip

struct ActiveFilterChip: View {
    let text: String
    var onRemove: () -> Void

    var body: some View {
        HStack(spacing: Spacing.xxs) {
            Text(text)
                .trueFitTextStyle(.caption)
                .foregroundColor(.brandPrimary)

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.brandPrimary)
            }
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs - 2)
        .background(Color.brandPrimary.opacity(0.1))
        .clipShape(RoundedRectangle.trueFit(Radius.pill))
    }
}

// MARK: - Flow Layout (Wrapping Chips)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            guard index < result.positions.count else { break }
            subview.place(
                at: CGPoint(
                    x: bounds.minX + result.positions[index].x,
                    y: bounds.minY + result.positions[index].y
                ),
                proposal: .unspecified
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            maxX = max(maxX, currentX)
        }

        return (positions, CGSize(width: maxX, height: currentY + lineHeight))
    }
}

// MARK: - Filter Sheet View

struct FilterSheetView: View {
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.trueFitBackground.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Spacing.xl) {
                        // Price Range
                        priceRangeSection

                        Divider().background(Color.borderColor)

                        // Category
                        if !viewModel.collections.isEmpty {
                            categorySection

                            Divider().background(Color.borderColor)
                        }

                        // Sub-Categories (Product Types)
                        if !viewModel.availableSubCategories.isEmpty {
                            subCategorySection

                            Divider().background(Color.borderColor)
                        }

                        // Brands
                        if !viewModel.brands.isEmpty {
                            brandsSection
                        }

                        Spacer().frame(height: Spacing.xl)

                        // Action Buttons
                        actionButtons
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.md)
                    .padding(.bottom, Spacing.xxxl)
                }
            }
            .navigationTitle("Filter By")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        withAnimation(TrueFitMotion.springDefault) {
                            viewModel.resetFilters()
                        }
                    }
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.semanticDanger)
                }
            }
        }
    }

    // MARK: - Price Range Section

    private var priceRangeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("Price")
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(PriceFormatter.format(Decimal(viewModel.currentPriceMin))) - \(PriceFormatter.format(Decimal(viewModel.currentPriceMax)))")
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.textSecondary)
            }

            VStack(spacing: Spacing.sm) {
                // Min price slider
                HStack(spacing: Spacing.sm) {
                    Text("Min")
                        .trueFitTextStyle(.caption)
                        .foregroundColor(.textTertiary)
                        .frame(width: 30)

                    Slider(
                        value: $viewModel.currentPriceMin,
                        in: viewModel.priceRangeMin...viewModel.priceRangeMax,
                        step: 5
                    )
                    .tint(.brandPrimary)
                    .onChange(of: viewModel.currentPriceMin) { newValue in
                        if newValue > viewModel.currentPriceMax {
                            viewModel.currentPriceMin = viewModel.currentPriceMax
                        }
                    }

                    Text(PriceFormatter.format(Decimal(viewModel.currentPriceMin)))
                        .trueFitTextStyle(.caption)
                        .foregroundColor(.textPrimary)
                        .frame(width: 60, alignment: .trailing)
                }

                // Max price slider
                HStack(spacing: Spacing.sm) {
                    Text("Max")
                        .trueFitTextStyle(.caption)
                        .foregroundColor(.textTertiary)
                        .frame(width: 30)

                    Slider(
                        value: $viewModel.currentPriceMax,
                        in: viewModel.priceRangeMin...viewModel.priceRangeMax,
                        step: 5
                    )
                    .tint(.brandPrimary)
                    .onChange(of: viewModel.currentPriceMax) { newValue in
                        if newValue < viewModel.currentPriceMin {
                            viewModel.currentPriceMax = viewModel.currentPriceMin
                        }
                    }

                    Text(PriceFormatter.format(Decimal(viewModel.currentPriceMax)))
                        .trueFitTextStyle(.caption)
                        .foregroundColor(.textPrimary)
                        .frame(width: 60, alignment: .trailing)
                }
            }
        }
    }

    // MARK: - Category Section

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Category")
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(viewModel.collections) { collection in
                        CategoryFilterCard(
                            collection: collection,
                            isSelected: viewModel.selectedCategory?.id == collection.id,
                            action: {
                                withAnimation(TrueFitMotion.springSnappy) {
                                    viewModel.selectCategory(collection)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    // MARK: - Sub-Category Section

    private var subCategorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Product Type")
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)

            FlowLayout(spacing: Spacing.xs) {
                ForEach(viewModel.availableSubCategories, id: \.self) { subCategory in
                    FilterChip(
                        title: subCategory,
                        isSelected: viewModel.selectedSubCategories.contains(subCategory),
                        action: {
                            withAnimation(TrueFitMotion.springSnappy) {
                                viewModel.toggleSubCategory(subCategory)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Brands Section

    private var brandsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Brand")
                .trueFitTextStyle(.headline)
                .foregroundColor(.textPrimary)

            FlowLayout(spacing: Spacing.xs) {
                ForEach(viewModel.brands) { brand in
                    FilterChip(
                        title: brand.name,
                        isSelected: viewModel.selectedBrands.contains(brand.name),
                        action: {
                            withAnimation(TrueFitMotion.springSnappy) {
                                viewModel.toggleBrand(brand.name)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        Button(action: {
            viewModel.applyFilters()
            dismiss()
        }) {
            Text("Apply Filter")
                .trueFitTextStyle(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(
                    LinearGradient(
                        colors: [Color.brandPrimary, Color.brandPrimaryPressed],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle.trueFit(Radius.xl))
                .trueFitShadow(.md)
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xxs) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                }

                Text(title)
                    .trueFitTextStyle(.footnote)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .white : .textPrimary)
            }
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(isSelected ? Color.brandPrimary : Color.surface)
            .clipShape(RoundedRectangle.trueFit(Radius.pill))
            .overlay(
                RoundedRectangle.trueFit(Radius.pill)
                    .stroke(isSelected ? Color.clear : Color.borderColor, lineWidth: 1)
            )
        }
        .animation(TrueFitMotion.springSnappy, value: isSelected)
    }
}

// MARK: - Category Filter Card

struct CategoryFilterCard: View {
    let collection: ProductCollection
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                ZStack {
                    // Image or placeholder background
                    if let imageURL = collection.imageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            default:
                                placeholderBackground
                            }
                        }
                    } else {
                        placeholderBackground
                    }

                    // Selected overlay (tint and checkmark)
                    if isSelected {
                        Color.brandPrimary.opacity(0.4)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.brandPrimary)
                            .clipShape(Circle())
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle.trueFit(Radius.lg))
                .overlay(
                    RoundedRectangle.trueFit(Radius.lg)
                        .stroke(isSelected ? Color.brandPrimary : Color.borderColor, lineWidth: isSelected ? 2 : 1)
                )
                .modifier(OptionalShadow(isSelected: isSelected))

                Text(collection.title)
                    .trueFitTextStyle(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .brandPrimary : .textPrimary)
                    .lineLimit(1)
                    .frame(maxWidth: 80)
            }
        }
        .animation(TrueFitMotion.springSnappy, value: isSelected)
    }

    private var placeholderBackground: some View {
        LinearGradient(
            colors: [Color.surface, Color.borderColor.opacity(0.5)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Optional Shadow Modifier

struct OptionalShadow: ViewModifier {
    let isSelected: Bool
    func body(content: Content) -> some View {
        if isSelected {
            content.trueFitShadow(.sm)
        } else {
            content
        }
    }
}
