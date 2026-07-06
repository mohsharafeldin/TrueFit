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
    case favorites
    case checkout
    case profile
    case address
    case productDetails(productId: String)
    case addNewAddress
    case editAddress(address: Address)
    case addressDetailsForm(address: Address)
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
typealias AppRouter = Router<AppRoute>
