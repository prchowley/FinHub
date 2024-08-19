//
//  HTTPClient.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

// MARK: - Error Handling
/// An enumeration representing errors that can occur during network operations.
///
/// This enum defines various error conditions that may arise while performing network requests,
/// such as invalid URLs, lack of data, or issues with decoding responses.
enum NetworkError: Error {
    
    /// Indicates that the URL provided was invalid.
    case invalidURL
    
    /// Indicates that no data was received in the network response.
    case noData
    
    /// Indicates that there was an error decoding the response data.
    case decodingError
    
    /// A user-friendly description of the error.
    ///
    /// This property provides a human-readable message for each error case,
    /// suitable for displaying to users or logging.
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid. Please check the URL and try again."
        case .noData:
            return "No data was received from the server. Please check your internet connection and try again."
        case .decodingError:
            return "There was an error decoding the data received from the server. Please try again later."
        }
    }
}

// MARK: - Protocols

/// Protocol for making network requests.
protocol HTTPClientProtocol {
    /// Sends a request to the specified endpoint and decodes the response.
    /// - Parameters:
    ///   - endpoint: The endpoint to send the request to.
    ///   - completion: Completion handler with the result containing either the decoded response or an error.
    func request<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, Error>) -> Void)
}

/// Protocol for URLSession, used for dependency injection in tests.
protocol URLSessionProtocol: Sendable {
    /// Creates a data task with the specified URL and completion handler.
    /// - Parameters:
    ///   - url: The URL for the data task.
    ///   - completionHandler: The completion handler for the data task.
    /// - Returns: A URLSessionDataTask instance.
    func dataTask(with url: URL, completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

// MARK: - HTTPClient

/// A client for making HTTP network requests.
class HTTPClient: HTTPClientProtocol {
    
    /// The URL session used for making network requests.
    private let urlSession: URLSessionProtocol
    
    /// The JSON decoder used for decoding responses.
    private let decoder: JSONDecoder
    
    /// Initializes a new instance of `HTTPClient`.
    /// - Parameters:
    ///   - urlSession: The URL session to use for network requests, default is `URLSession.shared`.
    ///   - decoder: The JSON decoder to use for decoding responses, default is `JSONDecoder()`.
    init(urlSession: URLSessionProtocol = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    /// Sends a request to the specified endpoint and decodes the response.
    /// - Parameters:
    ///   - endpoint: The endpoint to send the request to.
    ///   - completion: Completion handler with the result containing either the decoded response or an error.
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
