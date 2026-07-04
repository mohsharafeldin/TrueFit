import Foundation

final class CartRepository: CartRepositoryProtocol {
    private let remoteDataSource: CartRemoteDataSourceProtocol
    
    init(remoteDataSource: CartRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - CartRepositoryProtocol
    
    func getCart(id: String) async throws -> Cart {
        do {
            /*
             // Placeholder for CoreData persistence integration:
             if let localCart = try? localDataSource.getCart(id: id) {
                 return localCart
             }
             let remoteCart = try await remoteDataSource.fetchCart(id: id)
             try? localDataSource.saveCart(remoteCart)
             return remoteCart
             */
            return try await remoteDataSource.fetchCart(id: id)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func createCart(variantId: String, quantity: Int) async throws -> Cart {
        do {
            return try await remoteDataSource.createCart(variantId: variantId, quantity: quantity)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func addToCart(cartId: String, variantId: String, quantity: Int) async throws -> Cart {
        do {
            return try await remoteDataSource.addLines(cartId: cartId, variantId: variantId, quantity: quantity)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func updateQuantity(cartId: String, lineId: String, quantity: Int) async throws -> Cart {
        do {
            return try await remoteDataSource.updateLine(cartId: cartId, lineId: lineId, quantity: quantity)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func removeLine(cartId: String, lineId: String) async throws -> Cart {
        do {
            return try await remoteDataSource.removeLine(cartId: cartId, lineId: lineId)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
    
    func applyDiscount(cartId: String, code: String) async throws -> Cart {
        do {
            return try await remoteDataSource.applyDiscount(cartId: cartId, code: code)
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
