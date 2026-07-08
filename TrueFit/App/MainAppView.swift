
//  MainAppView.swift
//  TrueFit
//
//  Created by Mona Zarea on 29/06/2026.
//

import Foundation
import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var cartState: CartState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            TabView(selection: $appRouter.selectedTab) {
                // Home Tab
                NavigationStack(path: $appRouter.homePath) {
                    HomeView(viewModel: container.makeHomeViewModel())
                        .navigationDestination(for: AppRoute.self, destination: destination(for:))
                }
                .tabItem {
                    Image("ic_home")
                    Text("Home")
                }
                .tag(AppTab.home)
                
                // Favorites Tab
                NavigationStack(path: $appRouter.favoritesPath) {
                    FavoritesView(viewModel: container.makeFavoritesViewModel())
                        .navigationDestination(for: AppRoute.self, destination: destination(for:))
                }
                .tabItem {
                    Image("ic_favorite")
                    Text("Favorite")
                }
                .tag(AppTab.favorites)
                
                // Cart Tab
                NavigationStack(path: $appRouter.cartPath) {
                    CartView(
                        viewModelFactory: { container.makeCartViewModel() },
                        onStartShopping: {
                            appRouter.popToRoot()
                            appRouter.switchTab(to: .home)
                        }
                    )
                    .navigationDestination(for: AppRoute.self, destination: destination(for:))
                }
                .tabItem {
                    Image("ic_cart")
                    Text("Cart")
                }
                .badge(cartState.itemCount > 0 ? cartState.itemCount : 0)
                .tag(AppTab.cart)
                
                // Profile Tab
                NavigationStack(path: $appRouter.profilePath) {
                    ProfileView(viewModelFactory: { container.makeProfileViewModel() })
                        .navigationDestination(for: AppRoute.self, destination: destination(for:))
                }
                .tabItem {
                    Image("ic_profile")
                    Text("Profile")
                }
                .tag(AppTab.profile)
            }
            
            if appRouter.selectedTab == .home && appRouter.homePath.isEmpty {
                SmartAIPill {
                    appRouter.navigate(to: .aiChat)
                }
                .padding(.bottom, 60)
            }
        }
    }
}

// MARK: - Smart AI Pill
struct SmartAIPill: View {
    var action: () -> Void
    @State private var isGleaming = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .bold))
                
                Text("Ask TrueFit AI")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    // Gradient
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Shimmering
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .white.opacity(0.4), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: isGleaming ? 150 : -150)
                }
            )
            .clipShape(Capsule())
            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                isGleaming = true
            }
        }
    }
}

// MARK: - Navigation Destinations
extension MainAppView {
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .checkout:
            CheckoutView(viewModel: container.makeCheckoutViewModel())
            
        case .orderCompleted(let info):
            OrderCompletedView(info: info)
        case .payment(let amount):
            PaymentView(viewModel: container.makePaymentViewModel(orderTotal: amount))
            
        case .productDetails(let id, let variantId):
            ProductDetailsView(
                productId: id,
                preselectedVariantId: variantId,
                viewModelFactory: { container.makeProductDetailsViewModel(productId: id) }
            )
        case .search:
            SearchView(viewModel: container.makeSearchViewModel())
        case .productsByCollection(let collectionId, let title):
            ProductListView(
                viewModel: container.makeProductListViewModel(
                    source: .collection(id: collectionId, title: title)
                )
            )
        case .productsByBrand(let vendor):
            ProductListView(
                viewModel: container.makeProductListViewModel(
                    source: .brand(vendor: vendor)
                )
            )
        case .allProducts:
            ProductListView(
                viewModel: container.makeProductListViewModel(
                    source: .allProducts
                )
            )
		case .orders: 
			OrderHistoryView(viewModel: container.makeOrderHistoryViewModel())
		case .orderDetails(let orderId):
			OrderDetailsView(viewModel: container.makeOrderDetailsViewModel(orderId: orderId))
        case .address:
            AddressView(viewModel: container.addressViewModel)
        case .addressSelection:
            AddressView(viewModel: container.addressViewModel, isSelectionMode: true)
        case .addNewAddress:
            AddNewAddressView(addressViewModel: container.addressViewModel)
        case .editAddress(let address):
            AddressDetailsFormView(
                addressViewModel: container.addressViewModel,
                address:address,
                editingAddressId: address.id )
        case .addressDetailsForm(let address):
            AddressDetailsFormView(
                addressViewModel: container.addressViewModel,
                address: address,
                editingAddressId: nil )
        case .currency:
            CurrencyConverterView(viewModelFactory: container.makeCurrencyConverterViewModel())
        case .aiComparison(let products):
            AIComparisonView(viewModel: AIComparisonViewModel(products: products))
        case .aiChat:
            AIChatView(viewModel: container.makeAIChatViewModel())
            
        case .faqs:
            FAQsView()
        case .contactUs:
            ContactUsView()
        case .termsAndConditions:
            TermsAndConditionsView()
        case .reviews:
            ReviewsView()
        }
    }
}
