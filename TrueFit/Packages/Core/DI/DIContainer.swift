//
//  ContainerProtocol.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//


import Foundation
import CoreData


@MainActor
final class DIContainer: ObservableObject {
    
    
    let persistenceController = PersistenceController.shared
    let authManager = AuthManager()
    let preferencesManager = PreferencesManager()
    
    let appRouter = AppRouter()
    let authRouter = AuthRouter()
    
    let authRepository: AuthRepositoryProtocol = AuthRepository()
    
    init() {
       
        
    }
    
    
    func makeRootViewModel() -> RootViewModel {
        return RootViewModel(
            authManager: authManager,
            authRouter: authRouter,
            appRouter: appRouter,  
            preferencesManager: preferencesManager
        )
    }
    
    func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(
            authRepository: authRepository,
            authManager: authManager,
            authRouter: authRouter
        )
    }
}
