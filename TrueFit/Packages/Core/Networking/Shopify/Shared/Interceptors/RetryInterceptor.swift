//
//  RetryInterceptor.swift
//  TrueFit
//

import Foundation
import Alamofire

final class RetryInterceptor: RequestInterceptor {
    private let maxRetryCount = 1
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        let statusCode = response?.statusCode ?? 0
        
        guard request.retryCount < maxRetryCount else {
            completion(.doNotRetry)
            return
        }
        
        switch statusCode {
        case 429:
            // Retry on rate limit
            let retryAfterSeconds: TimeInterval
            if let retryAfterHeader = response?.value(forHTTPHeaderField: "Retry-After"),
               let delay = TimeInterval(retryAfterHeader) {
                retryAfterSeconds = delay
            } else {
                retryAfterSeconds = 2.0 // Default fallback delay
            }
            completion(.retryWithDelay(retryAfterSeconds))
        case 401, 403, 404:
            // Fail fast for authentication or not found errors
            completion(.doNotRetry)
        case 500...599:
            // Retry once on transient server errors
            completion(.retryWithDelay(1.0))
        default:
            if let afError = error as? AFError, afError.isSessionTaskError {
                // Network connection lost, etc.
                completion(.retryWithDelay(1.0))
            } else {
                completion(.doNotRetry)
            }
        }
    }
}
