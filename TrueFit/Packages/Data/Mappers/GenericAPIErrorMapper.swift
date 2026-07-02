import Foundation

enum GenericAPIErrorMapper {
    static func map(_ error: GenericAPIError) -> AppError {
        switch error {
        case .invalidURL:
            return .invalidRequest
        case .noInternet:
            return .noInternet
        case .serverError(let code):
            return .serverError(code)
        case .decodingFailed:
            return .decodingFailed
        case .rateLimited:
            return .rateLimited
        case .unknown(let error):
            return .unknown(error.localizedDescription)
        }
    }
}
