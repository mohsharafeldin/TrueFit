//
//  RootView.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewModel: RootViewModel
    
    @EnvironmentObject var container: DIContainer

    var body: some View {
        Group {
            switch viewModel.currentState {
            case .splash:
                SplashView(onSplashComplete: viewModel.splashDidFinish)
                
            case .unauthenticated:
                AuthFlowView(
                    container: container
                    
                )
                
            case .authenticated, .guest:
                MainAppView()
                
            case .onboarding:
                OnboardingContentView(
                    onComplete: {
                        viewModel.completeOnboarding()
                    }
                )
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.currentState)
    }
}
