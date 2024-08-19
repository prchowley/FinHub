//
//  StockChartViewModel.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
import Combine
@testable import FinHub

// MARK: - StockChartViewModelTests

/// Unit tests for the `StockChartViewModel` class.
///
/// This test class validates the behavior and functionality of `StockChartViewModel`
/// under different conditions such as initial state, successful data loading, and handling of failures.
class StockChartViewModelTests: XCTestCase {

    /// A set of cancellables used to manage Combine subscriptions.
    var cancellables = Set<AnyCancellable>()

    /// Mock implementation of `AlphaVantageAPIService` used for testing.
    var mockAPIService: MockAlphaVantageAPIService!

    /// The view model under test.
    var viewModel: StockChartViewModel!

    override func setUp() {
        super.setUp()
        
        // Initialize the mock API service and view model before each test.
        mockAPIService = MockAlphaVantageAPIService()
        
        // Create a sample `StockSymbol` instance for testing.
        let stock = StockSymbol(
            symbol: "AAPL",
            description: "Apple Inc.",
            currency: "USD",
            displaySymbol: "AAPL",
            figi: "BBG000B9XRY4",
            isin: "US0378331005",
            mic: "XNAS",
            shareClassFIGI: nil,
            symbol2: nil,
            type: "Equity"
        )
        
        // Initialize the view model with the mock API service and sample stock data.
        viewModel = StockChartViewModel(alphaVantageAPI: mockAPIService, stock: stock)
    }

    override func tearDown() {
        // Clean up resources after each test.
        cancellables.removeAll()
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }

    /// Tests the initial state of the view model.
    ///
    /// Verifies that the initial loading state is not nil and that the stock data is empty.
    func testInitialState() {
        // Arrange
        let initialLoadingState = viewModel.loading
        let initialStockDataCount = viewModel.stockData.count
        
        // Assert
        XCTAssertNotNil(initialLoadingState, "Loading object should be present initially")
        XCTAssertTrue(initialStockDataCount == 0, "Stock data should be empty initially")
    }

    /// Tests successful graph data loading.
    ///
    /// Simulates a successful API response and verifies that the view model updates its stock data correctly.
    func testGraphDataSuccess() {
        // Arrange
        let metaData = MetaData(
            information: "Information",
            symbol: "AAPL",
            lastRefreshed: "2024-08-18",
            interval: "1min",
            outputSize: "Compact",
            timeZone: "US/Eastern"
        )
        
        let timeSeries = [
            AlphaGraphKeyType.interval(.min1): [
                "2024-08-18 09:00:00": GraphDataTimeSeries(
                    open: "175.00",
                    high: "177.00",
                    low: "174.50",
                    close: "176.00",
                    volume: "1000000"
                )
            ]
        ]
        
        let graphData = AlphaGraphData(metaData: metaData, timeSeries: timeSeries)
        mockAPIService.mockData = .success(graphData)
        
        // Act
        viewModel.vmPickerFrequency.selectedOption = .TIME_SERIES_INTRADAY
        viewModel.vmPickerInterval.selectedOption = .min1
        
        // Assert
        let expectation = self.expectation(description: "Data is loaded")
        var didFulfill = false
        
        viewModel.$stockData
            .dropFirst()
            .sink { dataPoints in
                guard !didFulfill else { return }
                didFulfill = true
                XCTAssertEqual(dataPoints.count, 1)
                
                if let firstDataPoint = dataPoints.first {
                    XCTAssertEqual(firstDataPoint.open, 175.00, accuracy: 0.01)
                    XCTAssertEqual(firstDataPoint.high, 177.00, accuracy: 0.01)
                    XCTAssertEqual(firstDataPoint.low, 174.50, accuracy: 0.01)
                    XCTAssertEqual(firstDataPoint.close, 176.00, accuracy: 0.01)
                    XCTAssertEqual(firstDataPoint.volume, 1000000.00, accuracy: 0.01)
                } else {
                    XCTFail("No data points were returned")
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    /// Tests failure in graph data loading.
    ///
    /// Simulates a failure response from the API and verifies that the view model handles the error correctly.
    func testGraphDataFailure() {
        // Arrange
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockAPIService.mockData = .error(.unknown(error: testError))
        
        // Act
        viewModel.vmPickerFrequency.selectedOption = .TIME_SERIES_INTRADAY
        viewModel.vmPickerInterval.selectedOption = .min1
        
        // Assert
        let expectation = self.expectation(description: "Data load failed")
        var isLoadingHandled = false
        var didFulfill = false
        
        viewModel.$loading
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                print("Loading state changed: \(isLoading)")
                
                if !isLoading {
                    if !isLoadingHandled {
                        isLoadingHandled = true
                        XCTAssertTrue(self.viewModel.stockData.isEmpty, "Stock data should be empty on failure")
                        if !didFulfill {
                            didFulfill = true
                            expectation.fulfill()
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
