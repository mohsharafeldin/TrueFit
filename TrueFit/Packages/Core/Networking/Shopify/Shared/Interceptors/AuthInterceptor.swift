//
//  AuthInterceptor.swift
//  TrueFit
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        let token = Bundle.main.shopifyAdminAPIToken
        
        if token.isEmpty {
            completion(.failure(APIError.missingToken))
            return
        }
        
        request.setValue(token, forHTTPHeaderField: Constants.Headers.accessToken)
        request.setValue("application/json", forHTTPHeaderField: Constants.Headers.contentType)
        request.setValue("application/json", forHTTPHeaderField: Constants.Headers.accept)
        
        completion(.success(request))
    }
}
