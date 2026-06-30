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
    
    // MARK: - Networking
    let restClient: APIClientProtocol = RESTClient()
    // let graphQLClient = GraphQLClient()
    let appRouter = AppRouter()
    let authRouter = AuthRouter()
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
    
}
