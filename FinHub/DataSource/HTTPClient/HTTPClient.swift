//
//  HTTPClient.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

protocol HTTPClientProtocol {
    func performRequest<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, Error>) -> Void)
}

class HTTPClient: HTTPClientProtocol {
    func performRequest<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        print("⬆️ Request URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("⬇️ Response Data: \(responseString)")
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
