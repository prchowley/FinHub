//
//  AlphaGraphData.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

import Foundation

/// An enumeration representing the different types of keys used for accessing graph data in the Alpha Vantage API.
///
/// The `AlphaGraphKeyType` enum distinguishes between different key types based on the data retrieval method: by interval
/// or by function. This helps in managing and organizing the data fetched from the Alpha Vantage API.
enum AlphaGraphKeyType: Hashable {
    
    /// A key type representing a data retrieval by interval.
    ///
    /// This case is used when the graph data is organized by specific time intervals, such as 1-minute, 5-minute, etc.
    /// - Parameter interval: The time interval for the data.
    case interval(GraphInterval)
    
    /// A key type representing a data retrieval by function.
    ///
    /// This case is used when the graph data is organized by the specific function, such as time series daily or weekly.
    /// - Parameter function: The function used for retrieving the data.
    case function(GraphFunction)
}

// MARK: - AlphaGraphData

/// Represents the data returned by the Alpha Vantage API for graphing purposes.
struct AlphaGraphData: Codable {
    
    /// Metadata related to the data request.
    let metaData: MetaData
    
    /// A dictionary mapping `AlphaGraphKeyType` to time series data.
    /// The key represents the interval or function type, and the value is a dictionary of time series data.
    let timeSeries: [AlphaGraphKeyType: [String: GraphDataTimeSeries]]
    
    /// Additional information provided by the API, if any.
    let information: String?
    
    /// Enum for coding keys used in the encoding and decoding process.
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
    
    /// Custom initializer for `AlphaGraphData` struct.
    /// - Parameters:
    ///   - metaData: Metadata for the graph data.
    ///   - timeSeries: A dictionary of time series data keyed by `AlphaGraphKeyType`.
    ///   - information: Optional additional information.
    init(metaData: MetaData, timeSeries: [AlphaGraphKeyType: [String: GraphDataTimeSeries]], information: String? = nil) {
        self.metaData = metaData
        self.timeSeries = timeSeries
        self.information = information
    }
    
    /// Initializes `AlphaGraphData` from a decoder.
    /// - Parameter decoder: The decoder to use for decoding the data.
    /// - Throws: Errors if decoding fails.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        metaData = try container.decode(MetaData.self, forKey: .metaData)
        
        var timeSeries = [AlphaGraphKeyType: [String: GraphDataTimeSeries]]()
        
        // Decode time series data for various intervals and functions
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
    
    /// Encodes `AlphaGraphData` to an encoder.
    /// - Parameter encoder: The encoder to use for encoding the data.
    /// - Throws: Errors if encoding fails.
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
}

// MARK: - MetaData

/// Contains metadata information for the Alpha Vantage graph data.
struct MetaData: Codable {
    
    /// Information about the data request.
    let information: String?
    
    /// Symbol for the stock or index.
    let symbol: String?
    
    /// Date and time when the data was last refreshed.
    let lastRefreshed: String?
    
    /// Interval at which the data is reported.
    let interval: String?
    
    /// Size of the output data.
    let outputSize: String?
    
    /// Time zone in which the data is reported.
    let timeZone: String?
    
    /// Enum for coding keys used in the encoding and decoding process.
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

/// Represents the time series data for a stock or index.
struct GraphDataTimeSeries: Codable {
    
    /// The opening price of the stock.
    let open: String?
    
    /// The highest price of the stock during the period.
    let high: String?
    
    /// The lowest price of the stock during the period.
    let low: String?
    
    /// The closing price of the stock.
    let close: String?
    
    /// The trading volume of the stock.
    let volume: String?
    
    /// Enum for coding keys used in the encoding and decoding process.
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}

// MARK: - Equatable Conformance

/// Conforms `AlphaGraphData` to `Equatable` to allow comparison between instances.
extension AlphaGraphData: Equatable {
    static func == (lhs: AlphaGraphData, rhs: AlphaGraphData) -> Bool {
        lhs.timeSeries == rhs.timeSeries && lhs.metaData == rhs.metaData
    }
}

/// Conforms `GraphDataTimeSeries` to `Equatable` to allow comparison between instances.
extension GraphDataTimeSeries: Equatable { }

/// Conforms `MetaData` to `Equatable` to allow comparison between instances.
extension MetaData: Equatable { }
