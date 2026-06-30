//
//  RootViewModel.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import Foundation
import SwiftUI
enum AppState {
    case splash
    case onboarding
    case unauthenticated
    case guest
    case authenticated
}

private extension String {
    static let hasSeenOnboarding = "hasSeenOnboarding"
}


@MainActor
class RootViewModel: ObservableObject {

    @Published var currentState: AppState = .splash

    private let authManager: AuthManager
    private let authRouter: AuthRouter
    private let appRouter: AppRouter
    private var preferencesManager: PreferencesManagerProtocol

    private let splashDuration: UInt64 = 500_000_000

    init(authManager: AuthManager,
         authRouter: AuthRouter,
         appRouter: AppRouter,
         preferencesManager: PreferencesManagerProtocol) {
        self.authManager = authManager
        self.authRouter  = authRouter
        self.appRouter   = appRouter
        self.preferencesManager = preferencesManager
        
        //Task { await initializeApp() }
    }


    private func initializeApp() async {
        try? await Task.sleep(nanoseconds: splashDuration)
        routeAfterSplash()
    }
    func splashDidFinish() {
            routeAfterSplash()
    }
    private func routeAfterSplash() {
        let hasSeenOnboarding = preferencesManager.hasSeenOnboarding
        guard hasSeenOnboarding else {
            currentState = .onboarding
            return
        }

        evaluateAuthState()
    }

    private func evaluateAuthState() {
        if authManager.isAuthenticated {
            currentState = .authenticated
        } else if authManager.isGuest {
            currentState = .guest
        } else {
            currentState = .unauthenticated
        }
    }


    func completeOnboarding() {
        preferencesManager.hasSeenOnboarding = true
        authRouter.popToRoot()
        evaluateAuthState()
    }

    func continueAsGuest() {
        authManager.setGuestMode(true)
        authRouter.popToRoot()
        currentState = .guest
    }

    func didAuthenticate() {
        authRouter.popToRoot()
        currentState = .authenticated
    }

    func didSignOut() {
        appRouter.popToRoot()
        currentState = .unauthenticated
    }
}
