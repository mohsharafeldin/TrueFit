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
    
    var body: some View {
        NavigationStack(path: $appRouter.path) {
            HomeView(viewModel: container.makeHomeViewModel())
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(viewModel: container.makeHomeViewModel())
                    case .cart:
                        Text("Cart Screen")
                    case .checkout:
                        Text("Checkout Screen")
                    case .profile:
                        Text("Profile Screen")
                    case .productDetails(let id):
                        ProductDetailsView(
                            productId: id,
                            viewModelFactory: { container.makeProductDetailsViewModel(productId: id) }
                        )
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
                    }
                }
        }
    }
    
}
