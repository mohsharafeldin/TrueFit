//
//  ProductListView.swift
//  TrueFit
//
//  Features — Product list screen showing products for a given brand or collection.
//

import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel: ProductListViewModel
    @EnvironmentObject var appRouter: AppRouter

    private let columns = [
        GridItem(.flexible(), spacing: Spacing.md),
        GridItem(.flexible(), spacing: Spacing.md)
    ]

    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()

            switch viewModel.state {
            case .idle, .loading:
                VStack(spacing: Spacing.lg) {
                    productListHeader

                    // Shimmer placeholder grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: Spacing.lg) {
                            ForEach(0..<6, id: \.self) { _ in
                                ShimmerProductCard()
                            }
                        }
                        .padding(.horizontal, Spacing.lg)
                    }
                }

            case .failure(let error):
                VStack(spacing: Spacing.lg) {
                    productListHeader
                    Spacer()
                    ErrorView(
                        message: error.userMessage,
                        showRetry: true,
                        onRetry: {
                            Task {
                                await viewModel.retry()
                            }
                        }
                    )
                    Spacer()
                }

            case .success(let products):
                VStack(spacing: 0) {
                    productListHeader

                    if products.isEmpty {
                        Spacer()
                        VStack(spacing: Spacing.md) {
                            Image(systemName: "bag")
                                .font(.system(size: 48))
                                .foregroundColor(.textTertiary)

                            Text("No products found")
                                .trueFitTextStyle(.body)
                                .foregroundColor(.textSecondary)
                        }
                        Spacer()
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            // Product count
                            HStack {
                                Text("\(products.count) Product\(products.count == 1 ? "" : "s")")
                                    .trueFitTextStyle(.caption)
                                    .foregroundColor(.textSecondary)
                                Spacer()
                            }
                            .padding(.horizontal, Spacing.lg)
                            .padding(.top, Spacing.sm)

                            LazyVGrid(columns: columns, spacing: Spacing.lg) {
                                ForEach(products) { product in
                                    HomeProductCard(product: product)
                                }
                            }
                            .padding(.horizontal, Spacing.lg)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            if case .idle = viewModel.state {
                await viewModel.loadProducts()
            }
        }
    }

    // MARK: - Header

    private var productListHeader: some View {
        HStack(spacing: Spacing.md) {
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

            Text(viewModel.title)
                .trueFitTextStyle(.title3)
                .foregroundColor(.textPrimary)
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.top, Spacing.sm)
        .padding(.bottom, Spacing.xs)
    }
}
