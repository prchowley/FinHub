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
    
    case unknown(error: Error)
    
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
        case .unknown:
            return "Something went wrong. Please try again"
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

// MARK: - Protocols

/// A protocol defining the interface for making network requests.
///
/// Conformers to this protocol are expected to implement a method for sending a request to a specified endpoint
/// and handling the response.
protocol HTTPClientProtocol {
    
    /// Sends a request to the specified endpoint and decodes the response.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to send the request to, which should provide a URL.
    ///   - completion: A closure that is called with the result of the request. It contains either
    ///     the decoded response or an error.
    func request<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, NetworkError>) -> Void)
}

/// A protocol defining the interface for a data task.
///
/// Conformers to this protocol should provide methods to resume or cancel the data task.
protocol URLSessionDataTaskProtocol {
    /// Starts or resumes the data task.
    func resume()
    
    /// Cancels the data task.
    func cancel()
}

/// A protocol defining the interface for creating data tasks.
///
/// Conformers to this protocol should implement a method to create a data task with a specified URL and completion handler.
protocol URLSessionProtocol {
    
    /// Creates a data task with the specified URL and completion handler.
    ///
    /// - Parameters:
    ///   - url: The URL for the data task.
    ///   - completionHandler: A closure that is called with the result of the data task. It includes data, response, and error.
    /// - Returns: A data task conforming to `URLSessionDataTaskProtocol`.
    func createDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

// MARK: - Adapters

/// An adapter class that wraps a `URLSessionDataTask` to conform to `URLSessionDataTaskProtocol`.
///
/// This adapter allows `URLSessionDataTask` to be used interchangeably with `URLSessionDataTaskProtocol` in tests or other code
/// that relies on protocol-based programming.
final class URLSessionDataTaskAdapter: URLSessionDataTaskProtocol {
    
    /// The underlying `URLSessionDataTask` instance.
    private let task: URLSessionDataTask
    
    /// Initializes a new instance of `URLSessionDataTaskAdapter`.
    ///
    /// - Parameter task: The `URLSessionDataTask` to wrap.
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    /// Starts or resumes the data task.
    func resume() {
        task.resume()
    }
    
    /// Cancels the data task.
    func cancel() {
        task.cancel()
    }
}

// MARK: - Extensions

extension URLSession: URLSessionProtocol {
    
    /// Creates a data task with the specified URL and completion handler.
    ///
    /// - Parameters:
    ///   - url: The URL for the data task.
    ///   - completionHandler: A closure that is called with the result of the data task. It includes data, response, and error.
    /// - Returns: A data task conforming to `URLSessionDataTaskProtocol`.
    func createDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let task = self.dataTask(with: url, completionHandler: completionHandler)
        return URLSessionDataTaskAdapter(task: task)
    }
}

// MARK: - HTTP Client

/// A class that implements `HTTPClientProtocol` to perform network requests.
///
/// This class uses an instance of `URLSessionProtocol` to perform requests and a `JSONDecoder` to decode the response data.
class HTTPClient: HTTPClientProtocol {
    
    /// The session used to perform network requests.
    private let urlSession: URLSessionProtocol
    
    /// The decoder used to decode response data.
    private let decoder: JSONDecoder

    /// Initializes a new instance of `HTTPClient`.
    ///
    /// - Parameters:
    ///   - urlSession: The session to use for performing network requests (default is `URLSession.shared`).
    ///   - decoder: The decoder to use for decoding response data (default is `JSONDecoder()`).
    init(urlSession: URLSessionProtocol = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    /// Sends a request to the specified endpoint and decodes the response.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to send the request to.
    ///   - completion: A closure that is called with the result of the request. It contains either
    ///     the decoded response or an error.
    func request<T: Decodable>(endpoint: EndpointProvider, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        debugPrint("⬆️ Request URL: \(url)")

        let task = urlSession.createDataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                debugPrint("❌ Request Error: \(error.localizedDescription)")
                completion(.failure(.unknown(error: error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("📡 Response Status Code: \(httpResponse.statusCode)")
                debugPrint("📡 Response Headers: \(httpResponse.allHeaderFields)")
            }

            guard let data = data else {
                debugPrint("⚠️ No Data Received")
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decodedData = try self?.decoder.decode(T.self, from: data)
                if let decodedData = decodedData {
                    completion(.success(decodedData))
                } else {
                    debugPrint("⚠️ Data Decoding Error")
                    completion(.failure(NetworkError.decodingError))
                }
            } catch {
                debugPrint("❌ Decoding Error: \(error.localizedDescription)")
                completion(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }
}
