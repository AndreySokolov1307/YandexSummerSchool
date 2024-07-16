import Foundation

protocol Path {
    var endpoint: String { get }
    var method: HttpMethod { get }
    var baseUrl: String { get }
    var transferProtocol: String { get }
}

extension Path {
    var httpMethod: String {
        return method.rawValue
    }
}

