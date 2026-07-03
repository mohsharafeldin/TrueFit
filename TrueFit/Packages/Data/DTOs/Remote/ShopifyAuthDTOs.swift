//
//  ShopifyAuthDTOs.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLError]?
}

struct GraphQLError: Decodable {
    let message: String
}

struct ShopifyUserError: Decodable {
    let message: String
}


// Sign Up
struct CustomerCreateData: Decodable {
    let customerCreate: CustomerCreatePayload?
}

struct CustomerCreatePayload: Decodable {
    let customer: ShopifyCustomerResponse?
    let customerUserErrors: [ShopifyUserError]?
}

public struct ShopifyCustomerResponse: Codable {
    public let id: String
    public let email: String
    public let firstName: String?
    public let lastName: String?
}


// Create and Renew Token
struct CustomerTokenData: Decodable {
    let customerAccessTokenCreate: TokenPayload?
    let customerAccessTokenRenew: TokenPayload?
}

struct TokenPayload: Decodable {
    let customerAccessToken: ShopifyCustomerTokenResponse?
    let customerUserErrors: [ShopifyUserError]?
    let userErrors: [ShopifyUserError]?
}

public struct ShopifyCustomerTokenResponse: Codable {
    public let accessToken: String
    public let expiresAt: String
}


// logout
struct CustomerTokenDeleteData: Decodable {
    let customerAccessTokenDelete: DeletePayload?
}

struct DeletePayload: Decodable {
    let deletedAccessToken: String?
    let userErrors: [ShopifyUserError]?
}
