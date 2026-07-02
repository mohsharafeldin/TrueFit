//
//  Constants.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

enum Constants {
    static var restBaseURL: String {
        "https://\(Bundle.main.shopifyStoreName).myshopify.com/admin/api/\(Bundle.main.shopifyAPIVersion)"
    }
    
    static var graphQLBaseURL: String {
        "https://\(Bundle.main.shopifyStoreName).myshopify.com/admin/api/\(Bundle.main.shopifyGraphQLAPIVersion)/graphql.json"
    }
    
    static var storefrontGraphQLBaseURL: String {
        "https://\(Bundle.main.shopifyStoreName).myshopify.com/api/\(Bundle.main.shopifyGraphQLAPIVersion)/graphql.json"
    }
    
    enum Headers {
        static let accessToken = "X-Shopify-Access-Token"
        static let storefrontAccessToken = "X-Shopify-Storefront-Access-Token"
        static let customerAccessToken = "X-Shopify-Customer-Access-Token"
        static let contentType = "Content-Type"
        static let accept = "Accept"
    }
}
