//
//  RESTClient.swift
//  TrueFit
//

import Foundation
import Alamofire

final class RESTClient: APIClientProtocol {
    private let session: Session
    private let decoder: JSONDecoder
    
    init() {
        let interceptor = Interceptor(interceptors: [AuthInterceptor(), RetryInterceptor()])
        self.session = Session(interceptor: interceptor)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlString = Constants.restBaseURL + endpoint.path
        
        var urlComponents = URLComponents(string: urlString)
        if let queryItems = endpoint.queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let body = endpoint.body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try? encoder.encode(body)
        }
        
        #if DEBUG
        print("🚀 [Shopify API Request]: \(request.httpMethod ?? "GET") \(url)")
        #endif
        
        let dataTask = session.request(request).serializingData()
        
        let response = await dataTask.response
        
        switch response.result {
        case .success(let data):
            if let httpResponse = response.response {
                #if DEBUG
                print("✅ [Shopify API Response]: \(httpResponse.statusCode)")
                #endif
                
                try handleStatusCode(httpResponse.statusCode, data: data)
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed(error)
            }
            
        case .failure(let error):
            if let httpResponse = response.response {
                #if DEBUG
                print("❌ [Shopify API Error]: \(httpResponse.statusCode)")
                #endif
                
                let data = response.data ?? Data()
                try handleStatusCode(httpResponse.statusCode, data: data)
            }
            
            if error.isSessionTaskError {
                throw APIError.noInternetConnection
            }
            
            throw APIError.unknown(error)
        }
    }
    
    private func handleStatusCode(_ statusCode: Int, data: Data) throws {
        switch statusCode {
        case 200...299:
            return // Success
        case 401:
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 429:
            // The interceptor already handles retry; if it bubbles here, it means we hit max retries.
            throw APIError.rateLimited(retryAfterSeconds: nil)
        case 500...599:
            throw APIError.serverError(statusCode: statusCode)
        default:
            // Try parsing the error format
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data), let msg = errorResponse.errors {
                throw APIError.unknown(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: msg]))
            }
            throw APIError.serverError(statusCode: statusCode)
        }
    }
}

/*
 // MARK: - Example Usage
 
 struct GetProductsEndpoint: Endpoint {
     var path = "/products.json"
     var method: HTTPMethod = .get
     var queryItems: [URLQueryItem]? = nil
     var body: Encodable? = nil
 }
 
 // let products: ProductsResponse = try await apiClient.request(GetProductsEndpoint())
*/
