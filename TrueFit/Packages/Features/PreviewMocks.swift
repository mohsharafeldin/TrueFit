//
//  PreviewMocks.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 30/06/2026.
//

import Foundation
import SwiftUI

// MARK: - Mock Repository

class MockAuthRepository: AuthRepositoryProtocol {
     func loginWithGoogle() async throws -> AuthResult {
        return AuthResult(user: User(id: "mock-id", email: "email", firstName: "Mock", lastName: "User", shopifyCustomerId: "mock-shopify-id"))
    }
    func login(email: String, password: String) async throws -> AuthResult {
        return AuthResult(user: User(id: "mock-id", email: email, firstName: "Mock", lastName: "User", shopifyCustomerId: "mock-shopify-id"))
    }
    func signUp(firstName: String, lastName: String, email: String, password: String) async throws -> AuthResult {
        return AuthResult(user: User(id: "mock-id", email: email, firstName: firstName, lastName: lastName, shopifyCustomerId: "mock-shopify-id"))
    }
    
    func resetPassword(email: String) async throws {}
    
    func signOut() async throws {}
}

// MARK: - Mock Use Cases

class MockLoginUseCase: LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> AuthResult {
        return AuthResult(user: User(id: "mock", email: email, firstName: "Mock", lastName: "User", shopifyCustomerId: ""))
    }
}

class MockSignUpUseCase: SignUpUseCaseProtocol {
    func execute(firstName: String, lastName: String, email: String, password: String) async throws -> AuthResult {
        return AuthResult(user: User(id: "mock", email: email, firstName: firstName, lastName: lastName, shopifyCustomerId: ""))
    }
}

class MockResetPasswordUseCase: ResetPasswordUseCaseProtocol {
    func execute(email: String) async throws {}
}

class MockLogoutUseCase: LogoutUseCaseProtocol {
    func execute() async throws {}
}

class MockLoginWithGoogleUseCase: LoginWithGoogleUseCaseProtocol {
    func execute() async throws -> AuthResult {
        return AuthResult(user: User(id: "mock-id", email: "email", firstName: "Mock", lastName: "User", shopifyCustomerId: "mock-shopify-id"))
    }
}


// MARK: - Mock Manager

@MainActor
class MockAuthManager: AuthManagerProtocol {
    func markAuthenticated() {
        
    }
    
    var isAuthenticated = false
    var isGuest = false
    var mockToken: String? = nil
    
    init(hasToken: Bool = false) {
        if hasToken {
            self.mockToken = "dummy_preview_token"
            self.isAuthenticated = true
        }
    }
    
    func login(token: String) {}
    func logout() {}
    func setGuestMode(_ isGuest: Bool) {}
    func getAccessToken() -> String? { return mockToken }
}

// MARK: - Preview ViewModel Creator
@MainActor
struct PreviewMocks {
    static func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(
            loginUseCase: MockLoginUseCase(),
            signUpUseCase: MockSignUpUseCase(),
            resetPasswordUseCase: MockResetPasswordUseCase(),
            logoutUseCase: MockLogoutUseCase(),
            authManager: MockAuthManager(),
            authRouter: AuthRouter(),
            loginWithGoogleUseCase: MockLoginWithGoogleUseCase()
        )
    }
}


// MARK: - Mock Favorites Repository

class MockFavoritesRepository: FavoritesRepositoryProtocol {
    var mockFavorites: [FavoriteItem] = [
        FavoriteItem(
            id: "mock-1",
            title: "Nike Air Force 1",
            price: 120.0,
            vendor: "Nike",
            imageURL: URL(string: "https://via.placeholder.com/150"),
            addedAt: Date()
        ),
        FavoriteItem(
            id: "mock-2",
            title: "Adidas Ultraboost Light",
            price: 190.0,
            vendor: "Adidas",
            imageURL: URL(string: "https://via.placeholder.com/150"),
            addedAt: Date().addingTimeInterval(-86400)
        ),
        FavoriteItem(
            id: "mock-3",
            title: "Classic Denim Jacket",
            price: 85.50,
            vendor: "Levi's",
            imageURL: nil,
            addedAt: Date().addingTimeInterval(-172800)
        )
    ]
    
    func getAllFavorites() async throws -> [FavoriteItem] {
        return mockFavorites
    }
    
    func addFavorite(_ item: FavoriteItem) async throws {
        mockFavorites.append(item)
    }
    
    func removeFavorite(productId: String) async throws {
        mockFavorites.removeAll { $0.id == productId }
    }
    
    func isFavorite(productId: String) async throws -> Bool {
        return mockFavorites.contains { $0.id == productId }
    }
}

// MARK: - Mock Products Repository

class MockProductsRepository: ProductsRepositoryProtocol {
    func fetchNewArrivals(limit: Int) async throws -> [Product] { return [] }
    func fetchCollections() async throws -> [ProductCollection] { return [] }
    func getProduct(id: String) async throws -> Product {
        return Product(
            id: id,
            title: "Mock Product",
            description: "Mock Description",
            vendor: "Mock",
            productType: "Shoes",
            handle: "mock-product",
            status: .active,
            tags: ["Mock"],
            variants: [
                ProductVariant(
                    id: "gid://shopify/ProductVariant/mock",
                    title: "Default Title",
                    price: 100.0,
                    compareAtPrice: nil,
                    sku: "MOCK-01",
                    isAvailable: true,
                    requiresShipping: true,
                    weight: nil,
                    weightUnit: nil,
                    inventoryQuantity: 10,
                    imageId: nil,
                    selectedOptions: [:]
                )
            ],
            images: [],
            options: [],
            mainImage: nil,
            isAvailable: true,
            priceRange: PriceRange(min: 100.0, max: 100.0, isSinglePrice: true),
            hasMultipleVariants: false,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    func fetchBrands() async throws -> [Brand] { return [] }
    func fetchProductsByCollection(collectionId: Int64) async throws -> [Product] { return [] }
    func fetchProductsByVendor(vendor: String) async throws -> [Product] { return [] }
    func fetchAllProducts() async throws -> [Product] { return [] }
}

// MARK: - Preview ViewModel Creator Extension

extension PreviewMocks {
    
    @MainActor
    static func makeFavoritesViewModel(isEmpty: Bool = false) -> FavoritesViewModel {
        let mockRepo = MockFavoritesRepository()
        
        if isEmpty {
            mockRepo.mockFavorites = []
        }
        
        let getFavoritesUseCase = GetFavoritesUseCase(repository: mockRepo)
        let toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: mockRepo)
        let mockCartRepo = MockCartRepository()
        let mockProductRepo = MockProductsRepository()
        
        return FavoritesViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            authManager: MockAuthManager(),
            addToCartUseCase: AddToCartUseCase(repository: mockCartRepo),
            getProductUseCase: GetProductUseCase(repository: mockProductRepo),
            preferencesManager: MockPreferencesManager(),
            cartState: CartState()
        )
    }
}

// MARK: - Mock Orders Repository

class MockOrdersRepository: OrdersRepositoryProtocol {
    func fetchOrders() async throws -> [Order] {
        return OrderPreviewData.mockOrders
    }
    
    func fetchOrderDetails(orderId: String) async throws -> OrderDetails {
        return OrderPreviewData.mockOrderDetails
    }
}

// MARK: - Orders Preview ViewModel Creator Extension

extension PreviewMocks {
    @MainActor
    static func makeOrderHistoryViewModel() -> OrderHistoryViewModel {
        let mockRepo = MockOrdersRepository()
        let fetchOrdersUseCase = FetchOrdersUseCase(repository: mockRepo)
        
        let viewModel = OrderHistoryViewModel(
            fetchOrdersUseCase: fetchOrdersUseCase,
            authManager: MockAuthManager(hasToken: true)
        )
        
        viewModel.orders = OrderPreviewData.mockOrders
        viewModel.isLoading = false
        
        return viewModel
    }
    
    @MainActor
    static func makeOrderDetailsViewModel(orderId: String) -> OrderDetailsViewModel {
        let mockRepo = MockOrdersRepository()
        let fetchOrderDetailsUseCase = FetchOrderDetailsUseCase(repository: mockRepo)
        let viewModel = OrderDetailsViewModel(fetchOrderDetailsUseCase: fetchOrderDetailsUseCase, orderId: orderId)
        
        viewModel.orderDetails = OrderPreviewData.mockOrderDetails
        viewModel.isLoading = false
        
        return viewModel
    }
}

// MARK: - Mock Address Repository

class MockAddressRepository: AddressRepositoryProtocol {
    func createAddress(customerAccessToken: String, address1: String, country: String, province: String, city: String, zip: String) async throws -> Address {
        return Address(id: UUID().uuidString, address1: address1, country: country, province: province, city: city, zip: zip)
    }
    
    func deleteAddress(customerAccessToken: String, addressId: String) async throws -> String {
        return addressId
    }
    
    func updateAddress(customerAccessToken: String, addressId: String, address1: String, country: String, province: String, city: String, zip: String) async throws -> Address {
        return Address(id: addressId, address1: address1, country: country, province: province, city: city, zip: zip)
    }
    
    func getAddresses(customerAccessToken: String) async throws -> [Address] {
        return [
            Address(id: "1", address1: "123 Main St", country: "USA", province: "NY", city: "New York", zip: "10001"),
            Address(id: "2", address1: "456 Elm St", country: "USA", province: "CA", city: "Los Angeles", zip: "90001")
        ]
    }
}

extension PreviewMocks {
    @MainActor
    static func makeAddressViewModel() -> AddressViewModel {
        let repo = MockAddressRepository()
        return AddressViewModel(
            authManager: MockAuthManager(),
            getAddresses: GetAddressesUseCase(repository: repo),
            createAddress: CreateAddressUseCase(repository: repo),
            updateAddress: UpdateAddressUseCase(repository: repo),
            deleteAddress: DeleteAddressUseCase(repository: repo)
        )
    }
}

// MARK: - Mock Cart Repository & Preferences

class MockCartRepository: CartRepositoryProtocol {
    private var emptyCart: Cart {
        Cart(id: "mock-cart", lines: [], totalQuantity: 0, subtotal: Money(amount: 0, currencyCode: "USD"), total: Money(amount: 0, currencyCode: "USD"), totalTax: nil, discountCodes: [], checkoutURL: nil)
    }
    func getCart(id: String) async throws -> Cart { return emptyCart }
    func createCart(variantId: String, quantity: Int) async throws -> Cart { return emptyCart }
    func addToCart(cartId: String, variantId: String, quantity: Int) async throws -> Cart { return emptyCart }
    func updateQuantity(cartId: String, lineId: String, quantity: Int) async throws -> Cart { return emptyCart }
    func removeLine(cartId: String, lineId: String) async throws -> Cart { return emptyCart }
    func applyDiscount(cartId: String, code: String) async throws -> Cart { return emptyCart }
}

class MockPreferencesManager: PreferencesManagerProtocol {
    var hasSeenOnboarding: Bool = true
    var hasRunBefore: Bool = true
    var cartId: String? = "mock-cart-id"
    var cartItemCount: Int = 3
    
    func saveUser(_ user: User) {}
    func getUser() -> User? { return nil }
    func clearUser() {}
}

// MARK: - Mock Payment Repository

class MockPaymentRepository: PaymentRepositoryProtocol {
    /// Override this in specific previews to simulate different outcomes.
    var mockResult: PaymentResult = .success

    func processPayment(request: PaymentRequestDTO) async throws -> PaymentResult {
        // Simulate a short network delay so the processing state is visible.
        try await Task.sleep(nanoseconds: 800_000_000)
        return mockResult
    }
}

// MARK: - Payment Preview ViewModel Creator Extension

extension PreviewMocks {
    @MainActor
    static func makePaymentViewModel(
        simulatedResult: PaymentResult = .success
    ) -> PaymentViewModel {
        let paymentRepo = MockPaymentRepository()
        paymentRepo.mockResult = simulatedResult
        let cartRepo = MockCartRepository()
        let prefs = MockPreferencesManager()

        return PaymentViewModel(
            processPaymentUseCase: ProcessPaymentUseCase(repository: paymentRepo),
            getCartUseCase: GetCartUseCase(repository: cartRepo),
            removeCartLineUseCase: RemoveCartLineUseCase(repository: cartRepo),
            preferencesManager: prefs,
            cartStateModel: CartState(),
            orderTotal: 100.0,
            orderLabel: "Preview Order"
        )
    }
}

// MARK: - Mock AI Chat Repository

class MockAIChatRepository: AIChatRepositoryProtocol {
    var mockResponse: String = "Great choice! 🔥 Here are some options from our TrueFit catalog:\n\n1. **Nike Air Force 1** by Nike — $120\n2. **Adidas Ultraboost** by Adidas — $190\n\nWould you like more details on any of these?"
    
    func sendMessage(_ text: String, history: [ChatBootMessage], systemContext: String) async throws -> String {
        // Simulate network delay for realistic preview behavior
        try await Task.sleep(nanoseconds: 500_000_000)
        return mockResponse
    }
}



// MARK: - AI Chat Preview ViewModel Creator Extension

extension PreviewMocks {
    @MainActor
    static func makeAIChatViewModel(withMessages: Bool = false) -> AIChatViewModel {
        let mockChatRepo = MockAIChatRepository()
        let mockProductsRepo = MockProductsRepository()
        
        let sendUseCase = SendChatMessageUseCase(repository: mockChatRepo)
        let buildContextUseCase = BuildProductContextUseCase(productsRepository: mockProductsRepo)
        
        var mockMessages: [ChatBootMessage] = []
        
        if withMessages {
            mockMessages = [
                ChatBootMessage(text: "White sneakers under $50 👟", isUser: true),
                ChatBootMessage(text: "I found some amazing options for you! 🔥\n\n1. Classic White Canvas - $35\n2. Sport Runner White - $45\n\nWould you like me to open any of them?", isUser: false),
                ChatBootMessage(text: "Yes, show me the first one please.", isUser: true)
            ]
        }
        
        return AIChatViewModel(
            sendChatMessageUseCase: sendUseCase,
            buildProductContextUseCase: buildContextUseCase,
            mockMessages: mockMessages
        )
    }
}
