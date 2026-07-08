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
    lazy var cartState: CartState = {
        CartState(initialCount: preferencesManager.cartItemCount) { [weak self] newCount in
            self?.preferencesManager.cartItemCount = newCount
        }
    }()
    
    // MARK: - Core Services
    private lazy var keychainManager: KeychainManagerProtocol = KeychainManager()
    public lazy var authManager: AuthManager = AuthManager(keychainManager: keychainManager, preferencesManager: preferencesManager)
    
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
            googleSignInService: googleSignInDataSource,
            preferencesManager: preferencesManager
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
    private func makeLoginWithGoogleUseCase() -> LoginWithGoogleUseCaseProtocol { LoginWithGoogleUseCase(authRepository: authRepository)
    }
    
    private func makeSendEmailVerificationUseCase() -> SendEmailVerificationUseCaseProtocol {
        SendEmailVerificationUseCase(authRepository: authRepository)
    }
    
    
    // MARK: - HOME & PRODUCTS FEATURE
    
    // Products Data Sources & Repositories
    private lazy var productsRemoteDataSource: ProductsRemoteDataSourceProtocol = ProductsRemoteDataSource(apiClient: restClient)
    private lazy var productsRepository: ProductsRepositoryProtocol = ProductsRepository(remoteDataSource: productsRemoteDataSource)
    
    // Products Use Cases
    private lazy var fetchNewArrivalsUseCase = FetchNewArrivalsUseCase(repository: productsRepository)
    private lazy var fetchCollectionsUseCase = FetchCollectionsUseCase(repository: productsRepository)
    private lazy var fetchBrandsUseCase = FetchBrandsUseCase(repository: productsRepository)
    private lazy var fetchProductsByCollectionUseCase = FetchProductsByCollectionUseCase(repository: productsRepository)
    private lazy var fetchProductsByVendorUseCase = FetchProductsByVendorUseCase(repository: productsRepository)
    private lazy var fetchAllProductsUseCase = FetchAllProductsUseCase(repository: productsRepository)
    
    
    // MARK: - CART FEATURE
    
    // GraphQL & Cart Data Sources
    // TODO: Add SQLiteNormalizedCache to ApolloManager when offline support is needed
    private lazy var cartRemoteDataSource: CartRemoteDataSourceProtocol = CartRemoteDataSource(apollo: apolloManager)
    private lazy var cartRepository: CartRepositoryProtocol = CartRepository(remoteDataSource: cartRemoteDataSource, productsRepository: productsRepository)
    
    // Cart Use Cases
    private lazy var getCartUseCase = GetCartUseCase(repository: cartRepository)
    private lazy var addToCartUseCase = AddToCartUseCase(repository: cartRepository)
    private lazy var updateCartLineUseCase = UpdateCartLineUseCase(repository: cartRepository)
    private lazy var removeCartLineUseCase = RemoveCartLineUseCase(repository: cartRepository)
    private lazy var applyDiscountUseCase = ApplyDiscountUseCase(repository: cartRepository)
    //private lazy var clearCartUseCase = ClearCartUseCase(repository: cartRepository)
    
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
    
    // MARK: - ORDERS FEATURE
    
    // Orders Data Sources & Repository
    private lazy var ordersRemoteDataSource: OrdersRemoteDataSourceProtocol = {
        OrdersRemoteDataSource(apollo: apolloManager)
    }()
    
    private lazy var ordersRepository: OrdersRepositoryProtocol = {
        OrdersRepository(remoteDataSource: ordersRemoteDataSource, authManager: authManager, productsRepository: productsRepository)
    }()
    
    // Orders Use Cases
    private lazy var fetchOrdersUseCase = FetchOrdersUseCase(repository: ordersRepository)
    private lazy var fetchOrderDetailsUseCase = FetchOrderDetailsUseCase(repository: ordersRepository)
    
    // MARK: - ADDRESS FEATURE
        
        // Address Data Source & Repository
        private lazy var addressRemoteDataSource: AddressRemoteDataSourceProtocol = {
            AddressRemoteDataSource(apollo: apolloManager)
        }()
        
        private lazy var addressRepository: AddressRepositoryProtocol = {
            AddressRepository(remoteDataSource: addressRemoteDataSource)
        }()
        
        // Address Use Cases
        private lazy var getAddressesUseCase = GetAddressesUseCase(repository: addressRepository)
        private lazy var createAddressUseCase = CreateAddressUseCase(repository: addressRepository)
        private lazy var updateAddressUseCase = UpdateAddressUseCase(repository: addressRepository)
        private lazy var deleteAddressUseCase = DeleteAddressUseCase(repository: addressRepository)

    // MARK: - PAYMENT FEATURE

    // Payment Data Source & Repository
    
    private lazy var paymentGatWay: PaymentGatewayProtocol=StubPaymentGateway()
    
    private lazy var paymentLocalDataSource: PaymentLocalDataSourceProtocol = {
        PaymentLocalDataSource(gateway: paymentGatWay)
    }()

    private lazy var paymentRepository: PaymentRepositoryProtocol = {
        PaymentRepository(dataSource: paymentLocalDataSource)
    }()

    // Payment Use Cases
    private lazy var processPaymentUseCase = ProcessPaymentUseCase(repository: paymentRepository)
    
    // MARK: - Init
    public init() {}
    
    // MARK: - App Launch Operations
    public func fetchInitialCartCount() async {
        guard let cartId = preferencesManager.cartId, !cartId.isEmpty else { return }
        do {
            let cart = try await getCartUseCase.execute(cartId: cartId)
            cartState.updateCount(cart.totalQuantity)
        } catch {
            print("Failed to fetch initial cart count: \(error)")
        }
    }
    

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
            loginWithGoogleUseCase: makeLoginWithGoogleUseCase(),
            sendEmailVerificationUseCase: makeSendEmailVerificationUseCase()
        )
    }
    
    public func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchNewArrivalsUseCase: fetchNewArrivalsUseCase,
            fetchCollectionsUseCase: fetchCollectionsUseCase,
            fetchBrandsUseCase: fetchBrandsUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase, 
            preferencesManager: preferencesManager
        )
    }

    public func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(
            fetchAllProductsUseCase: fetchAllProductsUseCase,
            fetchBrandsUseCase: fetchBrandsUseCase,
            fetchCollectionsUseCase: fetchCollectionsUseCase,
            fetchProductsByCollectionUseCase: fetchProductsByCollectionUseCase
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
            cartState: cartState,
            preferencesManager: preferencesManager
        )
    }
    
    public func makeCheckoutViewModel() -> CheckoutViewModel {
        CheckoutViewModel(
            getCartUseCase: getCartUseCase,
            getAddressesUseCase: getAddressesUseCase,
            authManager: authManager,
            preferencesManager: preferencesManager
        )
    }
    
    func makeProductListViewModel(source: ProductListSource) -> ProductListViewModel {
        ProductListViewModel(
            source: source,
            fetchProductsByCollectionUseCase: fetchProductsByCollectionUseCase,
            fetchProductsByVendorUseCase: fetchProductsByVendorUseCase
        )
    }
    
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            authManager: authManager
        )
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            preferencesManager: preferencesManager,
            authManager: authManager,
            logoutUseCase: makeLogoutUseCase()
        )
	}

    public func makeOrderHistoryViewModel() -> OrderHistoryViewModel {
        OrderHistoryViewModel(fetchOrdersUseCase: fetchOrdersUseCase, authManager: authManager)
    }
    
    public func makeOrderDetailsViewModel(orderId: String) -> OrderDetailsViewModel {
        OrderDetailsViewModel(fetchOrderDetailsUseCase: fetchOrderDetailsUseCase, orderId: orderId)
    }

    lazy var addressViewModel: AddressViewModel = {
        AddressViewModel(
            authManager: authManager,
            getAddresses: getAddressesUseCase,
            createAddress: createAddressUseCase,
            updateAddress: updateAddressUseCase,
            deleteAddress: deleteAddressUseCase
        )
    }()

    func makePaymentViewModel(orderTotal: Decimal, orderLabel: String = "TrueFit Order") -> PaymentViewModel {
        PaymentViewModel(
            processPaymentUseCase: processPaymentUseCase,
            getCartUseCase: getCartUseCase,
            removeCartLineUseCase: removeCartLineUseCase,
            preferencesManager: preferencesManager,
            cartStateModel: cartState,
            orderTotal: orderTotal,
            orderLabel: orderLabel
        )
    }
    
    
}
