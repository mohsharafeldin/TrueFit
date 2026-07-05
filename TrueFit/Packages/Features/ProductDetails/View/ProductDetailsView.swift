//
//  ProductDetailsView.swift
//  TrueFit
//
//  Created by Mona Zarea on 02/07/2026.
//

import SwiftUI

struct ProductDetailsView: View {
    @StateObject var viewModel: ProductDetailsViewModel
    let productId: String
    
    init(productId: String, viewModelFactory: @escaping () -> ProductDetailsViewModel) {
        self.productId = productId
        _viewModel = StateObject(wrappedValue: viewModelFactory())
    }
    
    var body: some View {
        ZStack {
            Color.trueFitBackground.ignoresSafeArea()
            
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading awesomeness...")
                    .scaleEffect(1.2)
                    .tint(.brandPrimary)
                
            case .failure(let error):
                ErrorView(
                    message: error.userMessage,
                    showRetry: true,
                    onRetry: {
                        Task {
                            await viewModel.retry(id: productId)
                        }
                    }
                )
                .padding()
            case .success(let product):
                productContentView(product: product)
            }
        }
        .task {
            if case .idle = viewModel.state {
                await viewModel.loadProduct(id: productId)
            }
        }
        .trueFitToast(message: $viewModel.toastMessage, style: viewModel.toastStyle)
        .navigationBarHidden(true)
    }
    
    private func productContentView(product: Product) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                // Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Parallax Image Carousel
                        GeometryReader { geo in
                            let minY = geo.frame(in: .global).minY
                            
                            // Parallax math:
                            // When scrolling down (minY > 0), image stretches and stays pinned to top.
                            // When scrolling up (minY < 0), image moves up at half speed (parallax).
                            let yOffset = minY > 0 ? -minY : -minY * 0.5
                            let height = max(420, 420 + minY)
                            
                            ProductImageCarousel(images: product.images)
                                .frame(width: geo.size.width, height: height)
                                .offset(y: yOffset)
                        }
                        .frame(height: 420)
                        .zIndex(0)
                        
                        // Dynamic Details Card (Bottom Sheet)
                        ProductDetailsCard(product: product, viewModel: viewModel)
                            .background(Color.surface)
                            .cornerRadius(Radius.xl, corners: [.topLeft, .topRight])
                            .offset(y: -40)
                            .padding(.bottom, -40)
                            .zIndex(1)
                    }
                }
                .ignoresSafeArea(.all, edges: .top)
                
                // Floating Header Over the Image
                ProductDetailsHeader(
                    isFavorite: viewModel.isFavorite,
                    onToggleFavorite: { viewModel.toggleFavorite() }
                )
            }
            
            // Sticky Bottom Bar
            ProductDetailsBottomBar(viewModel: viewModel)
        }
    }
}

