//
//  StockQuoteTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import XCTest
@testable import FinHub

/// A test case to verify the initialization of the `StockQuote` model.
final class StockQuoteTests: XCTestCase {
    
    /// Tests the initialization of a `StockQuote` instance.
    ///
    /// This method creates a `StockQuote` instance with predefined values and
    /// verifies that all properties are correctly initialized.
    func testStockQuoteInitialization() {
        // Given: Define expected values for a stock quote.
        let expectedClose: Double = 150.0
        let expectedHigh: Double = 155.0
        let expectedLow: Double = 145.0
        let expectedOpen: Double = 148.0
        let expectedPreviousClose: Double = 148.0
        
        // When: Initialize a StockQuote instance with the expected values.
        let quote = StockQuote(c: expectedClose, h: expectedHigh, l: expectedLow, o: expectedOpen, pc: expectedPreviousClose)
        
        // Then: Verify that the initialized properties match the expected values.
        XCTAssertEqual(quote.c, expectedClose, "The 'close' price should be \(expectedClose).")
        XCTAssertEqual(quote.h, expectedHigh, "The 'high' price should be \(expectedHigh).")
        XCTAssertEqual(quote.l, expectedLow, "The 'low' price should be \(expectedLow).")
        XCTAssertEqual(quote.o, expectedOpen, "The 'open' price should be \(expectedOpen).")
        XCTAssertEqual(quote.pc, expectedPreviousClose, "The 'previous close' price should be \(expectedPreviousClose).")
    }
}
