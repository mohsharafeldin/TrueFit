//
//  StorefrontAuthInterceptor.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation
import Apollo

public class StorefrontAuthInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString
    private let authManager: AuthManagerProtocol
    
    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }
    
    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        
        let token = Bundle.main.shopifyStorefrontToken
        
        if token.isEmpty {
            chain.handleErrorAsync(APIError.missingToken,
                                   request: request,
                                   response: response,
                                   completion: completion)
            return
        }
        
        // Add public Storefront Token
        request.addHeader(name: Constants.Headers.storefrontAccessToken, value: token)
        
        // Fetch token from MainActor-isolated AuthManager
        Task {
            let customerToken = await authManager.getAccessToken()
            
            // Add Customer Access Token if available
            if let token = customerToken, !token.isEmpty {
                request.addHeader(name: Constants.Headers.customerAccessToken, value: token)
            }
            
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
    }
}

