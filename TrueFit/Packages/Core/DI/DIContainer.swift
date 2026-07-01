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
    
    let authRepository: AuthRepositoryProtocol = AuthRepository()
    
    // MARK: - Home Feature Dependencies
    private lazy var homeRemoteDataSource: HomeRemoteDataSourceProtocol = HomeRemoteDataSource(apiClient: restClient)
    private lazy var homeRepository: HomeRepositoryProtocol = HomeRepository(remoteDataSource: homeRemoteDataSource)
    private lazy var fetchNewArrivalsUseCase = FetchNewArrivalsUseCase(repository: homeRepository)
    private lazy var fetchCollectionsUseCase = FetchCollectionsUseCase(repository: homeRepository)
    
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
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            fetchNewArrivalsUseCase: fetchNewArrivalsUseCase,
            fetchCollectionsUseCase: fetchCollectionsUseCase
        )
    }
}
