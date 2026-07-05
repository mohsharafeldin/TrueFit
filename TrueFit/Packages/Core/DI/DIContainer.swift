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
    let cartState = CartState()
    
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
    
    private lazy var apolloManager: ApolloManager = {
            ApolloManager(authManager: authManager)
        }()
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
    
    
    // MARK: - CART FEATURE
    
    // GraphQL & Cart Data Sources
    // TODO: Add SQLiteNormalizedCache to ApolloManager when offline support is needed
    private lazy var cartRemoteDataSource: CartRemoteDataSourceProtocol = CartRemoteDataSource(apollo: apolloManager)
    private lazy var cartRepository: CartRepositoryProtocol = CartRepository(remoteDataSource: cartRemoteDataSource)
    
    // Cart Use Cases
    private lazy var getCartUseCase = GetCartUseCase(repository: cartRepository)
    private lazy var addToCartUseCase = AddToCartUseCase(repository: cartRepository)
    private lazy var updateCartLineUseCase = UpdateCartLineUseCase(repository: cartRepository)
    private lazy var removeCartLineUseCase = RemoveCartLineUseCase(repository: cartRepository)
    private lazy var applyDiscountUseCase = ApplyDiscountUseCase(repository: cartRepository)
    
    // MARK: - FAVORITES FEATURE
    
    // Favorites Data Sources & Repository
    private lazy var favoritesLocalDataSource: FavoritesLocalDataSourceProtocol = {
        FavoritesLocalDataSource(persistenceController: persistenceController)
    }()
    
    private lazy var favoritesRepository: FavoritesRepositoryProtocol = {
        FavoritesRepository(localDataSource: favoritesLocalDataSource)
    }()
    
    // Favorites Use Cases
    private lazy var getFavoritesUseCase = GetFavoritesUseCase(repository: favoritesRepository)
    private lazy var toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: favoritesRepository)
    lazy var isFavoriteUseCase = IsFavoriteUseCase(repository: favoritesRepository)
    
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
            fetchCollectionsUseCase: fetchCollectionsUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase
        )
    }

    func makeProductDetailsViewModel(productId: String) -> ProductDetailsViewModel {
        let viewModel = ProductDetailsViewModel(
            getProductUseCase: getProductUseCase,
            addToCartUseCase: addToCartUseCase,
            preferencesManager: preferencesManager,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            cartState: cartState
        )
        return viewModel
    }
    
    func makeCurrencyConverterViewModel() -> CurrencyConverterViewModel {
        return CurrencyConverterViewModel(getExchangeRatesUseCase: getExchangeRatesUseCase)
    }
    
    public func makeCartViewModel() -> CartViewModel {
        CartViewModel(
            getCartUseCase: getCartUseCase,
            addToCartUseCase: addToCartUseCase,
            updateCartLineUseCase: updateCartLineUseCase,
            removeCartLineUseCase: removeCartLineUseCase,
            applyDiscountUseCase: applyDiscountUseCase,
            cartState: cartState
        )
    }
    
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            authManager: authManager
        )
    }
}
