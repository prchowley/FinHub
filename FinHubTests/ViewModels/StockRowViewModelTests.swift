//
//  StockRowViewModelTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
import Combine
@testable import FinHub

final class StockRowViewModelTests: XCTestCase {

    private var viewModel: StockRowViewModel!
    private var mockFinhubAPI: MockFinhubAPIService!

    @MainActor override func setUp() {
        super.setUp()
        mockFinhubAPI = MockFinhubAPIService()
        let stockSymbol = StockSymbol(
            symbol: "AAPL",
            description: "Apple Inc.",
            currency: "USD",
            displaySymbol: "AAPL",
            figi: "BBG000B9XRY4",
            isin: "US0378331005",
            mic: "XNAS",
            shareClassFIGI: "BBG0013HJJW5",
            symbol2: nil,
            type: "Equity"
        )
        viewModel = StockRowViewModel(finnhubAPI: mockFinhubAPI, stock: stockSymbol, isDetails: true)
    }

    override func tearDown() {
        viewModel = nil
        mockFinhubAPI = nil
        super.tearDown()
    }

    @MainActor
    func testFetchCompanyProfileSuccess() async {
        // Given
        let companyProfile = CompanyProfile(
            country: "USA",
            currency: "USD",
            exchange: "NASDAQ",
            ipo: "1980-12-12",
            marketCapitalization: 2500000000.00,
            name: "Apple Inc.",
            phone: "+1-800-275-2273",
            shareOutstanding: 5000000000.00,
            ticker: "AAPL",
            weburl: "https://www.apple.com",
            logo: "https://www.apple.com/logo.png",
            finnhubIndustry: "Technology"
        )
        mockFinhubAPI.mockData = .companyProfile(companyProfile)
        
        // When
        await viewModel.fetchCompanyProfile()

        // Then
        XCTAssertFalse(viewModel.loadingCompanyProfile)
        XCTAssertEqual(viewModel.companyProfile, companyProfile)
        XCTAssertNil(viewModel.errorMessageCompanyProfile)
    }

    @MainActor
    func testFetchStockQuoteSuccess() async {
        // Given
        let stockQuote = StockQuote(
            c: 150.00,
            h: 155.00,
            l: 145.00,
            o: 148.00,
            pc: 149.00
        )
        mockFinhubAPI.mockData = .stockQuote(stockQuote)
        
        // When
        await viewModel.fetchStockQuote()

        // Then
        XCTAssertFalse(viewModel.loadingStockQuote)
        XCTAssertEqual(viewModel.companyQuote, stockQuote)
        XCTAssertNil(viewModel.errorMessageStockQuote)
    }

    @MainActor
    func testFetchCompanyProfileFailure() async {
        // Given
        mockFinhubAPI.mockData = .error(NSError(domain: "TestError", code: 0, userInfo: nil))
        
        // When
        await viewModel.fetchCompanyProfile()

        // Then
        XCTAssertFalse(viewModel.loadingCompanyProfile)
        XCTAssertNil(viewModel.companyProfile)
        XCTAssertEqual(viewModel.errorMessageCompanyProfile, "Error: Failed to fetch profile")
    }

    @MainActor
    func testFetchStockQuoteFailure() async {
        // Given
        mockFinhubAPI.mockData = .error(NSError(domain: "TestError", code: 0, userInfo: nil))
        
        // When
        await viewModel.fetchStockQuote()

        // Then
        XCTAssertFalse(viewModel.loadingStockQuote)
        XCTAssertNil(viewModel.companyQuote)
        XCTAssertEqual(viewModel.errorMessageStockQuote, "Error: Failed to fetch stock quote")
    }

    @MainActor
    func testPrepareDataWithoutDetails() async {
        // Given
        let companyProfile = CompanyProfile(
            country: "USA",
            currency: "USD",
            exchange: "NASDAQ",
            ipo: "1980-12-12",
            marketCapitalization: 2500000000.00,
            name: "Apple Inc.",
            phone: "+1-800-275-2273",
            shareOutstanding: 5000000000.00,
            ticker: "AAPL",
            weburl: "https://www.apple.com",
            logo: "https://www.apple.com/logo.png",
            finnhubIndustry: "Technology"
        )
        mockFinhubAPI.mockData = .companyProfile(companyProfile)
        let stockSymbol = StockSymbol(
            symbol: "AAPL",
            description: "Apple Inc.",
            currency: "USD",
            displaySymbol: "AAPL",
            figi: "BBG000B9XRY4",
            isin: "US0378331005",
            mic: "XNAS",
            shareClassFIGI: "BBG0013HJJW5",
            symbol2: nil,
            type: "Equity"
        )
        
        viewModel = StockRowViewModel(finnhubAPI: mockFinhubAPI, stock: stockSymbol, isDetails: false)
        
        // When
        await viewModel.prepareData()

        // Then
        XCTAssertFalse(viewModel.loadingCompanyProfile)
        XCTAssertEqual(viewModel.companyProfile, companyProfile)
        XCTAssertNil(viewModel.companyQuote)
        XCTAssertNil(viewModel.errorMessageCompanyProfile)
        XCTAssertNil(viewModel.errorMessageStockQuote)
    }

    @MainActor
    func testPrepareDataWithNoMockData() async {
        // When
        await viewModel.prepareData()

        // Then
        XCTAssertFalse(viewModel.loadingCompanyProfile)
        XCTAssertFalse(viewModel.loadingStockQuote)
        XCTAssertNil(viewModel.companyProfile)
        XCTAssertNil(viewModel.companyQuote)
        XCTAssertEqual(viewModel.errorMessageCompanyProfile, "Error: Failed to fetch profile")
        XCTAssertEqual(viewModel.errorMessageStockQuote, "Error: Failed to fetch stock quote")
    }
}
