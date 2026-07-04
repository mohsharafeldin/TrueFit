import Foundation
import Combine

enum StockStatus {
    case inStock(quantity: Int)
    case available
    case outOfStock
    case unavailable
}

@MainActor
final class ProductDetailsViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let getProductUseCase: GetProductUseCase
    private let addToCartUseCase: AddToCartUseCase
    private var preferencesManager: PreferencesManagerProtocol
    private let cartState: CartState
    
    // MARK: - Published Properties
    @Published var state: ViewState<Product> = .idle
    @Published var selectedVariant: ProductVariant?
    @Published var quantity: Int = 1
    @Published var selectedOptions: [String: String] = [:]
    @Published var isAddingToCart: Bool = false
    @Published var addToCartError: AppError? = nil
    @Published var toastMessage: String? = nil
    @Published var toastStyle: ToastStyle = .success
    
    init(getProductUseCase: GetProductUseCase,
         addToCartUseCase: AddToCartUseCase,
         preferencesManager: PreferencesManagerProtocol,
         cartState: CartState) {
        self.getProductUseCase = getProductUseCase
        self.addToCartUseCase = addToCartUseCase
        self.preferencesManager = preferencesManager
        self.cartState = cartState
    }
    
    func setupInitialSelection(for product: Product) {
        if let firstVariant = product.variants.first(where: { $0.isAvailable }) ?? product.variants.first {
            self.selectedVariant = firstVariant
            self.selectedOptions = firstVariant.selectedOptions
        }
    }
    
    func loadProduct(id: String) async {
        state = .loading
        do {
            let product = try await getProductUseCase.execute(productId: id)
            self.selectedVariant = product.variants.first(where: { $0.isAvailable }) ?? product.variants.first
            self.state = .success(product)
        } catch let appError as AppError {
            ErrorLogger.log(appError, context: "ProductDetailsViewModel.loadProduct")
            self.state = .failure(appError)
        } catch {
            let unknownError = AppError.unknown(error.localizedDescription)
            ErrorLogger.log(unknownError, context: "ProductDetailsViewModel.loadProduct")
            self.state = .failure(unknownError)
        }
    }
    
    func retry(id: String) async {
        await loadProduct(id: id)
    }
    

    func selectOption(name: String, value: String) {
        selectedOptions[name] = value
        guard case .success(let product) = state else { return }
        
        self.selectedVariant = product.variants.first { variant in
            return selectedOptions.allSatisfy { key, val in
                variant.selectedOptions[key] == val
            }
        }
    }
    
    func addToCart() async {
        guard let variant = selectedVariant else { return }
        
        isAddingToCart = true
        defer { isAddingToCart = false }
        
        let globalVariantId = variant.id.hasPrefix("gid://") ? variant.id : "gid://shopify/ProductVariant/\(variant.id)"
        
        do {
            let cart = try await addToCartUseCase.execute(cartId: preferencesManager.cartId, variantId: globalVariantId, quantity: quantity)
            preferencesManager.cartId = cart.id
            cartState.updateCount(cart.totalQuantity)
            toastMessage = "Product added to cart successfully"
            toastStyle = .success
        } catch {
            let appError = error as? AppError ?? .unknown(error.localizedDescription)
            ErrorLogger.log(appError, context: "ProductDetailsViewModel.addToCart")
            addToCartError = appError
            toastMessage = appError.userMessage
            toastStyle = .error
        }
    }
    
    func increaseQuantity() {
        if case .inStock(let maxQty) = stockStatus {
            if quantity < maxQty {
                quantity += 1
            }
        } else {
            quantity += 1
        }
    }
        
    func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    var maxQuantity: Int? {
        if case .inStock(let maxQty) = stockStatus {
            return maxQty
        }
        return nil
    }
    
    var displayedPrice: String {
        guard case .success(let product) = state else { return "" }
        
        if let selectedVariant = selectedVariant {
            return PriceFormatter.format(selectedVariant.price)
        }
        
        if product.priceRange.isSinglePrice {
            return PriceFormatter.format(product.priceRange.min)
        }
        
        let minString = PriceFormatter.format(product.priceRange.min)
        let maxString = PriceFormatter.format(product.priceRange.max)
        return "\(minString) - \(maxString)"
    }
    
    var displayedCompareAtPrice: String? {
        guard case .success = state,
            let selectedVariant = selectedVariant,
            let compareAtPrice = selectedVariant.compareAtPrice,
            compareAtPrice > selectedVariant.price else {
            return nil
        }
        
        return PriceFormatter.format(compareAtPrice)
    }
    var displayedTotalCompareAtPrice: String? {
        guard case .success = state,
              let selectedVariant = selectedVariant,
              let compareAtPrice = selectedVariant.compareAtPrice,
              compareAtPrice > selectedVariant.price else {
                return nil
            }
                
        let decimalQuantity = Decimal(quantity)
        let totalOldPrice = compareAtPrice * decimalQuantity
        return PriceFormatter.format(totalOldPrice)
        }
    
    var displayedTotalPrice: String {
        guard case .success(let product) = state else { return "" }
        
        let decimalQuantity = Decimal(quantity)
        
        if let selectedVariant = selectedVariant {
            let total = selectedVariant.price * decimalQuantity
            return PriceFormatter.format(total)
        }
        
        if product.priceRange.isSinglePrice {
            let total = product.priceRange.min * decimalQuantity
            return PriceFormatter.format(total)
        }
        
        let minTotal = product.priceRange.min * decimalQuantity
        let maxTotal = product.priceRange.max * decimalQuantity
        return "\(PriceFormatter.format(minTotal)) - \(PriceFormatter.format(maxTotal))"
    }
    
    var stockStatus: StockStatus {
        guard let variant = selectedVariant else { return .unavailable }
        if variant.isAvailable {
            if let qty = variant.inventoryQuantity, qty > 0 {
                return .inStock(quantity: qty)
            }
            return .available
        }
        return .outOfStock
    }
    
    var isAddToCartDisabled: Bool {
        if case .outOfStock = stockStatus { return true }
        if case .unavailable = stockStatus { return true }
        if let maxQty = maxQuantity, quantity > maxQty { return true }
        return false
    }
}
