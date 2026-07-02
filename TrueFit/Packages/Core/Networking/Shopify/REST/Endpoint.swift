//
//  Endpoint.swift
//  TrueFit
//

import Foundation
import Alamofire

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
}

struct GetProductEndpoint: Endpoint {
    let productId: String
    
    init(productId: String) {
        self.productId = productId
    }
    
    var path: String {
        return "/products/\(productId).json"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Encodable? {
        return nil
    }
}
