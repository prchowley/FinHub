//
//  AlphaGraphData.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

// MARK: - AlphaGraphData
enum AlphaGraphKeyType: Hashable {
    case interval(GraphInterval)
    case function(GraphFunction)
}

extension AlphaGraphKeyType: Identifiable {
    var id: String {
        switch self {
        case .interval(let interval):
            return interval.rawValue
        case .function(let function):
            return function.rawValue
        }
    }
}

struct AlphaGraphData: Codable {
    let metaData: MetaData
    let timeSeries: [AlphaGraphKeyType: [String: GraphDataTimeSeries]]
    let information: String?
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries1Min = "Time Series (1min)"
        case timeSeries5Min = "Time Series (5min)"
        case timeSeries15Min = "Time Series (15min)"
        case timeSeries30Min = "Time Series (30min)"
        case timeSeries60Min = "Time Series (60min)"
        
        case timeSeriesDaily = "Time Series (Daily)"
        case timeSeriesWeekly = "Weekly Time Series"
        case timeSeriesMonthly = "Monthly Time Series"
        
        case information = "Information"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        metaData = try container.decode(MetaData.self, forKey: .metaData)
        
        var timeSeries = [AlphaGraphKeyType: [String: GraphDataTimeSeries]]()
        
        if let series = try container.decodeIfPresent([String: GraphDataTimeSeries].self, forKey: .timeSeries1Min) {
            timeSeries[.interval(.min1)] = series
        }
        if let series = try container.decodeIfPresent([String: GraphDataTimeSeries].self, forKey: .timeSeries5Min) {
            timeSeries[.interval(.min5)] = series
        }
        if let series = try container.decodeIfPresent([String: GraphDataTimeSeries].self, forKey: .timeSeries15Min) {
            timeSeries[.interval(.min15)] = series
        }
        if let series = try container.decodeIfPresent([String: GraphDataTimeSeries].self, forKey: .timeSeries30Min) {
            timeSeries[.interval(.min30)] = series
        }
        if let series = try container.decodeIfPresent([String: GraphDataTimeSeries].self, forKey: .timeSeries60Min) {
            timeSeries[.interval(.min60)] = series
        }
        if let series = try container.decodeIfPresent([String: GraphDataTimeSeries].self, forKey: .timeSeriesDaily) {
            timeSeries[.function(.TIME_SERIES_DAILY)] = series
        }
        if let series = try container.decodeIfPresent([String: GraphDataTimeSeries].self, forKey: .timeSeriesWeekly) {
            timeSeries[.function(.TIME_SERIES_WEEKLY)] = series
        }
        if let series = try container.decodeIfPresent([String: GraphDataTimeSeries].self, forKey: .timeSeriesMonthly) {
            timeSeries[.function(.TIME_SERIES_MONTHLY)] = series
        }
        self.timeSeries = timeSeries
        self.information = try? container.decodeIfPresent(String.self, forKey: .information)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(metaData, forKey: .metaData)
        try container.encodeIfPresent(timeSeries[.interval(.min1)], forKey: .timeSeries1Min)
        try container.encodeIfPresent(timeSeries[.interval(.min5)], forKey: .timeSeries5Min)
        try container.encodeIfPresent(timeSeries[.interval(.min15)], forKey: .timeSeries15Min)
        try container.encodeIfPresent(timeSeries[.interval(.min30)], forKey: .timeSeries30Min)
        try container.encodeIfPresent(timeSeries[.interval(.min60)], forKey: .timeSeries60Min)
        
        try container.encodeIfPresent(timeSeries[.function(.TIME_SERIES_DAILY)], forKey: .timeSeriesDaily)
        try container.encodeIfPresent(timeSeries[.function(.TIME_SERIES_WEEKLY)], forKey: .timeSeriesWeekly)
        try container.encodeIfPresent(timeSeries[.function(.TIME_SERIES_MONTHLY)], forKey: .timeSeriesMonthly)
    }
    
    // Custom initializer
    init(metaData: MetaData, timeSeries: [AlphaGraphKeyType: [String: GraphDataTimeSeries]], information: String? = nil) {
        self.metaData = metaData
        self.timeSeries = timeSeries
        self.information = information
    }
}

// MARK: - MetaData
struct MetaData: Codable {
    let information, symbol, lastRefreshed, interval: String?
    let outputSize, timeZone: String?
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case interval = "4. Interval"
        case outputSize = "5. Output Size"
        case timeZone = "6. Time Zone"
    }
}

// MARK: - GraphDataTimeSeries
struct GraphDataTimeSeries: Codable {
    let open, high, low, close, volume: String?
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}

extension AlphaGraphData: Equatable {
    static func == (lhs: AlphaGraphData, rhs: AlphaGraphData) -> Bool {
        lhs.timeSeries == rhs.timeSeries && lhs.metaData == rhs.metaData
    }
}

extension GraphDataTimeSeries: Equatable { }
extension MetaData: Equatable { }
