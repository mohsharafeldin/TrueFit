//
//  ShopifyAuthDataSource.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation
import Alamofire

public final class ShopifyAuthDataSource: ShopifyAuthDataSourceProtocol {
    
    private let baseURL: URL
    private let headers: HTTPHeaders
    
    public init() {
            guard let url = URL(string: Constants.storefrontGraphQLBaseURL) else {
                fatalError("Invalid Storefront URL in Constants")
            }
            self.baseURL = url
            
            self.headers = [
                Constants.Headers.storefrontAccessToken: Bundle.main.shopifyStorefrontToken,
                Constants.Headers.contentType: "application/json",
                Constants.Headers.accept: "application/json"
            ]
        }
    
    private func performGraphQLRequest<T: Decodable>(query: String, variables: [String: Any]) async throws -> T {
        let parameters: [String: Any] = ["query": query, "variables": variables]
        
        let task = AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        let result = await task.serializingDecodable(GraphQLResponse<T>.self).response
        
        switch result.result {
        case .success(let graphQLResponse):
            if let errors = graphQLResponse.errors, !errors.isEmpty {
                throw APIError.graphQLErrors(errors.map { $0.message })
            }
            guard let data = graphQLResponse.data else {
                throw APIError.unknown(NSError(domain: "Shopify", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"]))
            }
            return data
            
        case .failure(let afError):
            if afError.isSessionTaskError {
                throw APIError.noInternetConnection
            }
            throw APIError.unknown(afError)
        }
    }
    
    // MARK: Sign Up
    public func customerCreate(firstName: String, lastName: String, email: String, password: String) async throws -> ShopifyCustomerResponse {
        let query = """
        mutation customerCreate($input: CustomerCreateInput!) {
          customerCreate(input: $input) {
            customer { id email firstName lastName }
            customerUserErrors { message }
          }
        }
        """
        let variables: [String: Any] = [
            "input": ["firstName": firstName, "lastName": lastName, "email": email, "password": password]
        ]
        
        let data: CustomerCreateData = try await performGraphQLRequest(query: query, variables: variables)
        
        if let userErrors = data.customerCreate?.customerUserErrors, !userErrors.isEmpty {
            let errorMessage = userErrors.map { $0.message }.joined(separator: ", ")
            throw NSError(domain: "ShopifyAuth", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        guard let customer = data.customerCreate?.customer else {
            throw NSError(domain: "ShopifyAuth", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to create customer"])
        }
        return customer
    }
    
    // MARK: Log In
    public func customerAccessTokenCreate(email: String, password: String) async throws -> ShopifyCustomerTokenResponse {
        let query = """
        mutation customerAccessTokenCreate($input: CustomerAccessTokenCreateInput!) {
          customerAccessTokenCreate(input: $input) {
            customerAccessToken { accessToken expiresAt }
            customerUserErrors { message }
          }
        }
        """
        let variables: [String: Any] = [
            "input": ["email": email, "password": password]
        ]
        
        let data: CustomerTokenData = try await performGraphQLRequest(query: query, variables: variables)
        
        if let userErrors = data.customerAccessTokenCreate?.customerUserErrors, !userErrors.isEmpty {
            let errorMessage = userErrors.map { $0.message }.joined(separator: ", ")
            throw NSError(domain: "ShopifyAuth", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        guard let token = data.customerAccessTokenCreate?.customerAccessToken else {
            throw NSError(domain: "ShopifyAuth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
        }
        return token
    }
    
    // MARK: Refresh Token
    public func customerAccessTokenRenew(customerAccessToken: String) async throws -> ShopifyCustomerTokenResponse {
        let query = """
        mutation customerAccessTokenRenew($customerAccessToken: String!) {
          customerAccessTokenRenew(customerAccessToken: $customerAccessToken) {
            customerAccessToken { accessToken expiresAt }
            userErrors { message }
          }
        }
        """
        let variables: [String: Any] = ["customerAccessToken": customerAccessToken]
        
        let data: CustomerTokenData = try await performGraphQLRequest(query: query, variables: variables)
        
        if let userErrors = data.customerAccessTokenRenew?.userErrors, !userErrors.isEmpty {
            let errorMessage = userErrors.map { $0.message }.joined(separator: ", ")
            throw NSError(domain: "ShopifyAuth", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        guard let token = data.customerAccessTokenRenew?.customerAccessToken else {
            throw NSError(domain: "ShopifyAuth", code: 404, userInfo: [NSLocalizedDescriptionKey: "Session expired"])
        }
        return token
    }
    
    // MARK: Log Out
    public func customerAccessTokenDelete(accessToken: String) async throws {
        let query = """
        mutation customerAccessTokenDelete($customerAccessToken: String!) {
          customerAccessTokenDelete(customerAccessToken: $customerAccessToken) {
            deletedAccessToken
            userErrors { message }
          }
        }
        """
        let variables: [String: Any] = ["customerAccessToken": accessToken]
        
        let data: CustomerTokenDeleteData = try await performGraphQLRequest(query: query, variables: variables)
        
        if let userErrors = data.customerAccessTokenDelete?.userErrors, !userErrors.isEmpty {
            let errorMessage = userErrors.map { $0.message }.joined(separator: ", ")
            throw NSError(domain: "ShopifyAuth", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
}

