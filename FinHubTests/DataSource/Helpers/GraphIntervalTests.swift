//
//  GraphIntervalTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

class GraphIntervalTests: XCTestCase {

    func testAllCases() {
        let allCases = GraphInterval.allCases
        XCTAssertEqual(allCases.count, 5)
        XCTAssertTrue(allCases.contains(.min1))
        XCTAssertTrue(allCases.contains(.min5))
        XCTAssertTrue(allCases.contains(.min15))
        XCTAssertTrue(allCases.contains(.min30))
        XCTAssertTrue(allCases.contains(.min60))
    }
    
    func testIdentifiable() {
        XCTAssertEqual(GraphInterval.min1.id, .min1)
        XCTAssertEqual(GraphInterval.min5.id, .min5)
        XCTAssertEqual(GraphInterval.min15.id, .min15)
        XCTAssertEqual(GraphInterval.min30.id, .min30)
        XCTAssertEqual(GraphInterval.min60.id, .min60)
    }
    
    func testDescription() {
        XCTAssertEqual(GraphInterval.min1.description, "1 Min")
        XCTAssertEqual(GraphInterval.min5.description, "5 Mins")
        XCTAssertEqual(GraphInterval.min15.description, "15 Mins")
        XCTAssertEqual(GraphInterval.min30.description, "30 Mins")
        XCTAssertEqual(GraphInterval.min60.description, "60 Mins")
    }
    
    func testRawValues() {
        XCTAssertEqual(GraphInterval.min1.rawValue, "1min")
        XCTAssertEqual(GraphInterval.min5.rawValue, "5min")
        XCTAssertEqual(GraphInterval.min15.rawValue, "15min")
        XCTAssertEqual(GraphInterval.min30.rawValue, "30min")
        XCTAssertEqual(GraphInterval.min60.rawValue, "60min")
    }
}
