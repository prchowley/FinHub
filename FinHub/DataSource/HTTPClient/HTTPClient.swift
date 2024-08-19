//
//  HTTPClient.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

// MARK: - Error Handling
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

// MARK: - Protocols
protocol HTTPClientProtocol {
    func request<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, Error>) -> Void)
}

protocol URLSessionProtocol: Sendable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

// MARK: - HTTPClient
class HTTPClient: HTTPClientProtocol {
    
    private let urlSession: URLSessionProtocol
    private let decoder: JSONDecoder
    
    init(urlSession: URLSessionProtocol = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    func request<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        debugPrint("⬆️ Request URL: \(url)")
        
        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try self?.decoder.decode(T.self, from: data)
                completion(.success(decodedData!))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }
}
