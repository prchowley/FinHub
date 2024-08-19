//
//  AlphaGraphDataTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import XCTest
@testable import FinHub

/// Unit tests for encoding and decoding `AlphaGraphData`.
class AlphaGraphDataTests: XCTestCase {
    
    /// Tests encoding of `AlphaGraphData` to JSON.
    func testEncodeAlphaGraphData() {
        // Given
        let metaData = MetaData(
            information: "Information",
            symbol: "AAPL",
            lastRefreshed: "2024-08-17",
            interval: "1min",
            outputSize: "Compact",
            timeZone: "US/Eastern"
        )
        
        let timeSeries: [AlphaGraphKeyType: [String: GraphDataTimeSeries]] = [
            .interval(.min1): [
                "2024-08-17 09:30:00": GraphDataTimeSeries(
                    open: "150.00",
                    high: "152.00",
                    low: "149.00",
                    close: "151.00",
                    volume: "1000"
                )
            ],
            .function(.TIME_SERIES_DAILY): [
                "2024-08-16": GraphDataTimeSeries(
                    open: "150.00",
                    high: "155.00",
                    low: "148.00",
                    close: "153.00",
                    volume: "2000"
                )
            ]
        ]
        
        let alphaGraphData = AlphaGraphData(metaData: metaData, timeSeries: timeSeries)
        
        // When
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(alphaGraphData)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            // Then
            XCTAssertNotNil(jsonObject, "Expected the JSON object to be non-nil")
            
            // Verify Meta Data
            guard let metaDataDict = jsonObject?["Meta Data"] as? [String: String] else {
                XCTFail("Failed to cast Meta Data to [String: String]")
                return
            }
            
            XCTAssertEqual(metaDataDict["1. Information"], "Information")
            XCTAssertEqual(metaDataDict["2. Symbol"], "AAPL")
            XCTAssertEqual(metaDataDict["3. Last Refreshed"], "2024-08-17")
            XCTAssertEqual(metaDataDict["4. Interval"], "1min")
            XCTAssertEqual(metaDataDict["5. Output Size"], "Compact")
            XCTAssertEqual(metaDataDict["6. Time Zone"], "US/Eastern")
            
            // Verify Time Series
            if let timeSeries1Min = jsonObject?["Time Series (1min)"] as? [String: [String: String]] {
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?["1. open"], "150.00")
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?["2. high"], "152.00")
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?["3. low"], "149.00")
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?["4. close"], "151.00")
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?["5. volume"], "1000")
            } else {
                XCTFail("Failed to cast Time Series (1min) to [String: [String: String]]")
            }
            
            if let timeSeriesDaily = jsonObject?["Time Series (Daily)"] as? [String: [String: String]] {
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?["1. open"], "150.00")
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?["2. high"], "155.00")
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?["3. low"], "148.00")
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?["4. close"], "153.00")
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?["5. volume"], "2000")
            } else {
                XCTFail("Failed to cast Time Series (Daily) to [String: [String: String]]")
            }
            
        } catch {
            XCTFail("Failed to encode AlphaGraphData: \(error)")
        }
    }
    
    /// Tests decoding of `AlphaGraphData` from JSON.
    func testDecodeAlphaGraphData() {
        // Given
        let json = """
        {
            "Meta Data": {
                "1. Information": "Information",
                "2. Symbol": "AAPL",
                "3. Last Refreshed": "2024-08-17",
                "4. Interval": "1min",
                "5. Output Size": "Compact",
                "6. Time Zone": "US/Eastern"
            },
            "Time Series (1min)": {
                "2024-08-17 09:30:00": {
                    "1. open": "150.00",
                    "2. high": "152.00",
                    "3. low": "149.00",
                    "4. close": "151.00",
                    "5. volume": "1000"
                }
            },
            "Time Series (Daily)": {
                "2024-08-16": {
                    "1. open": "150.00",
                    "2. high": "155.00",
                    "3. low": "148.00",
                    "4. close": "153.00",
                    "5. volume": "2000"
                }
            }
        }
        """.data(using: .utf8)!
        
        // When
        do {
            let decoder = JSONDecoder()
            let alphaGraphData = try decoder.decode(AlphaGraphData.self, from: json)
            
            // Then
            XCTAssertEqual(alphaGraphData.metaData.information, "Information")
            XCTAssertEqual(alphaGraphData.metaData.symbol, "AAPL")
            XCTAssertEqual(alphaGraphData.metaData.lastRefreshed, "2024-08-17")
            XCTAssertEqual(alphaGraphData.metaData.interval, "1min")
            XCTAssertEqual(alphaGraphData.metaData.outputSize, "Compact")
            XCTAssertEqual(alphaGraphData.metaData.timeZone, "US/Eastern")
            
            if let timeSeries1Min = alphaGraphData.timeSeries[.interval(.min1)] {
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?.open, "150.00")
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?.high, "152.00")
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?.low, "149.00")
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?.close, "151.00")
                XCTAssertEqual(timeSeries1Min["2024-08-17 09:30:00"]?.volume, "1000")
            } else {
                XCTFail("Time Series (1min) not found")
            }
            
            if let timeSeriesDaily = alphaGraphData.timeSeries[.function(.TIME_SERIES_DAILY)] {
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?.open, "150.00")
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?.high, "155.00")
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?.low, "148.00")
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?.close, "153.00")
                XCTAssertEqual(timeSeriesDaily["2024-08-16"]?.volume, "2000")
            } else {
                XCTFail("Time Series (Daily) not found")
            }
            
        } catch {
            XCTFail("Failed to decode AlphaGraphData: \(error)")
        }
    }
}
