import Combine
import Foundation

class NetworkRequestManager {
    typealias Params = [String: String]
    
    // MARK: - Public Methods
    
    func request<T: Decodable>(
        path: Path,
        queryParams: Params = [:],
        headers: Params? = nil
    ) -> AnyPublisher<T, NetworkError> {
        let request: URLRequest
        
        do {
            request = try makeRequest(path: path, queryParams: queryParams, headers: headers)
        } catch {
            return Fail<T, NetworkError>(error: NetworkError.invalidRequest)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {  (data, response) in
                guard let response = response as? HTTPURLResponse else {
                    throw ErrorParser.httpError(0)
                }
                
                if !(200...299).contains(response.statusCode) {
                    throw ErrorParser.httpError(response.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                return ErrorParser.handleError(error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
     
    // MARK: - Private Methods
    
    private func url(
        forPath path: Path,
        queryParameters: [String: String]?
    ) throws -> URL {
        
        let baseUrl = path.baseUrl
        var fullUrl = baseUrl + path.endpoint
        
        guard var urlComponents = URLComponents(string: fullUrl) else {
            throw NetworkError.invalidUrl
        }
        
        urlComponents.queryItems = queryParameters?.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
        
        if let url = urlComponents.url {
            print(url)
            return url
        } else {
            throw NetworkError.invalidUrl
        }
    }
    
    private func makeRequest(
        path: Path,
        queryParams: Params = [:],
        headers: Params? = nil
    ) throws -> URLRequest {
        
        let url: URL
        do {
            url = try self.url(forPath: path, queryParameters: queryParams)
        } catch {
            throw NetworkError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = path.httpMethod
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return request
    }
}

