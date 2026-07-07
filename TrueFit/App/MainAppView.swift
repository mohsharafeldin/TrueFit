//
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
        
    }
}

extension MainAppView {
    
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
            
        case .checkout:
            Text("Checkout Screen")
            
        case .productDetails(let id):
            ProductDetailsView(
                productId: id,
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
        case .currency:
            CurrencyConverterView(viewModelFactory: container.makeCurrencyConverterViewModel())
        }
    }
}
