//
//  AuthFlowView.swift
//  TrueFit
//
//  Created by Mona Zarea on 29/06/2026.
//

import Foundation
import SwiftUI
struct AuthFlowView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        NavigationStack(path: $appRouter.path) {
            Text("SignIn View Placeholder")
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .signIn:
                        Text("Signin Screen")
                    case .signUp:
                        Text("Sign Up Screen")
                    default:
                        EmptyView() // Ignore main app routes while logged out
                    }
                }
        }
    }
}
