import Foundation

final class ErrorParser {
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Methods
    
    static func httpError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400: return .invalidRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    static func handleError(_ error: Error) -> NetworkError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError(error.localizedDescription)
        case let urlError as URLError:
            if urlError.code.rawValue == -1001 || urlError.code.rawValue == -1009 {
                return .timeOut
            } else {
                return .urlSessionFailed(urlError)
            }
        case let error as NetworkError:
            return error
        default:
            return .unknownError
        }
    }
}
