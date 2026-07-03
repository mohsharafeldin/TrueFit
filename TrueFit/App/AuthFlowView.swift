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
    
    @StateObject private var viewModel: AuthViewModel
    @EnvironmentObject var authRouter: AuthRouter

    init(container: DIContainer, onLoginSuccess: @escaping () -> Void, onGuestContinue: @escaping () -> Void) {
        self.onLoginSuccess = onLoginSuccess
        self.onGuestContinue = onGuestContinue
        _viewModel = StateObject(wrappedValue: container.makeAuthViewModel())
    }
    
    var body: some View {
        NavigationStack(path: $authRouter.path) {
            LoginView(viewModel: viewModel)
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
