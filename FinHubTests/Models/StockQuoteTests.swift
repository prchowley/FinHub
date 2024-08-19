//
//  StockQuoteTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import XCTest
@testable import FinHub

final class StockQuoteTests: XCTestCase {
    
    func testStockQuoteInitialization() {
        let quote = StockQuote(c: 150.0, h: 155.0, l: 145.0, o: 148.0, pc: 148.0)
        
        XCTAssertEqual(quote.c, 150.0)
        XCTAssertEqual(quote.h, 155.0)
        XCTAssertEqual(quote.l, 145.0)
        XCTAssertEqual(quote.o, 148.0)
        XCTAssertEqual(quote.pc, 148.0)
    }
}
