import Foundation
import Combine

@MainActor
public final class CartState: ObservableObject {
    @Published public var itemCount: Int = 0
    
    public init() {}
    
    public func updateCount(_ count: Int) {
        self.itemCount = count
    }
}
