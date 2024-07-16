import Combine
import Foundation
import CocoaLumberjackSwift

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
            DDLogError("Failed to create URL for \(path.endpoint): \(error.localizedDescription)")
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
    
    public func requestWithModel<T: Decodable, P: Encodable>(
        path: Path,
        model: P? = nil,
        headers: Params? = nil
    ) -> AnyPublisher<T, NetworkError> {
        var request: URLRequest
        
        do {
            request = try makeRequest(path: path, headers: headers)
        } catch {
            DDLogError("Failed to create URL for \(path.endpoint): \(error.localizedDescription)")
            return Fail<T, NetworkError>(error: NetworkError.invalidRequest)
                .eraseToAnyPublisher()
        }
        
        let jsonData = try? JSONEncoder().encode(model)
        request.httpBody = jsonData
        
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
        queryParameters: Params? = nil
    ) throws -> URL {

        let fullUrl = path.baseUrl + path.endpoint
        
        guard var urlComponents = URLComponents(string: fullUrl) else {
            DDLogError("Failed to create URLComponents from URL: \(fullUrl)")
            throw NetworkError.invalidUrl
        }
        
        urlComponents.queryItems = queryParameters?.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
        
        if let url = urlComponents.url {
            DDLogDebug("Created URL: \(url)")
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
        
        DDLogDebug("Created URLRequest for URL: \(url)")
        
        request.httpMethod = path.httpMethod
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.setValue("Bearer Aldaron", forHTTPHeaderField: HeaderKey.authorization)
        return request
    }
}


// MARK: - REVISION 2
// 7EBE5060-0DB6-4D6A-9EA4-1B8D7FD15C8B --- ID

// for POST ONLY (and list patch)
