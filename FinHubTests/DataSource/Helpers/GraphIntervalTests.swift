//
//  GraphIntervalTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

/// Unit tests for `GraphInterval` functionality.
class GraphIntervalTests: XCTestCase {

    /// Tests the `allCases` property of `GraphInterval`.
    func testAllCases() {
        // Get all cases of GraphInterval
        let allCases = GraphInterval.allCases
        // Verify that the number of cases is 5
        XCTAssertEqual(allCases.count, 5, "Expected GraphInterval.allCases to have 5 cases")
        // Verify that all expected cases are present
        XCTAssertTrue(allCases.contains(.min1), "Expected .allCases to contain .min1")
        XCTAssertTrue(allCases.contains(.min5), "Expected .allCases to contain .min5")
        XCTAssertTrue(allCases.contains(.min15), "Expected .allCases to contain .min15")
        XCTAssertTrue(allCases.contains(.min30), "Expected .allCases to contain .min30")
        XCTAssertTrue(allCases.contains(.min60), "Expected .allCases to contain .min60")
    }
    
    /// Tests the `Identifiable` conformance of `GraphInterval`.
    func testIdentifiable() {
        // Verify that the id property returns the correct values
        XCTAssertEqual(GraphInterval.min1.id, .min1, "Expected .id for min1 to be .min1")
        XCTAssertEqual(GraphInterval.min5.id, .min5, "Expected .id for min5 to be .min5")
        XCTAssertEqual(GraphInterval.min15.id, .min15, "Expected .id for min15 to be .min15")
        XCTAssertEqual(GraphInterval.min30.id, .min30, "Expected .id for min30 to be .min30")
        XCTAssertEqual(GraphInterval.min60.id, .min60, "Expected .id for min60 to be .min60")
    }
    
    /// Tests the `CustomStringConvertible` conformance of `GraphInterval`.
    func testDescription() {
        // Verify that the description property returns the correct values
        XCTAssertEqual(GraphInterval.min1.description, "1 Min", "Expected .description for min1 to be '1 Min'")
        XCTAssertEqual(GraphInterval.min5.description, "5 Mins", "Expected .description for min5 to be '5 Mins'")
        XCTAssertEqual(GraphInterval.min15.description, "15 Mins", "Expected .description for min15 to be '15 Mins'")
        XCTAssertEqual(GraphInterval.min30.description, "30 Mins", "Expected .description for min30 to be '30 Mins'")
        XCTAssertEqual(GraphInterval.min60.description, "60 Mins", "Expected .description for min60 to be '60 Mins'")
    }
    
    /// Tests the `rawValue` property of `GraphInterval`.
    func testRawValues() {
        // Verify that the rawValue property returns the correct values
        XCTAssertEqual(GraphInterval.min1.rawValue, "1min", "Expected .rawValue for min1 to be '1min'")
        XCTAssertEqual(GraphInterval.min5.rawValue, "5min", "Expected .rawValue for min5 to be '5min'")
        XCTAssertEqual(GraphInterval.min15.rawValue, "15min", "Expected .rawValue for min15 to be '15min'")
        XCTAssertEqual(GraphInterval.min30.rawValue, "30min", "Expected .rawValue for min30 to be '30min'")
        XCTAssertEqual(GraphInterval.min60.rawValue, "60min", "Expected .rawValue for min60 to be '60min'")
    }
}
