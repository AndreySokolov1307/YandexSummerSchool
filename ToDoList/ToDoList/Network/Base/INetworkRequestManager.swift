import Foundation
import Combine

protocol INetworkRequestManager {
    typealias Params = [String: String]
    
    func request<T: Decodable>(
        path: Path,
        queryParams: Params,
        headers: Params?
    ) -> AnyPublisher<T, NetworkError>
    
    func requestWithModel<T: Decodable, P: Encodable>(
        path: Path,
        model: P?,
        headers: Params?
    ) -> AnyPublisher<T, NetworkError>
}
