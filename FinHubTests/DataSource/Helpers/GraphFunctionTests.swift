//
//  GraphFunctionTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.

import XCTest
@testable import FinHub

/// Unit tests for `GraphFunction` functionality.
class GraphFunctionTests: XCTestCase {

    /// Tests the `getIntervals` method of `GraphFunction`.
    func testGetIntervals() {
        // Verify that TIME_SERIES_INTRADAY returns the expected intervals
        XCTAssertEqual(GraphFunction.TIME_SERIES_INTRADAY.getIntervals(), [.min1, .min5, .min15, .min30, .min60], "Expected intervals for TIME_SERIES_INTRADAY are [.min1, .min5, .min15, .min30, .min60]")
        // Verify that other graph functions return nil
        XCTAssertNil(GraphFunction.TIME_SERIES_DAILY.getIntervals(), "Expected intervals for TIME_SERIES_DAILY are nil")
        XCTAssertNil(GraphFunction.TIME_SERIES_WEEKLY.getIntervals(), "Expected intervals for TIME_SERIES_WEEKLY are nil")
        XCTAssertNil(GraphFunction.TIME_SERIES_MONTHLY.getIntervals(), "Expected intervals for TIME_SERIES_MONTHLY are nil")
    }
    
    /// Tests the `CaseIterable` conformance of `GraphFunction`.
    func testCaseIterable() {
        // Get all cases of GraphFunction
        let allCases = GraphFunction.allCases
        // Verify that the number of cases is 4
        XCTAssertEqual(allCases.count, 4, "Expected GraphFunction.allCases to have 4 cases")
        // Verify that all expected cases are present
        XCTAssertTrue(allCases.contains(.TIME_SERIES_INTRADAY), "Expected .allCases to contain .TIME_SERIES_INTRADAY")
        XCTAssertTrue(allCases.contains(.TIME_SERIES_DAILY), "Expected .allCases to contain .TIME_SERIES_DAILY")
        XCTAssertTrue(allCases.contains(.TIME_SERIES_WEEKLY), "Expected .allCases to contain .TIME_SERIES_WEEKLY")
        XCTAssertTrue(allCases.contains(.TIME_SERIES_MONTHLY), "Expected .allCases to contain .TIME_SERIES_MONTHLY")
    }
    
    /// Tests the `Identifiable` conformance of `GraphFunction`.
    func testIdentifiable() {
        // Verify that the id property returns the correct values
        XCTAssertEqual(GraphFunction.TIME_SERIES_INTRADAY.id, .TIME_SERIES_INTRADAY, "Expected .id for TIME_SERIES_INTRADAY to be .TIME_SERIES_INTRADAY")
        XCTAssertEqual(GraphFunction.TIME_SERIES_DAILY.id, .TIME_SERIES_DAILY, "Expected .id for TIME_SERIES_DAILY to be .TIME_SERIES_DAILY")
        XCTAssertEqual(GraphFunction.TIME_SERIES_WEEKLY.id, .TIME_SERIES_WEEKLY, "Expected .id for TIME_SERIES_WEEKLY to be .TIME_SERIES_WEEKLY")
        XCTAssertEqual(GraphFunction.TIME_SERIES_MONTHLY.id, .TIME_SERIES_MONTHLY, "Expected .id for TIME_SERIES_MONTHLY to be .TIME_SERIES_MONTHLY")
    }
    
    /// Tests the `CustomStringConvertible` conformance of `GraphFunction`.
    func testCustomStringConvertible() {
        // Verify that the description property returns the correct values
        XCTAssertEqual(GraphFunction.TIME_SERIES_INTRADAY.description, "Intra-Day", "Expected .description for TIME_SERIES_INTRADAY to be 'Intra-Day'")
        XCTAssertEqual(GraphFunction.TIME_SERIES_DAILY.description, "Daily", "Expected .description for TIME_SERIES_DAILY to be 'Daily'")
        XCTAssertEqual(GraphFunction.TIME_SERIES_WEEKLY.description, "Weekly", "Expected .description for TIME_SERIES_WEEKLY to be 'Weekly'")
        XCTAssertEqual(GraphFunction.TIME_SERIES_MONTHLY.description, "Monthly", "Expected .description for TIME_SERIES_MONTHLY to be 'Monthly'")
    }
}
