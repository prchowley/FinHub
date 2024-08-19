//
//  StockDataTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import XCTest
@testable import FinHub

// Define a test class for StockData
class StockDataTests: XCTestCase {

    // Test initialization of StockData
    func testInitialization() {
        // Arrange: Create a date for testing
        let testDate = Date()
        
        // Define test values for StockData
        let testOpen: Double = 100.50
        let testHigh: Double = 105.75
        let testLow: Double = 98.20
        let testClose: Double = 102.30
        let testVolume: Double = 1_000_000.00
        
        // Act: Initialize StockData with test values
        let stockData = StockData(
            date: testDate,
            open: testOpen,
            high: testHigh,
            low: testLow,
            close: testClose,
            volume: testVolume
        )
        
        // Assert: Verify that all properties are set correctly
        XCTAssertEqual(stockData.date, testDate, "The date property should be set correctly.")
        XCTAssertEqual(stockData.open, testOpen, "The open property should be set correctly.")
        XCTAssertEqual(stockData.high, testHigh, "The high property should be set correctly.")
        XCTAssertEqual(stockData.low, testLow, "The low property should be set correctly.")
        XCTAssertEqual(stockData.close, testClose, "The close property should be set correctly.")
        XCTAssertEqual(stockData.volume, testVolume, "The volume property should be set correctly.")
        
        // Assert: Verify that the id property is set correctly
        XCTAssertNotNil(stockData.id, "The id property should be initialized and not nil.")
    }
    
    // Test default values of StockData
    func testDefaultValues() {
        // Arrange: Create a default StockData
        let defaultStockData = StockData(
            date: Date(),
            open: 0.0,
            high: 0.0,
            low: 0.0,
            close: 0.0,
            volume: 0.0
        )
        
        // Act: Create a StockData instance with default values
        let stockData = StockData(
            date: defaultStockData.date,
            open: defaultStockData.open,
            high: defaultStockData.high,
            low: defaultStockData.low,
            close: defaultStockData.close,
            volume: defaultStockData.volume
        )
        
        // Assert: Verify that all properties are set to default values
        XCTAssertEqual(stockData.date, defaultStockData.date, "The date property should be set to default value.")
        XCTAssertEqual(stockData.open, defaultStockData.open, "The open property should be set to default value.")
        XCTAssertEqual(stockData.high, defaultStockData.high, "The high property should be set to default value.")
        XCTAssertEqual(stockData.low, defaultStockData.low, "The low property should be set to default value.")
        XCTAssertEqual(stockData.close, defaultStockData.close, "The close property should be set to default value.")
        XCTAssertEqual(stockData.volume, defaultStockData.volume, "The volume property should be set to default value.")
    }
}
