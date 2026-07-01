//
//  ShopifyAuthDataSourceProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public protocol ShopifyAuthDataSourceProtocol {
    func customerCreate(firstName: String, lastName: String, email: String, password: String) async throws -> ShopifyCustomerResponse
    func customerAccessTokenCreate(email: String, password: String) async throws -> ShopifyCustomerTokenResponse
    func customerAccessTokenRenew(customerAccessToken: String) async throws -> ShopifyCustomerTokenResponse
    func customerAccessTokenDelete(accessToken: String) async throws
}

