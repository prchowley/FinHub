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
    @MainActor 
    override func setUp() async throws {
        try await super.setUp()
        // Initialize the mock API service
        mockAPIService = MockFinhubAPIService()
        // Initialize the view model with the mock API service
        viewModel = ContentViewModel(finnhubAPI: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    /// Tests the initial state of the `ContentViewModel` to ensure it is correctly set up.
    @MainActor 
    func testInitialState() async {
        // Assert: The stock symbols list should be empty initially
        XCTAssertTrue(viewModel.stockSymbols.isEmpty)
        // Assert: There should be no error message initially
        XCTAssertNil(viewModel.errorMessage)
    }
    
    /// Tests the `prepareData` method for successful retrieval and processing of stock symbols.
    @MainActor 
    func testPrepareDataSuccess() async {
        // Arrange: Set up dummy stock symbols and mock data
        let dummySymbols = [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock"),
            StockSymbol(symbol: "GOOGL", description: "Alphabet Inc.", currency: "USD", displaySymbol: "GOOGL", figi: "BBG000BLNNH6", isin: "US02079K1079", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ]
        mockAPIService.mockData = .stockSymbols(dummySymbols)
        
        // Act: Call the `prepareData` method and observe the `stockSymbols` publisher
        let expectation = self.expectation(description: "Stock symbols are loaded")
        
        await viewModel.prepareData()
        
        // Assert: Verify that the stock symbols are correctly updated
        XCTAssertEqual(viewModel.stockSymbols.count, 2)
        XCTAssertEqual(viewModel.stockSymbols.first?.symbol, "AAPL")
        XCTAssertEqual(viewModel.stockSymbols.last?.symbol, "GOOGL")
        // Assert: Verify that loading state is false after data is loaded
        XCTAssertFalse(viewModel.isLoading)
        expectation.fulfill()
        
        // Wait for expectations with a timeout
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    /// Tests the `prepareData` method for handling errors during data retrieval.
    @MainActor 
    func testPrepareDataFailure() async {
        // Arrange: Set up a test error and mock data
        mockAPIService.mockData = .error(NetworkError.noData)
        
        // Act: Call the `prepareData` method and observe the `errorMessage` publisher
        let expectation = self.expectation(description: "Error message is set")
        
        await viewModel.prepareData()
        
        // Assert: Verify that loading state is false after error occurs
        XCTAssertFalse(viewModel.isLoading)
        expectation.fulfill()
        
        // Wait for expectations with a timeout
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    /// Tests the `searchQuery` property for successful search results.
    @MainActor 
    func testSearchSuccess() async {
        // Arrange: Set up dummy search result and mock data
        let dummyResult = StockSearchResult(count: 1, result: [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ])
        mockAPIService.mockData = .stockSearchResult(dummyResult)
        
        // Act: Call the `searchQuery` property and observe the `stockSymbols` publisher
        let expectation = self.expectation(description: "Search result is loaded")
        
        viewModel.searchQuery = "AAPL"
        
        // Assert: Verify that loading state is false after search is completed
        XCTAssertFalse(viewModel.isLoading)
        expectation.fulfill()
        
        // Wait for expectations with a timeout to account for debounce
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    /// Tests the `searchQuery` property for handling search errors.
    @MainActor 
    func testSearchFailure() async {
        // Arrange: Set up a test error and mock data
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockAPIService.mockData = .error(testError)
        
        // Act: Call the `searchQuery` property and observe the `errorMessage` publisher
        let expectation = self.expectation(description: "Error message is set")
        
        viewModel.searchQuery = "AAPL"
        
        // Assert: Verify that loading state is false after error occurs
        XCTAssertFalse(viewModel.isLoading)
        expectation.fulfill()
        
        // Wait for expectations with a timeout
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    /// Tests the debouncing behavior of the `searchQuery` property.
    @MainActor 
    func testSearchDebounce() async {
        // Arrange: Set up dummy search result and mock data
        let dummyResult = StockSearchResult(count: 1, result: [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ])
        mockAPIService.mockData = .stockSearchResult(dummyResult)
        
        // Act: Call the `searchQuery` property and observe the `stockSymbols` publisher
        let expectation = self.expectation(description: "Debounced search result is loaded")
        
        viewModel.searchQuery = "AAPL"
        // Simulate debounce delay
        do {
            try await Task.sleep(nanoseconds: 4_100_000_000) // 4.1 seconds
            viewModel.searchQuery = "AAPL" // Trigger debounce
        } catch {
            XCTFail("Task.sleep threw an error: \(error.localizedDescription)")
        }
        
        // Assert: Verify that the debounced search result is correctly updated
        XCTAssertEqual(viewModel.stockSymbols.count, 1)
        XCTAssertEqual(viewModel.stockSymbols.first?.symbol, "AAPL")
        // Assert: Verify that loading state is false after debounced search is completed
        XCTAssertFalse(viewModel.isLoading)
        expectation.fulfill()
        
        // Wait for expectations with a timeout to account for debounce delay
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
