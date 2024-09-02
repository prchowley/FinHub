//
//  FinHubAPIProviderTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

/// A test case to verify the functionality of `FinHubAPIProvider`.
final class FinHubAPIProviderTests: XCTestCase {
    
    /// The API provider under test.
    private var apiProvider: FinHubAPIProvider!
    
    /// A mock HTTP client used for testing.
    private var mockHTTPClient: MockHTTPClient!
    
    /// Sets up the test environment.
    ///
    /// This method is called before each test method in the class.
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        apiProvider = FinHubAPIProvider(httpClient: mockHTTPClient)
    }

    /// Tests the `fetchStockSymbols` method of `FinHubAPIProvider`.
    ///
    /// This test verifies that the method correctly fetches stock symbols
    /// and handles the result appropriately.
    func testFetchStockSymbols() async {
        // Arrange
        let expectedSymbols = [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: nil, isin: nil, mic: nil, shareClassFIGI: nil, symbol2: nil, type: "Equity")
        ]
        mockHTTPClient.mockData = .stockSymbols(expectedSymbols)
        
        // Act
        do {
            let symbols = try await apiProvider.fetchStockSymbols()
            // Assert
            XCTAssertEqual(symbols, expectedSymbols, "The fetched symbols should match the expected symbols.")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled, "The HTTP client should have made a request.")
    }

    /// Tests the `searchStocks` method of `FinHubAPIProvider`.
    ///
    /// This test verifies that the method correctly searches for stocks
    /// based on a query and handles the result appropriately.
    func testSearchStocks() async {
        // Arrange
        let query = "Apple"
        let expectedResult = StockSearchResult(count: 1, result: [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: nil, isin: nil, mic: nil, shareClassFIGI: nil, symbol2: nil, type: "Equity")
        ])
        mockHTTPClient.mockData = .stockSearchResult(expectedResult)
        
        // Act
        do {
            let searchResult = try await apiProvider.searchStocks(query: query)
            // Assert
            XCTAssertEqual(searchResult, expectedResult, "The search result should match the expected result.")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled, "The HTTP client should have made a request.")
    }

    /// Tests the `fetchCompanyProfile` method of `FinHubAPIProvider`.
    ///
    /// This test verifies that the method correctly fetches the company profile
    /// for a given symbol and handles the result appropriately.
    func testFetchCompanyProfile() async {
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
        do {
            let profile = try await apiProvider.fetchCompanyProfile(symbol: symbol)
            // Assert
            XCTAssertEqual(profile, expectedProfile, "The fetched profile should match the expected profile.")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled, "The HTTP client should have made a request.")
    }

    /// Tests the `fetchStockQuote` method of `FinHubAPIProvider`.
    ///
    /// This test verifies that the method correctly fetches the stock quote
    /// for a given symbol and handles the result appropriately.
    func testFetchStockQuote() async {
        // Arrange
        let symbol = "AAPL"
        let expectedQuote = StockQuote(c: 175.0, h: 180.0, l: 170.0, o: 172.0, pc: 174.0)
        mockHTTPClient.mockData = .stockQuote(expectedQuote)
        
        // Act
        do {
            let quote = try await apiProvider.fetchStockQuote(symbol: symbol)
            // Assert
            XCTAssertEqual(quote, expectedQuote, "The fetched quote should match the expected quote.")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
        
        // Assert
        XCTAssertTrue(mockHTTPClient.requestCalled, "The HTTP client should have made a request.")
    }
}
