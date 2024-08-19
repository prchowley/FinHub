//
//  FinnhubEndpointTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

class FinnhubEndpointTests: XCTestCase {
    
    private class MockKeyService: KeyService {
        func get(for type: FinHub.KeyType) -> String {
            return "mock_api_key"
        }
        
        func save(token: String, for type: FinHub.KeyType) { }
    }

    private let mockKeyService = MockKeyService()
    
    func testStockSymbolsEndpoint() {
          let endpoint = FinnhubEndpoint(endpointType: .stockSymbols, keyService: mockKeyService)
          let request = endpoint.urlRequest()
          
          XCTAssertNotNil(request)
          XCTAssertEqual(request?.url?.absoluteString, "https://finnhub.io/api/v1/stock/symbol?token=mock_api_key&exchange=US&currency=USD")
      }
      
      func testSearchEndpoint() {
          let query = "AAPL"
          let endpoint = FinnhubEndpoint(endpointType: .search(query: query), keyService: mockKeyService)
          let request = endpoint.urlRequest()
          
          XCTAssertNotNil(request)
          XCTAssertEqual(request?.url?.absoluteString, "https://finnhub.io/api/v1/search?token=mock_api_key&q=\(query)")
      }
      
      func testCompanyProfileEndpoint() {
          let symbol = "AAPL"
          let endpoint = FinnhubEndpoint(endpointType: .companyProfile(symbol: symbol), keyService: mockKeyService)
          let request = endpoint.urlRequest()
          
          XCTAssertNotNil(request)
          XCTAssertEqual(request?.url?.absoluteString, "https://finnhub.io/api/v1/stock/profile2?token=mock_api_key&symbol=\(symbol)")
      }
      
      func testQuoteEndpoint() {
          let symbol = "AAPL"
          let endpoint = FinnhubEndpoint(endpointType: .quote(symbol: symbol), keyService: mockKeyService)
          let request = endpoint.urlRequest()
          
          XCTAssertNotNil(request)
          XCTAssertEqual(request?.url?.absoluteString, "https://finnhub.io/api/v1/quote?token=mock_api_key&symbol=\(symbol)")
      }
}
