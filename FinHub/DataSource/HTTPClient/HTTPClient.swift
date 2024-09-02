//
//  HTTPClient.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

// MARK: - NetworkError

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
            return "Something went wrong. Please try again."
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

// MARK: - Protocol Definitions

protocol URLSessionDataTaskProtocol {
    /// Starts or resumes the data task.
    func resume()
    
    /// Cancels the data task.
    func cancel()
    func request<T: Decodable>(endpoint: EndpointProvider) async throws -> T
}

/// A protocol defining the interface for network requests.
protocol HTTPClientProtocol {
    func request<T: Decodable>(endpoint: EndpointProvider) async throws -> T
}

/// A protocol defining the interface for creating data tasks.
protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// MARK: - URLSession Adapter

/// A class that adapts `URLSession` to conform to `URLSessionProtocol`.
final class URLSessionAdapter: URLSessionProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return try await session.data(from: url)
    }
}

// MARK: - HTTPClient Implementation

/// A class that implements `HTTPClientProtocol` using a dependency-injected `URLSessionProtocol`.
final class HTTPClient: HTTPClientProtocol {
    var urlSession: URLSessionProtocol
    private let decoder: JSONDecoder
    
    static let shared = HTTPClient()
    
    init(
        urlSession: URLSessionProtocol = URLSessionAdapter(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    func request<T: Decodable>(endpoint: EndpointProvider) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        return try await requestAPI(url: url)
    }
    
    private func requestAPI<T: Decodable>(url: URL) async throws -> T {
        debugPrint("⬆️ Request URL: \(url)")
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("📡 Response Status Code: \(httpResponse.statusCode)")
                debugPrint("📡 Response Headers: \(httpResponse.allHeaderFields)")
            }
            
            return try decoder.decode(T.self, from: data)
            
        } catch is DecodingError {
            debugPrint("❌ Decoding Error")
            throw NetworkError.decodingError
        } catch {
            debugPrint("❌ Network Error: \(error.localizedDescription)")
            throw NetworkError.unknown(error: error)
        }
    }
}
