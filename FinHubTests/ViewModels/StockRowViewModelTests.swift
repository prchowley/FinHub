//
//  StockRowViewModelTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
import Combine
@testable import FinHub

class StockRowViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: StockRowViewModel!
    private var mockAPIService: MockFinhubAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockFinhubAPIService()
        viewModel = StockRowViewModel(finnhubAPI: mockAPIService, stock: StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock"))
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(viewModel.stock.symbol, "AAPL")
        XCTAssertFalse(viewModel.isDetails)
    }
    
    func testFetchCompanyProfileSuccess() {
        // Arrange
        let dummyProfile = CompanyProfile(
            country: "US",
            currency: "USD",
            exchange: "NASDAQ",
            ipo: "1980-12-12",
            marketCapitalization: 2_000_000_000_000,
            name: "Apple Inc.",
            phone: "123-456-7890",
            shareOutstanding: 5_000_000_000,
            ticker: "AAPL",
            weburl: "https://www.apple.com",
            logo: "https://www.apple.com/logo.png",
            finnhubIndustry: "Technology"
        )
        mockAPIService.mockData = .companyProfile(dummyProfile)
        
        // Act
        let companyProfileExpectation = self.expectation(description: "Company profile is loaded")
        
        viewModel.$companyProfile
            .dropFirst() // Skip the initial value
            .sink { profile in
                if profile != nil {
                    XCTAssertEqual(profile?.name, "Apple Inc.")
                    XCTAssertEqual(profile?.ticker, "AAPL")
                    companyProfileExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Trigger fetch
        viewModel.prepareData()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchCompanyProfileFailure() {
        // Arrange
        let error = NSError(domain: "TestErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch profile"])
        mockAPIService.mockData = .error(error)
        
        // Act
        let errorMessageExpectation = self.expectation(description: "Error message is set")
        
        viewModel.$errorMessageCompanyProfile
            .dropFirst() // Skip the initial value
            .sink { message in
                if let errorMessage = message {
                    XCTAssertEqual(errorMessage, "Error: Failed to fetch profile")
                    errorMessageExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Trigger fetch
        viewModel.prepareData()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchStockQuoteSuccessWhenDetailsTrue() {
        // Arrange
        let dummyQuote = StockQuote(c: 150.00, h: 155.00, l: 145.00, o: 148.00, pc: 149.00)
        mockAPIService.mockData = .stockQuote(dummyQuote)
        viewModel = StockRowViewModel(finnhubAPI: mockAPIService, stock: StockSymbol(symbol: "AAPL", description: "Apple Inc.", currency: "USD", displaySymbol: "AAPL", figi: "BBG000B9XRY4", isin: "US0378331005", mic: "XNAS", shareClassFIGI: nil, symbol2: nil, type: "Common Stock"), isDetails: true)
        
        // Act
        let expectation = self.expectation(description: "Stock quote is loaded")
        
        viewModel.$companyQuote
            .dropFirst()
            .sink { quote in
                XCTAssertEqual(quote?.c, 150.00)
                XCTAssertEqual(quote?.h, 155.00)
                XCTAssertEqual(quote?.l, 145.00)
                XCTAssertEqual(quote?.o, 148.00)
                XCTAssertEqual(quote?.pc, 149.00)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLoadingState() {
        // Arrange
        let dummyProfile = CompanyProfile(
            country: "US",
            currency: "USD",
            exchange: "NASDAQ",
            ipo: "1980-12-12",
            marketCapitalization: 2_000_000_000_000,
            name: "Apple Inc.",
            phone: "123-456-7890",
            shareOutstanding: 5_000_000_000,
            ticker: "AAPL",
            weburl: "https://www.apple.com",
            logo: "https://www.apple.com/logo.png",
            finnhubIndustry: "Technology"
        )
        mockAPIService.mockData = .companyProfile(dummyProfile)
        
        // Act
        let loadingExpectation = self.expectation(description: "Loading state is handled")
        
        // Observe loading state
        viewModel.$loadingCompanyProfile
            .dropFirst() // Skip the initial value
            .sink { isLoading in
                if !isLoading {
                    XCTAssertFalse(isLoading, "Loading state should be false")
                    loadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Trigger fetch
        viewModel.prepareData()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
