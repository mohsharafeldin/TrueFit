import Foundation
import Combine

@MainActor
final class ProductDetailsViewModel: ObservableObject {
    private let getProductUseCase: GetProductUseCase
    
    @Published var state: ViewState<Product> = .idle
    @Published var selectedVariant: ProductVariant?
    @Published var quantity: Int = 1
    
    init(getProductUseCase: GetProductUseCase) {
        self.getProductUseCase = getProductUseCase
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
    
    func selectVariant(_ variant: ProductVariant) {
        self.selectedVariant = variant
    }
    
    // MARK: - UI Formatters
    
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
    
    // MARK: - Actions
    
    func addToCart() {
        guard let variant = selectedVariant else { return }
        print("🛒 Added \(quantity) of variant [\(variant.id)] to Cart!")
    }
    
    func increaseQuantity() {
        quantity += 1
    }
        
    func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
}
