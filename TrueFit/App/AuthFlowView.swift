//
//  AuthFlowView.swift
//  TrueFit
//
//  Created by Mona Zarea on 29/06/2026.
//

import Foundation
import SwiftUI

struct AuthFlowView: View {
   
    
    @StateObject private var viewModel: AuthViewModel
    @EnvironmentObject var authRouter: AuthRouter

    init(container: DIContainer) {
        _viewModel = StateObject(wrappedValue: container.makeAuthViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $authRouter.path) {
            WelcomeAuthView(viewModel: viewModel)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .signIn:
                        LoginView(viewModel: viewModel)
                    case .signUp:
                        SignUpView(viewModel: viewModel)
                    case .forgotPassword:
                        ForgotPasswordView(viewModel: viewModel)
                    }
                }
        }
    }
}
