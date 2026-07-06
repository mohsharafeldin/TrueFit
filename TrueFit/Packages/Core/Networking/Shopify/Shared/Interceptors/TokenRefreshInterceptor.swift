//
//  TokenRefreshInterceptor.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation
import Apollo
import ApolloAPI

public class TokenRefreshInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString
    
    private let authManager: AuthManagerProtocol
    private let refreshManager: TokenRefreshManager
    
    init(authManager: AuthManagerProtocol, refreshAction: @escaping (String) async throws -> String) {
        self.authManager = authManager
        self.refreshManager = TokenRefreshManager(authManager: authManager, refreshAction: refreshAction)
    }
    
    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        chain.proceedAsync(request: request, response: response, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let graphQLResult):
                let isTokenExpired = graphQLResult.errors?.contains(where: { error in
                    let message = error.message?.lowercased() ?? ""
                    return message.contains("access token") && message.contains("expired")
                }) ?? false
                
                let isHTTP401 = response?.httpResponse.statusCode == 401
                
                if isTokenExpired || isHTTP401 {
                    self.handleTokenRefresh(chain: chain, request: request, response: response, completion: completion)
                } else {
                    completion(result)
                }
                
            case .failure(let error):
                if let response = response, response.httpResponse.statusCode == 401 {
                    self.handleTokenRefresh(chain: chain, request: request, response: response, completion: completion)
                } else {
                    completion(.failure(error))
                }
            }
        })
    }
    
    private func handleTokenRefresh<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        Task {
            guard let currentToken = await self.authManager.getAccessToken() else {
                completion(.failure(APIError.unauthorized))
                return
            }
            
            do {
                let _ = try await self.refreshManager.refreshToken(currentToken: currentToken)
                chain.retry(request: request, completion: completion)
            } catch {
                await MainActor.run {
                    self.authManager.logout()
                }
                chain.handleErrorAsync(error, request: request, response: response, completion: completion)
            }
        }
    }
}

