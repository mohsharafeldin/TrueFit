//
//  HomeView.swift
//  TrueFit
//
//  Features — Home screen

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var appRouter: AppRouter
    @State private var showGuestAlert = false
    @State private var toastMessage: String?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: Spacing.xl) {
                        HomeHeaderView(userName: viewModel.userName, toastMessage: $toastMessage)

                        HomeTabSelector(selectedTab: $viewModel.selectedTab)

                        // Tab Content
                        switch viewModel.selectedTab {
                        case .home:
                            homeTabContent
                        case .category:
                            categoryTabContent
                        case .brand:
                            brandTabContent
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.sm)
                    .padding(.bottom, 120)
                }
            }
            .background(Color.trueFitBackground)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .trueFitGuestAlert(isPresented: $showGuestAlert)
        .trueFitToast(message: $toastMessage, style: .error)
        .onAppear {
            viewModel.onAppear()
        }
    }

    // MARK: - Home Tab Content
    @ViewBuilder
    private var homeTabContent: some View {
        VStack(spacing: Spacing.xl) {
            HomeBannerCarousel()

            // New Arrivals Section
            VStack(spacing: Spacing.md) {
                HomeSectionHeader(title: "New Arrivals 🔥", actionTitle: "See All") {
                    appRouter.navigate(to: .allProducts)
                }

                if viewModel.isLoadingProducts {
                    productGridPlaceholder
                } else if viewModel.products.isEmpty {
                    emptyStateView(message: "No products found")
                } else {
                    ProductsGridView(
                        products: viewModel.products,
                        favoriteStatuses: viewModel.favoriteStatuses,
                        onToggleFavorite: { product in
                            if viewModel.isGuest {
                                showGuestAlert = true
                            } else {
                                viewModel.toggleFavorite(product: product)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Category Tab Content
    @ViewBuilder
    private var categoryTabContent: some View {
        let columns = [
            GridItem(.flexible(), spacing: Spacing.sm),
            GridItem(.flexible(), spacing: Spacing.sm),
            GridItem(.flexible(), spacing: Spacing.sm)
        ]
        
        VStack(spacing: Spacing.md) {
            if viewModel.isLoadingCollections {
                categoryPlaceholder
            } else if viewModel.collections.isEmpty {
                emptyStateView(message: "No categories found")
            } else {
                LazyVGrid(columns: columns, spacing: Spacing.xl) {
                    ForEach(viewModel.collections) { collection in
                        Button(action: {
                            appRouter.navigate(to: .productsByCollection(collectionId: collection.id, title: collection.title))
                        }) {
                            CategoryCard(collection: collection)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Brand Tab Content
    @ViewBuilder
    private var brandTabContent: some View {
        VStack(spacing: Spacing.md) {
            if viewModel.isLoadingBrands {
                brandGridPlaceholder
            } else if viewModel.brands.isEmpty {
                emptyStateView(message: "No brands found")
            } else {
                ForEach(viewModel.brands) { brand in
                    Button(action: {
                        appRouter.navigate(to: .productsByBrand(vendor: brand.name))
                    }) {
                        BrandTabCard(brand: brand)
                    }
                }
            }
        }
    }

    // MARK: - Placeholders
    @ViewBuilder
    private var productGridPlaceholder: some View {
        let columns = [
            GridItem(.flexible(), spacing: Spacing.md),
            GridItem(.flexible(), spacing: Spacing.md)
        ]
        LazyVGrid(columns: columns, spacing: Spacing.lg) {
            ForEach(0..<4, id: \.self) { _ in
                ShimmerProductCard()
            }
        }
    }

    @ViewBuilder
    private var categoryPlaceholder: some View {
        let columns = [
            GridItem(.flexible(), spacing: Spacing.sm),
            GridItem(.flexible(), spacing: Spacing.sm),
            GridItem(.flexible(), spacing: Spacing.sm)
        ]
        LazyVGrid(columns: columns, spacing: Spacing.xl) {
            ForEach(0..<6, id: \.self) { _ in
                ShimmerCategoryCard()
            }
        }
    }

    @ViewBuilder
    private var brandGridPlaceholder: some View {
        VStack(spacing: Spacing.md) {
            ForEach(0..<8, id: \.self) { _ in
                ShimmerBrandTabCard()
            }
        }
    }

    @ViewBuilder
    private func emptyStateView(message: String) -> some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "bag")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)

            Text(message)
                .trueFitTextStyle(.body)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxxl)
    }
}

// MARK: - Header View

struct HomeHeaderView: View {
    let userName: String
    @Binding var toastMessage: String?
    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Profile avatar
            Image("user")
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Hi, \(userName)")
                    .trueFitTextStyle(.headline)
                    .foregroundColor(.textPrimary)

                Text("Let's go shopping")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            HStack(spacing: Spacing.md) {
                IconButton(systemName: "magnifyingglass") {
                    appRouter.navigate(to: .search)
                }
                ComparisonHeaderButton(toastMessage: $toastMessage)
            }
        }
    }
}

// MARK: - Icon Button

struct IconButton: View {
    let systemName: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.textPrimary)
                .frame(width: 40, height: 40)
                .background(Color.surface)
                .clipShape(Circle())
                .trueFitShadow(.xs)
        }
    }
}

// MARK: - Comparison Header Button

struct ComparisonHeaderButton: View {
    @ObservedObject var comparisonManager = ComparisonManager.shared
    @EnvironmentObject var appRouter: AppRouter
    @Binding var toastMessage: String?
    
    var body: some View {
        let count = comparisonManager.selectedProducts.count
        let isEnabled = count >= 2
        
        Button(action: {
            if isEnabled {
                appRouter.navigate(to: .aiComparison(products: comparisonManager.selectedProducts))
            } else {
                toastMessage = "Select at least 2 products to compare"
            }
        }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "square.split.2x1")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isEnabled ? .brandPrimary : .textTertiary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)

                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .background(isEnabled ? Color.brandPrimary : Color.textSecondary)
                        .clipShape(Circle())
                        .offset(x: 4, y: -4)
                }
            }
        }
    }
}

// MARK: - Tab Selector

struct HomeTabSelector: View {
    @Binding var selectedTab: HomeTab
    @Namespace private var tabNamespace

    var body: some View {
        HStack(spacing: Spacing.xxl) {
            ForEach(HomeTab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
            Spacer()
        }
    }

    @ViewBuilder
    private func tabButton(for tab: HomeTab) -> some View {
        VStack(spacing: Spacing.xs) {
            Text(tab.title)
                .trueFitTextStyle(selectedTab == tab ? .headline : .callout)
                .foregroundColor(selectedTab == tab ? .textPrimary : .textTertiary)

            if selectedTab == tab {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.brandPrimary)
                    .frame(width: 40, height: 3)
                    .matchedGeometryEffect(id: "tab_indicator", in: tabNamespace)
            } else {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.clear)
                    .frame(width: 40, height: 3)
            }
        }
        .onTapGesture {
            withAnimation(TrueFitMotion.springDefault) {
                selectedTab = tab
            }
        }
    }
}

// MARK: - Banner Carousel

struct HomeBannerCarousel: View {
    @State private var currentPage = 0
    private let slides = ["slide1", "slide4" , "slide2", "slide3"]
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: Spacing.sm) {
            TabView(selection: $currentPage) {
                ForEach(slides.indices, id: \.self) { index in
                    Image(slides[index])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 140)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))
            .onReceive(timer) { _ in
                withAnimation {
                    currentPage = (currentPage + 1) % slides.count
                }
            }

            // Page dots
            HStack(spacing: 6) {
                ForEach(slides.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.brandPrimary : Color.textTertiary.opacity(0.3))
                        .frame(width: index == currentPage ? 8 : 6,
                               height: index == currentPage ? 8 : 6)
                        .animation(TrueFitMotion.springSnappy, value: currentPage)
                }
            }
        }
    }
}

// MARK: - Section Header

struct HomeSectionHeader: View {
    let title: String
    let actionTitle: String
    var action: () -> Void = {}

    var body: some View {
        HStack {
            Text(title)
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)

            Spacer()

            Button(action: action) {
                Text(actionTitle)
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.brandPrimary)
            }
        }
    }
}

// MARK: - Products Grid

struct ProductsGridView: View {
    let products: [Product]
    let favoriteStatuses: [String: Bool]
    let onToggleFavorite: (Product) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: Spacing.lg),
        GridItem(.flexible(), spacing: Spacing.lg)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.lg) {
            ForEach(products) { product in
                HomeProductCard(
                    product: product,
                    isFavorite: favoriteStatuses[product.id] ?? false,
                    onToggleFavorite: {
                        onToggleFavorite(product)
                    }
                )
            }
        }
    }
}

// MARK: - Product Card

struct HomeProductCard: View {
    let product: Product
    var isFavorite: Bool = false
    var onToggleFavorite: () -> Void = {}
    @EnvironmentObject var appRouter: AppRouter
    @ObservedObject var currencyManager = CurrencyManager.shared
    @ObservedObject var comparisonManager = ComparisonManager.shared

    var body: some View {
        VStack(spacing: Spacing.sm) {
            ZStack(alignment: .topTrailing) {
                // Product Image
                AsyncImage(url: product.imageURL) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle.trueFit(Radius.lg)
                            .fill(Color.surface)
                            .overlay(
                                ProgressView()
                                    .tint(.brandPrimary)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        RoundedRectangle.trueFit(Radius.lg)
                            .fill(Color.surface)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 28))
                                    .foregroundColor(.textTertiary)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 130)
                .frame(maxWidth: .infinity)
                .background(Color.surface)
                .clipShape(RoundedRectangle.trueFit(Radius.lg))
                .overlay(
                    RoundedRectangle.trueFit(Radius.lg)
                        .stroke(comparisonManager.isSelected(product) ? Color.brandPrimary : Color.gray.opacity(0.2), lineWidth: comparisonManager.isSelected(product) ? 3 : 1)
                )
                .overlay(
                    Group {
                        if comparisonManager.isSelected(product) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.brandPrimary)
                                .padding(Spacing.sm)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 20)
                                )
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                    }
                )
                
                // Favorite button
                Button {
                    withAnimation(TrueFitMotion.springSnappy) {
                        onToggleFavorite()
                    }
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isFavorite ? .statusWishlistActive : .white)
                        .padding(Spacing.xs)
                        .background(Color.black.opacity(0.25))
                        .clipShape(Circle())
                }
                .padding(Spacing.xs)
            }
            .trueFitShadow(.xs)
            
            // Product Info
            VStack(spacing: Spacing.xxs) {
                Text(product.title)
                    .trueFitTextStyle(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Text(product.vendor ?? "")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
                
                Text(formattedPrice)
                    .trueFitTextStyle(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .padding(.top, 2)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            appRouter.navigate(to: .productDetails(productId: product.id))
        }
        .onLongPressGesture(minimumDuration: 0.5) {
            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
            impactMed.impactOccurred()
            withAnimation(.spring()) {
                comparisonManager.toggleSelection(for: product)
            }
        }
    }

    private var formattedPrice: String {
        if let value = Decimal(string: product.price) {
            return PriceFormatter.format(value)
        }
        return product.price
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let collection: ProductCollection

    var body: some View {
        VStack(spacing: Spacing.sm) {
            // Background image
            Group {
                if let imageURL = collection.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            categoryPlaceholderBackground
                        }
                    }
                } else {
                    categoryPlaceholderBackground
                }
            }
            .frame(width: 80, height: 80)
            .background(Circle().fill(Color.surface))
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
            .trueFitShadow(.md)

            // Text overlay
            VStack(spacing: 2) {
                Text(collection.title)
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)

                Text("\(collection.productsCount) Product")
                    .trueFitTextStyle(.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }
        }
    }

    @ViewBuilder
    private var categoryPlaceholderBackground: some View {
        LinearGradient(
            colors: [Color.brandPrimary.opacity(0.6), Color.brandPrimary.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Brand Tab Card

struct BrandTabCard: View {
    let brand: Brand
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background
            RoundedRectangle.trueFit(Radius.lg)
                .fill(Color.surface)
            
            // Image aligned to the right
            HStack {
                Spacer()
                if let imageURL = brand.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .padding(Spacing.lg)
                                .frame(width: 150)
                        default:
                            brandInitials
                        }
                    }
                } else {
                    brandInitials
                }
            }
            
            // Text overlay
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(brand.name)
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.textPrimary)
                
                Text("\(brand.productCount) Items")
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.textSecondary)
            }
            .padding(.leading, Spacing.lg)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.sm)
    }
    
    private var brandInitials: some View {
        Text(brand.name.prefix(2).uppercased())
            .trueFitTextStyle(.title1)
            .fontWeight(.bold)
            .foregroundColor(.brandPrimary.opacity(0.3))
            .frame(width: 150)
    }
}

// MARK: - Shimmer Product Card (Loading)

struct ShimmerProductCard: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: Spacing.sm) {
            RoundedRectangle.trueFit(Radius.lg)
                .fill(Color.surface)
                .frame(height: 160)
                .overlay(
                    RoundedRectangle.trueFit(Radius.lg)
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.3), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: isAnimating ? 200 : -200)
                )
                .clipped()

            VStack(spacing: Spacing.xxs) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(height: 14)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(width: 80, height: 12)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(width: 60, height: 14)
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: TrueFitMotion.loadingCycle)
                .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Shimmer Category Card (Loading)

struct ShimmerCategoryCard: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: Spacing.sm) {
            Circle()
                .fill(Color.surface)
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.3), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: isAnimating ? 100 : -100)
                )
                .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .clipped()
                .trueFitShadow(.md)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.surface)
                .frame(width: 60, height: 12)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.surface)
                .frame(width: 40, height: 10)
        }
            .onAppear {
                withAnimation(
                    .linear(duration: TrueFitMotion.loadingCycle)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Shimmer Brand Tab Card (Loading)

struct ShimmerBrandTabCard: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle.trueFit(Radius.lg)
                .fill(Color.surface)
                .frame(height: 120)
                .overlay(
                    RoundedRectangle.trueFit(Radius.lg)
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.3), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: isAnimating ? 400 : -400)
                )
                .clipped()
            
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.surface)
                    .frame(width: 80, height: 80)
                    .padding(Spacing.lg)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(width: 120, height: 24)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.surface)
                    .frame(width: 80, height: 16)
            }
            .padding(.leading, Spacing.lg)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(
                .linear(duration: TrueFitMotion.loadingCycle)
                .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = ProductsRepository(
            remoteDataSource: ProductsRemoteDataSource(
                apiClient: RESTClient()
            )
        )
        
        let mockFavoritesRepo = MockFavoritesRepository()
        let mockPreferences = PreferencesManager()
        
        HomeView(
            viewModel: HomeViewModel(
                fetchNewArrivalsUseCase: FetchNewArrivalsUseCase(repository: repo),
                fetchCollectionsUseCase: FetchCollectionsUseCase(repository: repo),
                fetchBrandsUseCase: FetchBrandsUseCase(repository: repo),
                toggleFavoriteUseCase: ToggleFavoriteUseCase(repository: mockFavoritesRepo),
                isFavoriteUseCase: IsFavoriteUseCase(repository: mockFavoritesRepo),
                preferencesManager: mockPreferences
            )
        )
        .environmentObject(CartState())
        .environmentObject(AppRouter())
    }
}
