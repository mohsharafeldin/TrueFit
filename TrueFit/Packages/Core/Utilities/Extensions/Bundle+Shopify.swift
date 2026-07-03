//
//  Bundle+Shopify.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

extension Bundle {
    var shopifyStoreName: String {
        guard let name = object(forInfoDictionaryKey: "ShopifyStoreName") as? String, !name.isEmpty else {
            #if DEBUG
            fatalError("ShopifyStoreName is missing in Info.plist or Config.xcconfig")
            #else
            return ""
            #endif
        }
        return name
    }
    
    var shopifyAdminAPIToken: String {
        guard let token = object(forInfoDictionaryKey: "ShopifyAdminAPIToken") as? String, !token.isEmpty else {
            #if DEBUG
            fatalError("ShopifyAdminAPIToken is missing in Info.plist or Config.xcconfig")
            #else
            return ""
            #endif
        }
        return token
    }
    
    var shopifyStorefrontToken: String {
        guard let token = object(forInfoDictionaryKey: "ShopifyStorefrontToken") as? String, !token.isEmpty else {
            #if DEBUG
            fatalError("ShopifyStorefrontToken is missing in Info.plist or Config.xcconfig")
            #else
            return ""
            #endif
        }
        return token
    }
    
    var shopifyAPIVersion: String {
        guard let version = object(forInfoDictionaryKey: "ShopifyAPIVersion") as? String, !version.isEmpty else {
            #if DEBUG
            fatalError("ShopifyAPIVersion is missing in Info.plist or Config.xcconfig")
            #else
            return "2024-10"
            #endif
        }
        return version
    }
    
    var shopifyGraphQLAPIVersion: String {
        guard let version = object(forInfoDictionaryKey: "ShopifyGraphQLAPIVersion") as? String, !version.isEmpty else {
            #if DEBUG
            fatalError("ShopifyGraphQLAPIVersion is missing in Info.plist or Config.xcconfig")
            #else
            return "2024-10"
            #endif
        }
        return version
    }
}

