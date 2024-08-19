//
//  FinHubAPIProviderTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

class FinHubAPIProviderTests: XCTestCase {
    var apiProvider: FinHubAPIProvider!
    var mockHTTPClient: MockHTTPClient!
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        apiProvider = FinHubAPIProvider(httpClient: mockHTTPClient)
    }

    func testFetchStockSymbols() {
        // Arrange
        let expectedSymbols = [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: nil, isin: nil, mic: nil, shareClassFIGI: nil, symbol2: nil, type: "Equity")
        ]
        mockHTTPClient.mockData = .stockSymbols(expectedSymbols)
        
        // Act
        apiProvider.fetchStockSymbols { result in
            switch result {
            case .success(let symbols):
                XCTAssertEqual(symbols, expectedSymbols)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled)
    }

    func testSearchStocks() {
        // Arrange
        let query = "Apple"
        let expectedResult = StockSearchResult(count: 1, result: [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: nil, isin: nil, mic: nil, shareClassFIGI: nil, symbol2: nil, type: "Equity")
        ])
        mockHTTPClient.mockData = .stockSearchResult(expectedResult)
        
        // Act
        apiProvider.searchStocks(query: query) { result in
            switch result {
            case .success(let searchResult):
                XCTAssertEqual(searchResult, expectedResult)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled)
    }

    func testFetchCompanyProfile() {
        // Arrange
        let symbol = "AAPL"
        let expectedProfile = CompanyProfile(
            country: "USA",
            currency: "USD",
            exchange: "NASDAQ",
            ipo: "1980-12-12",
            marketCapitalization: 2500000000000,
            name: "Apple Inc.",
            phone: "+1-408-996-1010",
            shareOutstanding: 5000000000,
            ticker: "AAPL",
            weburl: "https://www.apple.com",
            logo: "https://example.com/logo.png",
            finnhubIndustry: "Technology"
        )
        mockHTTPClient.mockData = .companyProfile(expectedProfile)
        
        // Act
        apiProvider.fetchCompanyProfile(symbol: symbol) { result in
            switch result {
            case .success(let profile):
                XCTAssertEqual(profile, expectedProfile)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled)
    }

    func testFetchStockQuote() {
        // Arrange
        let symbol = "AAPL"
        let expectedQuote = StockQuote(c: 175.0, h: 180.0, l: 170.0, o: 172.0, pc: 174.0)
        mockHTTPClient.mockData = .stockQuote(expectedQuote)
        
        // Act
        apiProvider.fetchStockQuote(symbol: symbol) { result in
            switch result {
            case .success(let quote):
                XCTAssertEqual(quote, expectedQuote)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled)
    }
}
