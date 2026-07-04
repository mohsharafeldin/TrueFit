//
//  DIContainer.swift
//  TrueFit
//
//  Created by Mona Zarea on 27/06/2026.
//

import Foundation
import CoreData

@MainActor
final class DIContainer: ObservableObject {
    
    // MARK: - Infrastructure
    let persistenceController = PersistenceController.shared
    let preferencesManager = PreferencesManager()
    let appRouter = AppRouter()
    let authRouter = AuthRouter()
    
    // MARK: - Core Services
    private lazy var keychainManager: KeychainManagerProtocol = KeychainManager()
    public lazy var authManager: AuthManager = AuthManager(keychainManager: keychainManager)
    
    // MARK: - Networking
    let genericClient: GenericHTTPClientProtocol = GenericHTTPClient()
    
    lazy var getProductUseCase: GetProductUseCase = {
        GetProductUseCase(repository: productsRepository)
    }()
    
    // MARK: - Currency Dependencies (from feature branch)
    lazy var currencyRemoteDataSource: CurrencyRemoteDataSourceProtocol = {
        CurrencyRemoteDataSource(apiClient: genericClient)
    }()
    
    lazy var currencyRepository: CurrencyRepositoryProtocol = {
        CurrencyRepository(remoteDataSource: currencyRemoteDataSource)
    }()
    
    lazy var getExchangeRatesUseCase: GetExchangeRatesUseCase = {
        GetExchangeRatesUseCase(repository: currencyRepository)
    }()
    
    // MARK: - Networking
    let restClient: APIClientProtocol = RESTClient()
    
    // MARK: - AUTH FEATURE
    
    // Auth Data Sources
    private lazy var firebaseAuthDataSource: FirebaseAuthDataSourceProtocol = FirebaseAuthDataSource()
    private lazy var shopifyAuthDataSource: ShopifyAuthDataSourceProtocol = ShopifyAuthDataSource()
    private lazy var googleSignInDataSource: GoogleSignInServiceProtocol = GoogleSignInDataSource()
    
    // Auth Repository
    private lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepository(
            firebaseDataSource: firebaseAuthDataSource,
            shopifyDataSource: shopifyAuthDataSource,
            keychainManager: keychainManager,
            googleSignInService: googleSignInDataSource
        )
    }()
    
    // Auth Use Cases
    private func makeLoginUseCase() -> LoginUseCaseProtocol {
        LoginUseCase(authRepository: authRepository)
    }
    
    private func makeSignUpUseCase() -> SignUpUseCaseProtocol {
        SignUpUseCase(authRepository: authRepository)
    }
    
    private func makeResetPasswordUseCase() -> ResetPasswordUseCaseProtocol {
        ResetPasswordUseCase(authRepository: authRepository)
    }
    
    private func makeLogoutUseCase() -> LogoutUseCaseProtocol {
        LogoutUseCase(authRepository: authRepository)
    }
    private func makeLoginWithGoogleUseCase() -> LoginWithGoogleUseCaseProtocol {         LoginWithGoogleUseCase(authRepository: authRepository)
    }
    
    
    // MARK: - HOME & PRODUCTS FEATURE
    
    // Products Data Sources & Repositories
    private lazy var productsRemoteDataSource: ProductsRemoteDataSourceProtocol = ProductsRemoteDataSource(apiClient: restClient)
    private lazy var productsRepository: ProductsRepositoryProtocol = ProductsRepository(remoteDataSource: productsRemoteDataSource)
    
    // Products Use Cases
    private lazy var fetchNewArrivalsUseCase = FetchNewArrivalsUseCase(repository: productsRepository)
    private lazy var fetchCollectionsUseCase = FetchCollectionsUseCase(repository: productsRepository)
    
    
    // MARK: - Init
    public init() {}
    
    
    // MARK: - VIEW MODELS FACTORY
    
    public func makeRootViewModel() -> RootViewModel {
        RootViewModel(
            authManager: authManager,
            authRouter: authRouter,
            appRouter: appRouter,
            preferencesManager: preferencesManager
        )
    }
    
    public func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            loginUseCase: makeLoginUseCase(),
            signUpUseCase: makeSignUpUseCase(),
            resetPasswordUseCase: makeResetPasswordUseCase(),
            logoutUseCase: makeLogoutUseCase(),
            authManager: authManager,
            authRouter: authRouter,
            loginWithGoogleUseCase: makeLoginWithGoogleUseCase()
        )
    }
    
    public func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchNewArrivalsUseCase: fetchNewArrivalsUseCase,
            fetchCollectionsUseCase: fetchCollectionsUseCase
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
