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
            Text("Home Screen (TabBar) Placeholder")
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        Text("Home Screen")
                    case .cart:
                        Text("Cart Screen")
                    case .checkout:
                        Text("Checkout Screen")
                    case .profile:
                        Text("Profile Screen")
                        
                    }
                }
        }
    }
    
}
