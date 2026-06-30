//
//  GraphQLClient.swift
//  TrueFit
//

import Foundation
import Alamofire

final class GraphQLClient {
    private let session: Session
    private let decoder: JSONDecoder
    
    init() {
        let interceptor = Interceptor(interceptors: [AuthInterceptor(), RetryInterceptor()])
        self.session = Session(interceptor: interceptor)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }
    
    func request<T: Decodable>(_ endpoint: GraphQLEndpoint) async throws -> T {
        fatalError("GraphQL Client is not implemented yet")
    }
}

/*
 // MARK: - Example Usage
 
 struct GetProductsQuery: GraphQLEndpoint {
     var query = "{ products(first: 10) { edges { node { id title } } } }"
     var variables: [String: Any]? = nil
 }
 
 // let products: ProductsGraphQLResponse = try await graphQLClient.request(GetProductsQuery())
*/
