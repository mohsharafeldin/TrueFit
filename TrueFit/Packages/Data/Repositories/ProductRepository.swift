import Foundation

final class ProductRepository: ProductRepositoryProtocol {
    private let remoteDataSource: ProductRemoteDataSourceProtocol
    
    init(remoteDataSource: ProductRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getProduct(id: String) async throws -> Product {
        // [Future CoreData Caching Layer]
        // Example:
        // if let cachedProduct = try? await localDataSource.getProduct(id: id) {
        //     return cachedProduct
        // }
        
        do {
            let productDTO = try await remoteDataSource.fetchProduct(id: id)
            let product = ProductMapper.map(productDTO)
            
            // [Future CoreData Caching Layer]
            // try? await localDataSource.saveProduct(product)
            
            return product
        } catch let error as APIError {
            throw APIErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
