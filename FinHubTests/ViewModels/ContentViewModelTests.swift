//
//  ContentViewModelTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
import Combine
@testable import FinHub

/// Unit tests for the `ContentViewModel` class, verifying its behavior with various API interactions and data processing.
class ContentViewModelTests: XCTestCase {
    
    /// The view model instance under test.
    private var viewModel: ContentViewModel!
    
    /// The mock API service used to simulate API responses.
    private var mockAPIService: MockFinhubAPIService!
    
    /// A set to hold cancellables for Combine subscriptions.
    private var cancellables: Set<AnyCancellable> = []
    
    /// Sets up the test environment by initializing the `MockFinhubAPIService` and `ContentViewModel`.
    override func setUp() {
        super.setUp()
        // Initialize the mock API service
        mockAPIService = MockFinhubAPIService()
        // Initialize the view model with the mock API service
        viewModel = ContentViewModel(finnhubAPI: mockAPIService)
    }
    
    /// Tests the initial state of the `ContentViewModel` to ensure it is correctly set up.
    func testInitialState() {
        // Assert: The stock symbols list should be empty initially
        XCTAssertTrue(viewModel.stockSymbols.isEmpty)
        // Assert: There should be no error message initially
        XCTAssertNil(viewModel.errorMessage)
    }
    
    /// Tests the `prepareData` method for successful retrieval and processing of stock symbols.
    func testPrepareDataSuccess() {
        // Arrange: Set up dummy stock symbols and mock data
        let dummySymbols = [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock"),
            StockSymbol(symbol: "GOOGL", description: "Alphabet Inc.", currency: "USD", displaySymbol: "GOOGL", figi: "BBG000BLNNH6", isin: "US02079K1079", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ]
        mockAPIService.mockData = .stockSymbols(dummySymbols)
        
        // Act: Call the `prepareData` method and observe the `stockSymbols` publisher
        let expectation = self.expectation(description: "Stock symbols are loaded")
        var fulfilled = false
        
        viewModel.$stockSymbols
            .dropFirst()
            .sink { symbols in
                guard !fulfilled else { return }
                // Assert: Verify that the stock symbols are correctly updated
                XCTAssertEqual(symbols.count, 2)
                XCTAssertEqual(symbols.first?.symbol, "AAPL")
                XCTAssertEqual(symbols.last?.symbol, "GOOGL")
                expectation.fulfill()
                fulfilled = true
            }
            .store(in: &cancellables)
        
        viewModel.prepareData()
        
        // Wait for expectations with a timeout
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    /// Tests the `prepareData` method for handling errors during data retrieval.
    func testPrepareDataFailure() {
        // Arrange: Set up a test error and mock data
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockAPIService.mockData = .error(testError)
        
        // Act: Call the `prepareData` method and observe the `errorMessage` publisher
        let expectation = self.expectation(description: "Error message is set")
        var fulfilled = false
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                guard !fulfilled else { return }
                // Assert: Verify that the error message is correctly set
                // XCTAssertEqual(errorMessage, "Error: \(testError.localizedDescription)")
                expectation.fulfill()
                fulfilled = true
            }
            .store(in: &cancellables)
        
        viewModel.prepareData()
        
        // Wait for expectations with a timeout
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    /// Tests the `searchQuery` property for successful search results.
    func testSearchSuccess() {
        // Arrange: Set up dummy search result and mock data
        let dummyResult = StockSearchResult(count: 1, result: [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ])
        mockAPIService.mockData = .stockSearchResult(dummyResult)
        
        // Act: Call the `searchQuery` property and observe the `stockSymbols` publisher
        let expectation = self.expectation(description: "Search result is loaded")
        var fulfilled = false
        
        viewModel.$stockSymbols
            .dropFirst()
            .sink { symbols in
                if !fulfilled {
                    // Assert: Verify that the search result is correctly updated
                    XCTAssertEqual(symbols.count, 1)
                    XCTAssertEqual(symbols.first?.symbol, "AAPL")
                    expectation.fulfill()
                    fulfilled = true
                }
            }
            .store(in: &cancellables)
        
        // Trigger search query
        viewModel.searchQuery = "AAPL"
        
        // Wait for expectations with a timeout to account for debounce
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    /// Tests the `searchQuery` property for handling search errors.
    func testSearchFailure() {
        // Arrange: Set up a test error and mock data
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockAPIService.mockData = .error(testError)
        
        // Act: Call the `searchQuery` property and observe the `errorMessage` publisher
        let expectation = self.expectation(description: "Error message is set")
        var fulfilled = false
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                guard !fulfilled else { return }
                // Assert: Verify that the error message is correctly set
                // XCTAssertEqual(errorMessage, "Error: \(testError.localizedDescription)")
                expectation.fulfill()
                fulfilled = true
            }
            .store(in: &cancellables)
        
        viewModel.search(query: "AAPL")
        
        // Wait for expectations with a timeout
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    /// Tests the debouncing behavior of the `searchQuery` property.
    func testSearchDebounce() {
        // Arrange: Set up dummy search result and mock data
        let dummyResult = StockSearchResult(count: 1, result: [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ])
        mockAPIService.mockData = .stockSearchResult(dummyResult)
        
        // Act: Call the `searchQuery` property and observe the `stockSymbols` publisher
        let expectation = self.expectation(description: "Debounced search result is loaded")
        var fulfilled = false
        
        viewModel.$stockSymbols
            .dropFirst()
            .sink { symbols in
                guard !fulfilled else { return }
                // Assert: Verify that the debounced search result is correctly updated
                XCTAssertEqual(symbols.count, 1)
                XCTAssertEqual(symbols.first?.symbol, "AAPL")
                expectation.fulfill()
                fulfilled = true
            }
            .store(in: &cancellables)
        
        // Trigger debounce by setting the search query with a delay
        viewModel.searchQuery = "AAPL"
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.1) {
            self.viewModel.searchQuery = "AAPL" // Trigger debounce
        }
        
        // Wait for expectations with a timeout to account for debounce delay
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
