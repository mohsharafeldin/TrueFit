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
    @EnvironmentObject var authRouter: AuthRouter
    
    var body: some View {
        NavigationStack(path: $authRouter.path) {
            Text("SignIn View Placeholder")
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .signIn:
                        Text("Signin Screen")
                    case .signUp:
                        Text("Sign Up Screen")
                        
                    }
                }
        }
    }
}
