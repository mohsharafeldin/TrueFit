//
//  HomeView.swift
//  TrueFit
//
//  Features — Home screen 

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Spacing.xl) {
                    HomeHeaderView()

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
                .padding(.bottom, 100)
            }

            HomeBottomTabBar()
        }
        .background(Color.trueFitBackground)
        .ignoresSafeArea(.all, edges: .bottom)
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
                    // TODO: Navigate to full products list
                }

                if viewModel.isLoadingProducts {
                    productGridPlaceholder
                } else if viewModel.products.isEmpty {
                    emptyStateView(message: "No products found")
                } else {
                    ProductsGridView(products: viewModel.products)
                }
            }
        }
    }

    // MARK: - Category Tab Content

    @ViewBuilder
    private var categoryTabContent: some View {
        VStack(spacing: Spacing.md) {
            if viewModel.isLoadingCollections {
                categoryPlaceholder
            } else if viewModel.collections.isEmpty {
                emptyStateView(message: "No categories found")
            } else {
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
        ForEach(0..<4, id: \.self) { _ in
            ShimmerCategoryCard()
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
    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Profile avatar
            Circle()
                .fill(Color.brandPrimary.opacity(0.15))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.brandPrimary)
                )

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Hi, Jonathan")
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
                NotificationButton()
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

// MARK: - Notification Button

struct NotificationButton: View {
    var body: some View {
        Button(action: {}) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
                    .trueFitShadow(.xs)

                Circle()
                    .fill(Color.semanticDanger)
                    .frame(width: 10, height: 10)
                    .offset(x: 2, y: -1)
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
    private let banners = BannerData.samples

    var body: some View {
        VStack(spacing: Spacing.sm) {
            TabView(selection: $currentPage) {
                ForEach(banners.indices, id: \.self) { index in
                    BannerCard(banner: banners[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 140)
            .clipShape(RoundedRectangle.trueFit(Radius.lg))

            // Page dots
            HStack(spacing: 6) {
                ForEach(banners.indices, id: \.self) { index in
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

struct BannerData: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let accentColor: Color

    static let samples: [BannerData] = [
        BannerData(title: "24% off shipping today\non bag purchases", subtitle: "By Kutuku Store", accentColor: .brandPrimary),
        BannerData(title: "New Summer Collection\njust arrived", subtitle: "Explore Now", accentColor: .categoryApparel),
        BannerData(title: "Free returns on\nall orders", subtitle: "Limited Time", accentColor: .categoryAccessories)
    ]
}

struct BannerCard: View {
    let banner: BannerData

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle.trueFit(Radius.lg)
                .fill(Color.surface)

            // Accent circle decoration
            GeometryReader { geo in
                Circle()
                    .fill(banner.accentColor.opacity(0.15))
                    .frame(width: 160, height: 160)
                    .offset(x: -40, y: geo.size.height * 0.1)
            }
            .clipped()

            HStack {
                VStack(alignment: .center, spacing: Spacing.xs) {
                    Text(banner.title)
                        .trueFitTextStyle(.headline)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(banner.subtitle)
                        .trueFitTextStyle(.caption)
                        .foregroundColor(.textSecondary)
                }
                .padding(.leading, Spacing.lg)

                Spacer()

                // Shopping bag icon as placeholder
                Image(systemName: "bag.fill")
                    .font(.system(size: 48))
                    .foregroundColor(banner.accentColor.opacity(0.3))
                    .padding(.trailing, Spacing.lg)
            }
        }
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.sm)
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

    private let columns = [
        GridItem(.flexible(), spacing: Spacing.md),
        GridItem(.flexible(), spacing: Spacing.md)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.lg) {
            ForEach(products) { product in
                HomeProductCard(product: product)
            }
        }
    }
}

// MARK: - Product Card

struct HomeProductCard: View {
    let product: Product
    @State private var isFavorite = false
    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        Button(action: {
            appRouter.navigate(to: .productDetails(productId: product.id))
        }) {
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
                                .scaledToFit()
                                .padding(Spacing.sm)
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
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .background(Color.surface)
                    .clipShape(RoundedRectangle.trueFit(Radius.lg))
                    
                    // Favorite button
                    Button {
                        withAnimation(TrueFitMotion.springSnappy) {
                            isFavorite.toggle()
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
        }
    }

    private var formattedPrice: String {
        if let value = Double(product.price) {
            return String(format: "$%.2f", value)
        }
        return "$\(product.price)"
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let collection: ProductCollection

    var body: some View {
        ZStack(alignment: .leading) {
            // Background image or gradient
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

            // Gradient overlay for text readability
            LinearGradient(
                colors: [.black.opacity(0.5), .clear, .black.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
            )

            // Text overlay
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(collection.title)
                    .trueFitTextStyle(.title2)
                    .foregroundColor(.white)

                Text("\(collection.productsCount) Product")
                    .trueFitTextStyle(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(.leading, Spacing.lg)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle.trueFit(Radius.lg))
        .trueFitShadow(.sm)
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
        RoundedRectangle.trueFit(Radius.lg)
            .fill(Color.surface)
            .frame(height: 120)
            .frame(maxWidth: .infinity)
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

// MARK: - Bottom Tab Bar

struct HomeBottomTabBar: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.borderColor)

            HStack {
                HomeTabBarItem(icon: "house.fill", title: "Home", isSelected: true)
                Spacer()
                HomeTabBarItem(icon: "shippingbox", title: "My Order", isSelected: false)
                Spacer()
                HomeTabBarItem(icon: "heart", title: "Favorite", isSelected: false)
                Spacer()
                HomeTabBarItem(icon: "person", title: "My Profile", isSelected: false)
            }
            .padding(.horizontal, Spacing.xxl)
            .padding(.top, Spacing.md)
            .padding(.bottom, 34)
            .background(Color.surface)
        }
    }
}

struct HomeTabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .brandPrimary : .textTertiary)

            Text(title)
                .font(.system(size: 10, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .brandPrimary : .textTertiary)
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
        HomeView(
            viewModel: HomeViewModel(
                fetchNewArrivalsUseCase: FetchNewArrivalsUseCase(repository: repo),
                fetchCollectionsUseCase: FetchCollectionsUseCase(repository: repo),
                fetchBrandsUseCase: FetchBrandsUseCase(repository: repo)
            )
        )
        .environmentObject(AppRouter())
    }
}
