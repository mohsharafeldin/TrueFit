import Foundation
import Combine

@MainActor
public final class CartState: ObservableObject {
    @Published public var itemCount: Int
    private var onUpdate: ((Int) -> Void)?
    
    public init(initialCount: Int = 0, onUpdate: ((Int) -> Void)? = nil) {
        self.itemCount = initialCount
        self.onUpdate = onUpdate
    }
    
    public func updateCount(_ count: Int) {
        self.itemCount = count
        onUpdate?(count)
    }
}
