//
//  AuthFlowView.swift
//  TrueFit
//
//  Created by Mona Zarea on 29/06/2026.
//

import Foundation
import SwiftUI
struct AuthFlowView: View {
    var onLoginSuccess: () -> Void
    var onGuestContinue: () -> Void
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var authRouter: AuthRouter
    
    var body: some View {
        NavigationStack(path: $authRouter.path) {
            LoginView(viewModel: container.makeAuthViewModel())
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .signIn:
                        LoginView(viewModel: container.makeAuthViewModel())
                        
//                        LoginView(
//                            viewModel: container.makeAuthViewModel(),
//                            onLoginSuccess: onLoginSuccess,
//                            onGuestContinue: onGuestContinue
//                        )
                    case .signUp:
                        SignUpView(viewModel: container.makeAuthViewModel())
                        
                        
                    }
                }
        }
    }
}
