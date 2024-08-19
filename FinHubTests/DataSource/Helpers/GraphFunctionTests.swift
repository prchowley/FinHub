//
//  GraphFunctionTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

class GraphFunctionTests: XCTestCase {

    func testGetIntervals() {
        XCTAssertEqual(GraphFunction.TIME_SERIES_INTRADAY.getIntervals(), [.min1, .min5, .min15, .min30, .min60])
        XCTAssertNil(GraphFunction.TIME_SERIES_DAILY.getIntervals())
        XCTAssertNil(GraphFunction.TIME_SERIES_WEEKLY.getIntervals())
        XCTAssertNil(GraphFunction.TIME_SERIES_MONTHLY.getIntervals())
    }
    
    func testCaseIterable() {
        let allCases = GraphFunction.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.TIME_SERIES_INTRADAY))
        XCTAssertTrue(allCases.contains(.TIME_SERIES_DAILY))
        XCTAssertTrue(allCases.contains(.TIME_SERIES_WEEKLY))
        XCTAssertTrue(allCases.contains(.TIME_SERIES_MONTHLY))
    }
    
    func testIdentifiable() {
        XCTAssertEqual(GraphFunction.TIME_SERIES_INTRADAY.id, .TIME_SERIES_INTRADAY)
        XCTAssertEqual(GraphFunction.TIME_SERIES_DAILY.id, .TIME_SERIES_DAILY)
        XCTAssertEqual(GraphFunction.TIME_SERIES_WEEKLY.id, .TIME_SERIES_WEEKLY)
        XCTAssertEqual(GraphFunction.TIME_SERIES_MONTHLY.id, .TIME_SERIES_MONTHLY)
    }
    
    func testCustomStringConvertible() {
        XCTAssertEqual(GraphFunction.TIME_SERIES_INTRADAY.description, "Intra-Day")
        XCTAssertEqual(GraphFunction.TIME_SERIES_DAILY.description, "Daily")
        XCTAssertEqual(GraphFunction.TIME_SERIES_WEEKLY.description, "Weekly")
        XCTAssertEqual(GraphFunction.TIME_SERIES_MONTHLY.description, "Monthly")
    }
}
