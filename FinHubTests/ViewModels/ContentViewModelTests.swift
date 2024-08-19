//
//  ContentViewModelTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
import Combine
@testable import FinHub

class ContentViewModelTests: XCTestCase {
    private var viewModel: ContentViewModel!
    private var mockAPIService: MockFinhubAPIService!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockFinhubAPIService()
        viewModel = ContentViewModel(finnhubAPI: mockAPIService)
    }
    
    func testInitialState() {
//        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.stockSymbols.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testPrepareDataSuccess() {
        // Arrange
        let dummySymbols = [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock"),
            StockSymbol(symbol: "GOOGL", description: "Alphabet Inc.", currency: "USD", displaySymbol: "GOOGL", figi: "BBG000BLNNH6", isin: "US02079K1079", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ]
        mockAPIService.mockData = .stockSymbols(dummySymbols)
        
        // Act
        let expectation = self.expectation(description: "Stock symbols are loaded")
        var fulfilled = false
        
        viewModel.$stockSymbols
            .dropFirst()
            .sink { symbols in
                guard !fulfilled else { return }
                XCTAssertEqual(symbols.count, 2)
                XCTAssertEqual(symbols.first?.symbol, "AAPL")
                XCTAssertEqual(symbols.last?.symbol, "GOOGL")
                expectation.fulfill()
                fulfilled = true
            }
            .store(in: &cancellables)
        
        viewModel.prepareData()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testPrepareDataFailure() {
        // Arrange
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockAPIService.mockData = .error(testError)
        
        // Act
        let expectation = self.expectation(description: "Error message is set")
        var fulfilled = false
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                guard !fulfilled else { return }
//                XCTAssertEqual(errorMessage, "Error: \(testError.localizedDescription)")
                expectation.fulfill()
                fulfilled = true
            }
            .store(in: &cancellables)
        
        viewModel.prepareData()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSearchSuccess() {
        // Arrange
        let dummyResult = StockSearchResult(count: 1, result: [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ])
        mockAPIService.mockData = .stockSearchResult(dummyResult)
        
        // Act
        let expectation = self.expectation(description: "Search result is loaded")
        
        // Ensure we only fulfill the expectation once
        var fulfilled = false
        
        // Setup subscription
        viewModel.$stockSymbols
            .dropFirst()
            .sink { symbols in
                if !fulfilled {
                    XCTAssertEqual(symbols.count, 1)
                    XCTAssertEqual(symbols.first?.symbol, "AAPL")
                    expectation.fulfill()
                    fulfilled = true
                }
            }
            .store(in: &cancellables)
        
        // Trigger search query
        viewModel.searchQuery = "AAPL"
        
        // Adjust the timeout to be long enough to account for debounce
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSearchFailure() {
        // Arrange
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockAPIService.mockData = .error(testError)
        
        // Act
        let expectation = self.expectation(description: "Error message is set")
        var fulfilled = false
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                guard !fulfilled else { return }
//                XCTAssertEqual(errorMessage, "Error: \(testError.localizedDescription)")
                expectation.fulfill()
                fulfilled = true
            }
            .store(in: &cancellables)
        
        viewModel.search(query: "AAPL")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSearchDebounce() {
        // Arrange
        let dummyResult = StockSearchResult(count: 1, result: [
            StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock")
        ])
        mockAPIService.mockData = .stockSearchResult(dummyResult)
        
        // Act
        let expectation = self.expectation(description: "Debounced search result is loaded")
        var fulfilled = false
        
        viewModel.$stockSymbols
            .dropFirst()
            .sink { symbols in
                guard !fulfilled else { return }
                XCTAssertEqual(symbols.count, 1)
                XCTAssertEqual(symbols.first?.symbol, "AAPL")
                expectation.fulfill()
                fulfilled = true
            }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "AAPL"
        
        // Wait for debounce
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.1) {
            self.viewModel.searchQuery = "AAPL" // Trigger debounce
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
