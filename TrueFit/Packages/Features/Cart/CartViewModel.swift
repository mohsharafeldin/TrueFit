import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published var cartState: ViewState<Cart> = .idle
    @Published var isUpdating: Bool = false
    @Published var discountInput: String = ""
    
    private let getCartUseCase: GetCartUseCase
    private let addToCartUseCase: AddToCartUseCase
    private let updateCartLineUseCase: UpdateCartLineUseCase
    private let removeCartLineUseCase: RemoveCartLineUseCase
    private let applyDiscountUseCase: ApplyDiscountUseCase
    
    init(
        getCartUseCase: GetCartUseCase,
        addToCartUseCase: AddToCartUseCase,
        updateCartLineUseCase: UpdateCartLineUseCase,
        removeCartLineUseCase: RemoveCartLineUseCase,
        applyDiscountUseCase: ApplyDiscountUseCase
    ) {
        self.getCartUseCase = getCartUseCase
        self.addToCartUseCase = addToCartUseCase
        self.updateCartLineUseCase = updateCartLineUseCase
        self.removeCartLineUseCase = removeCartLineUseCase
        self.applyDiscountUseCase = applyDiscountUseCase
    }
    
    // MARK: - Actions
    
    func loadCart(id: String) async {
        cartState = .loading
        do {
            let cart = try await getCartUseCase.execute(cartId: id)
            cartState = .success(cart)
        } catch {

            cartState = .failure(error as? AppError ?? .unknown(error.localizedDescription))
        }
    }
    
    func retry(cartId: String) async {
        await loadCart(id: cartId)
    }
    
    func addToCart(cartId: String?, variantId: String, quantity: Int) async {
        isUpdating = true
        defer { isUpdating = false }
        
        do {
            let updatedCart = try await addToCartUseCase.execute(cartId: cartId, variantId: variantId, quantity: quantity)
            cartState = .success(updatedCart)
        } catch {

            // If we don't have a cart loaded yet, reflect failure
            if case .success = cartState {
                // Already loaded, just log error and maybe show alert in UI
            } else {
                cartState = .failure(error as? AppError ?? .unknown(error.localizedDescription))
            }
        }
    }
    
    func updateQuantity(cartId: String, lineId: String, quantity: Int) async {
        isUpdating = true
        defer { isUpdating = false }
        
        do {
            let updatedCart = try await updateCartLineUseCase.execute(cartId: cartId, lineId: lineId, quantity: quantity)
            cartState = .success(updatedCart)
        } catch {

        }
    }
    
    func removeLine(cartId: String, lineId: String) async {
        isUpdating = true
        defer { isUpdating = false }
        
        do {
            let updatedCart = try await removeCartLineUseCase.execute(cartId: cartId, lineId: lineId)
            cartState = .success(updatedCart)
        } catch {

        }
    }
    
    func applyDiscount(cartId: String) async {
        guard !discountInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isUpdating = true
        defer { isUpdating = false }
        
        do {
            let updatedCart = try await applyDiscountUseCase.execute(cartId: cartId, code: discountInput)
            cartState = .success(updatedCart)
            discountInput = "" // clear on success
        } catch {

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
