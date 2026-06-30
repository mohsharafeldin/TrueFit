//
//  Constants.swift
//  TrueFit
//

import Foundation

enum Constants {
    static var restBaseURL: String {
        "https://\(Bundle.main.shopifyStoreName).myshopify.com/admin/api/\(Bundle.main.shopifyAPIVersion)"
    }
    
    static var graphQLBaseURL: String {
        "https://\(Bundle.main.shopifyStoreName).myshopify.com/admin/api/\(Bundle.main.shopifyGraphQLAPIVersion)/graphql.json"
    }
    
    enum Headers {
        static let accessToken = "X-Shopify-Access-Token"
        static let contentType = "Content-Type"
        static let accept = "Accept"
    }
}
