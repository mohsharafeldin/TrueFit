//
//  RootViewModel.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import Foundation
import SwiftUI
enum AppState{
    case splash
    case unauthenticated 
    case authenticated
}
@MainActor
class RootViewModel : ObservableObject{
    @Published var currentState : AppState = .splash
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        initializeApp()
    }
    
    
    private func initializeApp(){   
        
        Task{
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            if authManager.isAuthenticated {
                self.currentState = .authenticated
            } else {
                self.currentState = .unauthenticated
                        }
                
        }
    }
    
}
