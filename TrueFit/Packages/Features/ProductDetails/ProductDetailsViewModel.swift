import Foundation
import Combine


@MainActor
final class ProductDetailsViewModel: ObservableObject {
    private let getProductUseCase: GetProductUseCase
    
    @Published var state: ViewState<Product> = .idle
    @Published var selectedVariant: ProductVariant?
    
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
    
    var displayedImages: [ProductImage] {
        guard case .success(let product) = state else { return [] }
        return product.images
    }
    
    var displayedPrice: String {
        guard case .success(let product) = state else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let selectedVariant = selectedVariant {
            return formatter.string(from: selectedVariant.price as NSDecimalNumber) ?? ""
        }
        
        if product.priceRange.isSinglePrice {
            return formatter.string(from: product.priceRange.min as NSDecimalNumber) ?? ""
        }
        
        let minString = formatter.string(from: product.priceRange.min as NSDecimalNumber) ?? ""
        let maxString = formatter.string(from: product.priceRange.max as NSDecimalNumber) ?? ""
        return "\(minString) - \(maxString)"
    }
    
    var displayedCompareAtPrice: String? {
        guard case .success = state,
              let selectedVariant = selectedVariant,
              let compareAtPrice = selectedVariant.compareAtPrice,
              compareAtPrice > selectedVariant.price else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: compareAtPrice as NSDecimalNumber)
    }
    

}
