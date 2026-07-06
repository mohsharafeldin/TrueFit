import ShopifyAPI
import Foundation

protocol CartRemoteDataSourceProtocol {
    func fetchCart(id: String) async throws -> Cart
    func createCart(variantId: String, quantity: Int) async throws -> Cart
    func addLines(cartId: String, variantId: String, quantity: Int) async throws -> Cart
    func updateLine(cartId: String, lineId: String, quantity: Int) async throws -> Cart
    func removeLine(cartId: String, lineId: String) async throws -> Cart
    func applyDiscount(cartId: String, code: String) async throws -> Cart
}

final class CartRemoteDataSource: CartRemoteDataSourceProtocol {
    private let apollo: ApolloManager
    
    init(apollo: ApolloManager ) {
        self.apollo = apollo
    }
    
    func fetchCart(id: String) async throws -> Cart {
        let query = GetCartQuery(cartId: id)
        let data = try await apollo.fetch(query: query)
        guard let cartFields = data.cart?.fragments.cartFields else {
            throw APIError.noData
        }
        return CartMapper.map(cartFields)
    }
    
    func createCart(variantId: String, quantity: Int) async throws -> Cart {
        let lineInput = CartLineInput(quantity: .some(quantity), merchandiseId: variantId)
        let input = CartInput(lines: [lineInput])
        let mutation = CreateCartMutation(input: input)
        let data = try await apollo.perform(mutation: mutation)
        
        if let userErrors = data.cartCreate?.userErrors, !userErrors.isEmpty {
            throw APIError.graphQLErrors(userErrors.map { $0.message })
        }
        
        guard let cartFields = data.cartCreate?.cart?.fragments.cartFields else {
            throw APIError.noData
        }
        return CartMapper.map(cartFields)
    }
    
    func addLines(cartId: String, variantId: String, quantity: Int) async throws -> Cart {
        let lineInput = CartLineInput(quantity: .some(quantity), merchandiseId: variantId)
        let mutation = AddCartLinesMutation(cartId: cartId, lines: [lineInput])
        let data = try await apollo.perform(mutation: mutation)
        
        if let userErrors = data.cartLinesAdd?.userErrors, !userErrors.isEmpty {
            throw APIError.graphQLErrors(userErrors.map { $0.message })
        }
        
        guard let cartFields = data.cartLinesAdd?.cart?.fragments.cartFields else {
            throw APIError.noData
        }
        return CartMapper.map(cartFields)
    }
    
    func updateLine(cartId: String, lineId: String, quantity: Int) async throws -> Cart {
        let lineUpdate = CartLineUpdateInput(id: lineId, quantity: .some(quantity))
        let mutation = UpdateCartLinesMutation(cartId: cartId, lines: [lineUpdate])
        let data = try await apollo.perform(mutation: mutation)
        
        if let userErrors = data.cartLinesUpdate?.userErrors, !userErrors.isEmpty {
            throw APIError.graphQLErrors(userErrors.map { $0.message })
        }
        
        guard let cartFields = data.cartLinesUpdate?.cart?.fragments.cartFields else {
            throw APIError.noData
        }
        return CartMapper.map(cartFields)
    }
    
    func removeLine(cartId: String, lineId: String) async throws -> Cart {
        let mutation = RemoveCartLinesMutation(cartId: cartId, lineIds: [lineId])
        let data = try await apollo.perform(mutation: mutation)
        
        if let userErrors = data.cartLinesRemove?.userErrors, !userErrors.isEmpty {
            throw APIError.graphQLErrors(userErrors.map { $0.message })
        }
        
        guard let cartFields = data.cartLinesRemove?.cart?.fragments.cartFields else {
            throw APIError.noData
        }
        return CartMapper.map(cartFields)
    }
    
    func applyDiscount(cartId: String, code: String) async throws -> Cart {
        let mutation = ApplyDiscountCodeMutation(cartId: cartId, discountCodes: [code])
        let data = try await apollo.perform(mutation: mutation)
        
        if let userErrors = data.cartDiscountCodesUpdate?.userErrors, !userErrors.isEmpty {
            throw APIError.graphQLErrors(userErrors.map { $0.message })
        }
        
        guard let cartFields = data.cartDiscountCodesUpdate?.cart?.fragments.cartFields else {
            throw APIError.noData
        }
        return CartMapper.map(cartFields)
    }
}
