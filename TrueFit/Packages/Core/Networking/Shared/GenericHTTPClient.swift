import Foundation
import Alamofire

final class GenericHTTPClient: GenericHTTPClientProtocol {
    private let session: Session
    private let jsonDecoder: JSONDecoder
    
    init(session: Session = .default) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.jsonDecoder = decoder
    }
    
    func request<T: Decodable>(_ endpoint: GenericEndpoint) async throws -> T {
        do {
            return try await performRequest(endpoint)
        } catch let error as GenericAPIError {
            if case .noInternet = error {
                // One-time retry on connection lost (1s delay)
                try await Task.sleep(nanoseconds: 1_000_000_000)
                return try await performRequest(endpoint)
            }
            throw error
        } catch {
            throw error
        }
    }
    
    private func performRequest<T: Decodable>(_ endpoint: GenericEndpoint) async throws -> T {
        guard var urlComponents = URLComponents(url: endpoint.baseURL, resolvingAgainstBaseURL: true) else {
            throw GenericAPIError.invalidURL
        }
        
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        
        guard let url = urlComponents.url else {
            throw GenericAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        #if DEBUG
        print("🚀 [GenericHTTPClient] Request: \(request.httpMethod ?? "") \(url.absoluteString)")
        #endif
        
        do {
            let task = session.request(request)
                .validate()
                .serializingDecodable(T.self, decoder: jsonDecoder)
            
            let result = try await task.value
            
            #if DEBUG
            print("✅ [GenericHTTPClient] Success: \(url.absoluteString)")
            #endif
            
            return result
        } catch let afError as AFError {
            throw mapError(afError)
        } catch {
            throw GenericAPIError.unknown(error)
        }
    }
    
    private func mapError(_ afError: AFError) -> GenericAPIError {
        switch afError {
        case .sessionTaskFailed(let error as URLError):
            if error.code == .notConnectedToInternet || error.code == .timedOut {
                return .noInternet
            }
            return .unknown(error)
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                if code == 429 {
                    return .rateLimited
                } else if code >= 500 {
                    return .serverError(code)
                }
                return .serverError(code)
            default:
                return .unknown(afError)
            }
        case .responseSerializationFailed:
            return .decodingFailed(afError)
        default:
            return .unknown(afError)
        }
    }
}
