//
//  StockChartViewModel.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
import Combine
@testable import FinHub

class StockChartViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var mockAPIService: MockAlphaVantageAPIService!
    var viewModel: StockChartViewModel!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAlphaVantageAPIService()
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
        viewModel = StockChartViewModel(alphaVantageAPI: mockAPIService, stock: stock)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Arrange
        let initialLoadingState = viewModel.loading
        let initialStockDataCount = viewModel.stockData.count
        
        // Assert
        XCTAssertNotNil(initialLoadingState, "Loading object should be there initially")
        XCTAssertTrue(initialStockDataCount == 0, "Stock data should be empty initially")
    }
    
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
    
    func testGraphDataFailure() {
        // Arrange
        let testError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockAPIService.mockData = .error(testError)
        
        // Act
        viewModel.vmPickerFrequency.selectedOption = .TIME_SERIES_INTRADAY
        viewModel.vmPickerInterval.selectedOption = .min1
        
        // Wait for the data to be processed
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
