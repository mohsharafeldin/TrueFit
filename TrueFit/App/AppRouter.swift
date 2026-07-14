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
    case orderCompleted(OrderCompletedInfo)
    case payment(amount: Decimal)
    case search
    case productDetails(productId: String, variantId: String? = nil)
    case productsByCollection(collectionId: Int64, title: String)
    case productsByBrand(vendor: String)
    case allProducts
    case orders
    case orderDetails(orderId: String)
    case address
    case addressSelection
    case addNewAddress
    case editAddress(address: Address)
    case addressDetailsForm(address: Address)
    case currency
    case aiComparison(products: [Product])
    case aiChat
    
    // Support
    case faqs
    case contactUs
    case termsAndConditions
    
    // Product
    case reviews
}

enum AppTab: Hashable {
    case home
    case favorites
    case cart
    case profile
    case payment
}

final class AppRouter: ObservableObject {
    @Published var selectedTab: AppTab = .home
    
    @Published var homePath = NavigationPath()
    @Published var favoritesPath = NavigationPath()
    @Published var cartPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    @Published var paymentPath = NavigationPath()
    
    func navigate(to route: AppRoute) {
        switch selectedTab {
        case .home: homePath.append(route)
        case .favorites: favoritesPath.append(route)
        case .cart: cartPath.append(route)
        case .profile: profilePath.append(route)
        case .payment: paymentPath.append(route)
        }
    }
    
    func goBack() {
        switch selectedTab {
        case .home: if !homePath.isEmpty { homePath.removeLast() }
        case .favorites: if !favoritesPath.isEmpty { favoritesPath.removeLast() }
        case .cart: if !cartPath.isEmpty { cartPath.removeLast() }
        case .profile: if !profilePath.isEmpty { profilePath.removeLast() }
        case .payment: if !paymentPath.isEmpty { paymentPath.removeLast() }
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
        case .payment: paymentPath = NavigationPath()
        }
    }
    
    func popAllToRoot() {
        homePath = NavigationPath()
        favoritesPath = NavigationPath()
        cartPath = NavigationPath()
        profilePath = NavigationPath()
        paymentPath = NavigationPath()
        selectedTab = .home
    }
    func pop(count: Int) {
           switch selectedTab {
           case .home:
               homePath.removeLast(min(count, homePath.count))
           case .favorites:
               favoritesPath.removeLast(min(count, favoritesPath.count))
           case .cart:
               cartPath.removeLast(min(count, cartPath.count))
           case .profile:
               profilePath.removeLast(min(count, profilePath.count))
           case .payment:
               paymentPath.removeLast(min(count, paymentPath.count))
           }
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

    func pop(count: Int) {
        guard path.count >= count else {
            popToRoot()
            return
        }
        path.removeLast(count)
    }

    func popToRoot() {
        path = NavigationPath()
    }
}

typealias AuthRouter = Router<AuthRoute>
