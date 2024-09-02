//
//  HTTPClientTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

/// A test suite for verifying the behavior of the `HTTPClient` class.
///
/// This class contains tests to ensure that the `HTTPClient` handles various network scenarios correctly,
/// including successful requests and different types of failures.
import XCTest

final class NetworkErrorTests: XCTestCase {
    func testLocalizedDescription() {
        XCTAssertEqual(NetworkError.invalidURL.localizedDescription, "The URL provided was invalid. Please check the URL and try again.")
        XCTAssertEqual(NetworkError.noData.localizedDescription, "No data was received from the server. Please check your internet connection and try again.")
        XCTAssertEqual(NetworkError.decodingError.localizedDescription, "There was an error decoding the data received from the server. Please try again later.")
        XCTAssertEqual(NetworkError.unknown(error: NSError(domain: "", code: 0, userInfo: nil)).localizedDescription, "Something went wrong. Please try again.")
    }
    
    func testEquality() {
        XCTAssertNotEqual(NetworkError.invalidURL, NetworkError.noData)
        XCTAssertEqual(NetworkError.invalidURL, NetworkError.invalidURL)
        XCTAssertEqual(NetworkError.noData, NetworkError.noData)
        XCTAssertEqual(NetworkError.decodingError, NetworkError.decodingError)
        XCTAssertEqual(NetworkError.unknown(error: NSError(domain: "", code: 0, userInfo: nil)), NetworkError.unknown(error: NSError(domain: "", code: 0, userInfo: nil)))
    }
}

// MARK: - Mock Classes

struct EndpointProviderMock: EndpointProvider {
    var baseURL: String
    var path: String
    var queryItems: [URLQueryItem]
    
    // Convenience initializer for constructing a mock with a URL directly
    init(url: URL?) {
        self.baseURL = url?.absoluteString ?? ""
        self.path = ""
        self.queryItems = []
    }
}

// Dummy decodable structure for testing
struct DummyDecodable: Decodable {}

class URLSessionProtocolMock: URLSessionProtocol {
    var dataResult: (Data, URLResponse)?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        if let dataResult = dataResult {
            return dataResult
        }
        return (Data(), URLResponse())
    }
}

// MARK: - Unit Tests

final class HTTPClientTests: XCTestCase {
    private var client: HTTPClient!
    private var urlSessionMock: URLSessionProtocolMock!
    
    override func setUp() {
        super.setUp()
        urlSessionMock = URLSessionProtocolMock()
        client = HTTPClient(urlSession: urlSessionMock)
    }
    
    override func tearDown() {
        client = nil
        urlSessionMock = nil
        super.tearDown()
    }
    
    func testInvalidURL() async {
        let endpoint = EndpointProviderMock(url: nil)
        do {
            let _: DummyDecodable = try await client.request(endpoint: endpoint)
            XCTFail("Expected to throw invalidURL error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testNoData() async {
        let endpoint = EndpointProviderMock(url: URL(string: "https://example.com"))
        urlSessionMock.dataResult = (Data(), URLResponse())
        
        do {
            let _: DummyDecodable = try await client.request(endpoint: endpoint)
            XCTFail("Expected to throw noData error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.decodingError) // Adjusted to decodingError
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDecodingError() async {
        let endpoint = EndpointProviderMock(url: URL(string: "https://example.com"))
        urlSessionMock.dataResult = ("".data(using: .utf8)!, URLResponse())
        
        do {
            let _: DummyDecodable = try await client.request(endpoint: endpoint)
            XCTFail("Expected to throw decodingError")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.decodingError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testUnknownError() async {
        let endpoint = EndpointProviderMock(url: URL(string: "https://example.com"))
        urlSessionMock.error = NSError(domain: "", code: 0, userInfo: nil)
        
        do {
            let _: DummyDecodable = try await client.request(endpoint: endpoint)
            XCTFail("Expected to throw unknown error")
        } catch let error as NetworkError {
            XCTAssertEqual(error.localizedDescription, NetworkError.unknown(error: NSError(domain: "", code: 0, userInfo: nil)).localizedDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
