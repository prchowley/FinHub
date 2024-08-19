//
//  StockDataPoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

/// Represents a single data point in a stock's time series.
struct StockDataPoint: Identifiable {
    
    /// Unique identifier for the data point.
    let id = UUID()
    
    /// The date and time of the data point.
    let time: Date
    
    /// The opening price of the stock at this time.
    let open: Double
    
    /// The highest price of the stock during this period.
    let high: Double
    
    /// The lowest price of the stock during this period.
    let low: Double
    
    /// The closing price of the stock at this time.
    let close: Double
    
    /// The trading volume of the stock during this period.
    let volume: Double
    
    /// Initializes a `StockDataPoint` with the provided values.
    /// - Parameters:
    ///   - time: The date and time of the data point.
    ///   - open: The opening price of the stock.
    ///   - high: The highest price of the stock during this period.
    ///   - low: The lowest price of the stock during this period.
    ///   - close: The closing price of the stock.
    ///   - volume: The trading volume of the stock.
    init(time: Date, open: Double, high: Double, low: Double, close: Double, volume: Double) {
        self.time = time
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
}
