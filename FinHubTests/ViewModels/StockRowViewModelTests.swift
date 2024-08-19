//
//  StockRowViewModelTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
import Combine
@testable import FinHub

import XCTest
import Combine
@testable import FinHub

/// Unit tests for the `StockRowViewModel` class, verifying its behavior in various scenarios.
class StockRowViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: StockRowViewModel!
    private var mockAPIService: MockFinhubAPIService!
    
    /// Initializes the test environment before each test is executed.
    /// This method sets up a mock API service and creates an instance of `StockRowViewModel`.
    override func setUp() {
        super.setUp()
        
        // Create an instance of the mock API service
        mockAPIService = MockFinhubAPIService()
        
        // Create an instance of StockRowViewModel with a mock API service and a sample stock symbol
        viewModel = StockRowViewModel(
            finnhubAPI: mockAPIService,
            stock: StockSymbol(
                symbol: "AAPL",  // The stock symbol for Apple Inc.
                description: "Apple Inc.",  // The description of the stock
                currency: "USD",  // The currency of the stock
                displaySymbol: "AAPL",  // The display symbol of the stock
                figi: "BBG000B9XRY4",  // The FIGI identifier for the stock
                isin: "US0378331005",  // The ISIN identifier for the stock
                mic: "XNAS",  // The MIC code for the stock exchange
                shareClassFIGI: nil,  // Optional share class FIGI, not used here
                symbol2: nil,  // Optional second symbol, not used here
                type: "Common Stock"  // The type of stock
            )
        )
    }
    
    /// Cleans up the test environment after each test is executed.
    /// This method deallocates the view model and mock API service, and clears any subscriptions.
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    /// Tests the initialization of `StockRowViewModel` to ensure it is set up correctly.
    /// Verifies that the stock symbol and the 'isDetails' flag have the expected initial values.
    func testInitialization() {
        XCTAssertEqual(viewModel.stock.symbol, "AAPL", "The stock symbol should be 'AAPL' as initialized.")
        XCTAssertFalse(viewModel.isDetails, "The 'isDetails' flag should be false by default, indicating it's not in detail mode.")
    }
    
    /// Tests the successful fetching of company profile data from the API.
    /// Ensures that the view model correctly updates its `companyProfile` property with the expected data.
    func testFetchCompanyProfileSuccess() {
        // Arrange: Set up a dummy company profile to be returned by the mock API service
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
        
        // Act: Set up an expectation to verify that the company profile is loaded successfully
        let companyProfileExpectation = expectation(description: "Company profile should be loaded successfully from the API")
        
        // Observe changes to the `companyProfile` property
        viewModel.$companyProfile
            .dropFirst() // Skip the initial value to focus on the result of the fetch
            .sink { profile in
                if profile != nil {
                    // Verify that the received profile matches the expected dummy data
                    XCTAssertEqual(profile?.name, "Apple Inc.", "The company name should be 'Apple Inc.'")
                    XCTAssertEqual(profile?.ticker, "AAPL", "The ticker symbol should be 'AAPL'")
                    companyProfileExpectation.fulfill() // Fulfill the expectation once data is received
                }
            }
            .store(in: &cancellables)
        
        // Trigger the data fetch
        viewModel.prepareData()
        
        // Wait for expectations to be fulfilled or timeout
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    /// Tests the handling of errors when fetching company profile data from the API.
    /// Ensures that the view model correctly sets an error message when the API request fails.
    func testFetchCompanyProfileFailure() {
        // Arrange: Set up an error to be returned by the mock API service
        let error = NSError(domain: "TestErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch profile"])
        mockAPIService.mockData = .error(error)
        
        // Act: Set up an expectation to verify that the error message is correctly set
        let errorMessageExpectation = expectation(description: "Error message should be set when the API request fails")
        
        // Flag to ensure that the expectation is only fulfilled once
        var hasFulfilled = false
        
        // Observe changes to the `errorMessageCompanyProfile` property
        viewModel.$errorMessageCompanyProfile
            .dropFirst() // Skip the initial value to focus on the error result
            .sink { message in
                guard !hasFulfilled else { return } // Prevent multiple fulfillments
                if let errorMessage = message {
                    // Verify that the received error message matches the expected error
                    XCTAssertEqual(errorMessage, "Error: Failed to fetch profile", "The error message should match the expected error message.")
                    errorMessageExpectation.fulfill() // Fulfill the expectation once the error is received
                    hasFulfilled = true // Update flag to prevent multiple fulfillments
                }
            }
            .store(in: &cancellables)
        
        // Trigger the data fetch
        viewModel.prepareData()
        
        // Wait for expectations to be fulfilled or timeout
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    /// Tests the successful fetching of stock quote data when `isDetails` is set to true.
    /// Ensures that the view model correctly updates its `companyQuote` property with the expected stock quote data.
    func testFetchStockQuoteSuccessWhenDetailsTrue() {
        // Arrange: Set up a dummy stock quote to be returned by the mock API service
        let dummyQuote = StockQuote(c: 150.00, h: 155.00, l: 145.00, o: 148.00, pc: 149.00)
        mockAPIService.mockData = .stockQuote(dummyQuote)
        
        // Update view model to be in detail mode
        viewModel = StockRowViewModel(
            finnhubAPI: mockAPIService,
            stock: StockSymbol(
                symbol: "AAPL",
                description: "Apple Inc.",
                currency: "USD",
                displaySymbol: "AAPL",
                figi: "BBG000B9XRY4",
                isin: "US0378331005",
                mic: "XNAS",
                shareClassFIGI: nil,
                symbol2: nil,
                type: "Common Stock"
            ),
            isDetails: true
        )
        
        // Act: Set up an expectation to verify that the stock quote is loaded successfully
        let quoteExpectation = expectation(description: "Stock quote should be loaded successfully from the API")
        
        // Flag to ensure that the expectation is only fulfilled once
        var hasFulfilled = false
        
        // Observe changes to the `companyQuote` property
        viewModel.$companyQuote
            .dropFirst() // Skip the initial value to focus on the result of the fetch
            .sink { quote in
                guard !hasFulfilled else { return } // Prevent multiple fulfillments
                // Verify that the received quote matches the expected dummy data
                XCTAssertEqual(quote?.c, 150.00, "The current price should be 150.00")
                XCTAssertEqual(quote?.h, 155.00, "The highest price should be 155.00")
                XCTAssertEqual(quote?.l, 145.00, "The lowest price should be 145.00")
                XCTAssertEqual(quote?.o, 148.00, "The open price should be 148.00")
                XCTAssertEqual(quote?.pc, 149.00, "The previous close price should be 149.00")
                quoteExpectation.fulfill() // Fulfill the expectation once data is received
                hasFulfilled = true // Set flag to true to prevent further fulfillments
            }
            .store(in: &cancellables)
        
        // Trigger the data fetch
        viewModel.prepareData()
        
        // Wait for expectations to be fulfilled or timeout
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    /// Tests the handling of loading state when fetching company profile data.
    /// Ensures that the `loadingCompanyProfile` property is correctly updated during the data fetch.
    func testLoadingState() {
        // Arrange: Set up a dummy company profile to be returned by the mock API service
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
        // Act: Set up an expectation to verify that the loading state is correctly handled
        let loadingExpectation = expectation(description: "Loading state should be handled correctly during the data fetch")
        
        // Flag to ensure that the expectation is only fulfilled once
        var hasFulfilled = false
        
        // Observe changes to the `loadingCompanyProfile` property
        viewModel.$loadingCompanyProfile
            .dropFirst() // Skip the initial value to focus on the loading state
            .sink { isLoading in
                guard !hasFulfilled else { return } // Prevent multiple fulfillments
                if !isLoading {
                    // Verify that loading state is false when data is successfully fetched
                    XCTAssertFalse(isLoading, "Loading state should be false when data is loaded successfully.")
                    loadingExpectation.fulfill() // Fulfill the expectation once the loading state is updated
                    hasFulfilled = true // Update flag to prevent multiple fulfillments
                }
            }
            .store(in: &cancellables)
        
        // Trigger the data fetch
        viewModel.prepareData()
        
        // Wait for expectations to be fulfilled or timeout
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
