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
    case home
    case cart
    case checkout
    case profile
    case search
    case productDetails(productId: String)
    case productsByCollection(collectionId: Int64, title: String)
    case productsByBrand(vendor: String)
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
typealias AppRouter = Router<AppRoute>
