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
    let genericClient: GenericHTTPClientProtocol = GenericHTTPClient()
    // let graphQLClient = GraphQLClient()
    let appRouter = AppRouter()
    let authRouter = AuthRouter()
    
    let authRepository: AuthRepositoryProtocol = AuthRepository()
    // MARK: - Product Dependencies
    lazy var productRemoteDataSource: ProductRemoteDataSourceProtocol = {
        ProductRemoteDataSource(apiClient: restClient)
    }()
    
    lazy var productRepository: ProductRepositoryProtocol = {
        ProductRepository(remoteDataSource: productRemoteDataSource)
    }()
    
    lazy var getProductUseCase: GetProductUseCase = {
        GetProductUseCase(repository: productRepository)
    }()
    
    // MARK: - Currency Dependencies
    lazy var currencyRemoteDataSource: CurrencyRemoteDataSourceProtocol = {
        CurrencyRemoteDataSource(apiClient: genericClient)
    }()
    
    lazy var currencyRepository: CurrencyRepositoryProtocol = {
        CurrencyRepository(remoteDataSource: currencyRemoteDataSource)
    }()
    
    lazy var getExchangeRatesUseCase: GetExchangeRatesUseCase = {
        GetExchangeRatesUseCase(repository: currencyRepository)
    }()
    
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
    
    func makeProductDetailsViewModel(productId: String) -> ProductDetailsViewModel {
        let viewModel = ProductDetailsViewModel(getProductUseCase: getProductUseCase)
        return viewModel
    }
    
    func makeCurrencyConverterViewModel() -> CurrencyConverterViewModel {
        return CurrencyConverterViewModel(getExchangeRatesUseCase: getExchangeRatesUseCase)
    }
}
