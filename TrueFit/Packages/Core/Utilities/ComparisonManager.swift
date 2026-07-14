import Foundation
import Combine

class ComparisonManager: ObservableObject {
    static let shared = ComparisonManager()
    
    @Published var selectedProducts: [Product] = []
    
    private init() {}
    
    func toggleSelection(for product: Product) {
        if let index = selectedProducts.firstIndex(where: { $0.id == product.id }) {
            selectedProducts.remove(at: index)
        } else {
            // Limit to a maximum number of products, e.g., 3
            if selectedProducts.count < 3 {
                selectedProducts.append(product)
            }
        }
    }
    
    func isSelected(_ product: Product) -> Bool {
        return selectedProducts.contains(where: { $0.id == product.id })
    }
    
    func clear() {
        selectedProducts.removeAll()
    }
}
