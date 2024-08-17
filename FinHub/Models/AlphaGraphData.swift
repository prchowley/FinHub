//
//  AlphaGraphData.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

// MARK: - AlphaGraphData
struct AlphaGraphData: Codable {
    let metaData: MetaData
    let timeSeries5Min: [String: TimeSeries5Min]?
    let timeSeriesDaily: [String: TimeSeries5Min]?

    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries5Min = "Time Series (5min)"
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

// MARK: - MetaData
struct MetaData: Codable {
    let the1Information, the2Symbol, the3LastRefreshed, the4Interval: String?
    let the5OutputSize, the6TimeZone: String?

    enum CodingKeys: String, CodingKey {
        case the1Information = "1. Information"
        case the2Symbol = "2. Symbol"
        case the3LastRefreshed = "3. Last Refreshed"
        case the4Interval = "4. Interval"
        case the5OutputSize = "5. Output Size"
        case the6TimeZone = "6. Time Zone"
    }
}

// MARK: - TimeSeries5Min
struct TimeSeries5Min: Codable {
    let the1Open, the2High, the3Low, the4Close: String?
    let the5Volume: String?

    enum CodingKeys: String, CodingKey {
        case the1Open = "1. open"
        case the2High = "2. high"
        case the3Low = "3. low"
        case the4Close = "4. close"
        case the5Volume = "5. volume"
    }
}

