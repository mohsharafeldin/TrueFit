//
//  File.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import SwiftUI
enum AuthRoute: Hashable {
    case signIn
    case signUp
    case forgotPassword
}
 
enum AppRoute: Hashable {
  //  case home
  //  case cart
   // case favorites
    case checkout
    case search
    case productDetails(productId: String)
    case productsByCollection(collectionId: Int64, title: String)
    case productsByBrand(vendor: String)
    case currency
}

enum AppTab: Hashable {
    case home
    case favorites
    case cart
    case profile
}

final class AppRouter: ObservableObject {
    @Published var selectedTab: AppTab = .home
    
    @Published var homePath = NavigationPath()
    @Published var favoritesPath = NavigationPath()
    @Published var cartPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    
    func navigate(to route: AppRoute) {
        switch selectedTab {
        case .home: homePath.append(route)
        case .favorites: favoritesPath.append(route)
        case .cart: cartPath.append(route)
        case .profile: profilePath.append(route)
        }
    }
    
    func goBack() {
        switch selectedTab {
        case .home: if !homePath.isEmpty { homePath.removeLast() }
        case .favorites: if !favoritesPath.isEmpty { favoritesPath.removeLast() }
        case .cart: if !cartPath.isEmpty { cartPath.removeLast() }
        case .profile: if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }
    
    func switchTab(to tab: AppTab) {
            selectedTab = tab
        }
    
    func popToRoot() {
        switch selectedTab {
        case .home: homePath = NavigationPath()
        case .favorites: favoritesPath = NavigationPath()
        case .cart: cartPath = NavigationPath()
        case .profile: profilePath = NavigationPath()
        }
    }
    
    func popAllToRoot() {
        homePath = NavigationPath()
        favoritesPath = NavigationPath()
        cartPath = NavigationPath()
        profilePath = NavigationPath()
        selectedTab = .home
    }
}

final class Router<Route: Hashable>: ObservableObject {

    @Published var path = NavigationPath()

    func navigate(to route: Route) {
        path.append(route)
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}

typealias AuthRouter = Router<AuthRoute>
