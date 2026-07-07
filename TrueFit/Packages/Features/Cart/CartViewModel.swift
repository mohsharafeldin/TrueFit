import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published var cartState: ViewState<Cart> = .idle
    @Published var isUpdating: Bool = false
    @Published var discountInput: String = ""
    @Published var lastError: AppError?
    
    private let getCartUseCase: GetCartUseCase
    private let addToCartUseCase: AddToCartUseCase
    private let updateCartLineUseCase: UpdateCartLineUseCase
    private let removeCartLineUseCase: RemoveCartLineUseCase
    private let applyDiscountUseCase: ApplyDiscountUseCase
    private let cartStateModel: CartState
    private var preferencesManager: PreferencesManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getCartUseCase: GetCartUseCase,
        addToCartUseCase: AddToCartUseCase,
        updateCartLineUseCase: UpdateCartLineUseCase,
        removeCartLineUseCase: RemoveCartLineUseCase,
        applyDiscountUseCase: ApplyDiscountUseCase,
        cartState: CartState,
        preferencesManager: PreferencesManagerProtocol
    ) {
        self.getCartUseCase = getCartUseCase
        self.addToCartUseCase = addToCartUseCase
        self.updateCartLineUseCase = updateCartLineUseCase
        self.removeCartLineUseCase = removeCartLineUseCase
        self.applyDiscountUseCase = applyDiscountUseCase
        self.cartStateModel = cartState
        self.preferencesManager = preferencesManager
        
        CurrencyManager.shared.$selectedCurrency
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    func loadCart(silent: Bool = false) async {
        let id = preferencesManager.cartId ?? ""
        if id.isEmpty {
            let emptyCart = Cart(
                id: "",
                lines: [],
                totalQuantity: 0,
                subtotal: Money(amount: 0, currencyCode: "USD"),
                total: Money(amount: 0, currencyCode: "USD"),
                totalTax: nil,
                discountCodes: [],
                checkoutURL: nil
            )
            cartState = .success(emptyCart)
            return
        }
        
        if !silent {
            cartState = .loading
        }
        do {
            let cart = try await getCartUseCase.execute(cartId: id)
            cartState = .success(cart)
            cartStateModel.updateCount(cart.totalQuantity)
        } catch {
            if !silent {
                cartState = .failure(error as? AppError ?? .unknown(error.localizedDescription))
            }
        }
    }
    
    func retry() async {
        await loadCart()
    }
    
    func addToCart(variantId: String, quantity: Int) async {
        isUpdating = true
        defer { isUpdating = false }
        
        let cartId = preferencesManager.cartId
        do {
            let updatedCart = try await addToCartUseCase.execute(cartId: cartId, variantId: variantId, quantity: quantity)
            preferencesManager.cartId = updatedCart.id
            cartState = .success(updatedCart)
            cartStateModel.updateCount(updatedCart.totalQuantity)
        } catch {

            // If we don't have a cart loaded yet, reflect failure
            if case .success = cartState {
                // Already loaded, just log error and maybe show alert in UI
            } else {
                cartState = .failure(error as? AppError ?? .unknown(error.localizedDescription))
            }
        }
    }
    
    func updateQuantity(lineId: String, quantity: Int) async {
        isUpdating = true
        defer { isUpdating = false }
        
        guard let cartId = preferencesManager.cartId else { return }
        do {
            let updatedCart = try await updateCartLineUseCase.execute(cartId: cartId, lineId: lineId, quantity: quantity)
            cartState = .success(updatedCart)
            cartStateModel.updateCount(updatedCart.totalQuantity)
        } catch {
            lastError = error as? AppError ?? .unknown(error.localizedDescription)
        }
    }
    
    func removeLine(lineId: String) async {
        isUpdating = true
        defer { isUpdating = false }
        
        guard let cartId = preferencesManager.cartId else { return }
        do {
            let updatedCart = try await removeCartLineUseCase.execute(cartId: cartId, lineId: lineId)
            cartState = .success(updatedCart)
            cartStateModel.updateCount(updatedCart.totalQuantity)
        } catch {
            lastError = error as? AppError ?? .unknown(error.localizedDescription)
        }
    }
    
    func applyDiscount() async {
        guard !discountInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isUpdating = true
        defer { isUpdating = false }
        
        guard let cartId = preferencesManager.cartId else { return }
        do {
            let updatedCart = try await applyDiscountUseCase.execute(cartId: cartId, code: discountInput)
            cartState = .success(updatedCart)
            discountInput = "" // clear on success
        } catch {
            lastError = error as? AppError ?? .unknown(error.localizedDescription)
        }
    }
    
    // MARK: - Computed Properties for UI
    
    var lineCount: Int {
        guard case .success(let cart) = cartState else { return 0 }
        return cart.totalQuantity
    }
    
    var subtotalText: String {
        guard case .success(let cart) = cartState else { return "" }
        return cart.subtotal.formatted
    }
    
    var totalText: String {
        guard case .success(let cart) = cartState else { return "" }
        return cart.total.formatted
    }
    
    var totalTaxText: String? {
        guard case .success(let cart) = cartState else { return nil }
        return cart.totalTax?.formatted
    }
    
    var hasActiveDiscount: Bool {
        guard case .success(let cart) = cartState else { return false }
        return cart.hasDiscount
    }
    
    var checkoutURL: URL? {
        guard case .success(let cart) = cartState else { return nil }
        return cart.checkoutURL
    }
}
