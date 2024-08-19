//
//  StockData.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation

/// Represents a single stock data record.
struct StockData: Identifiable {
    
    /// Unique identifier for the stock data record.
    let id = UUID()
    
    /// The date when the data was recorded.
    let date: Date
    
    /// The opening price of the stock on this date.
    let open: Double
    
    /// The highest price of the stock on this date.
    let high: Double
    
    /// The lowest price of the stock on this date.
    let low: Double
    
    /// The closing price of the stock on this date.
    let close: Double
    
    /// The trading volume of the stock on this date.
    let volume: Double
    
    /// Initializes a `StockData` instance with the provided values.
    /// - Parameters:
    ///   - date: The date when the data was recorded.
    ///   - open: The opening price of the stock.
    ///   - high: The highest price of the stock.
    ///   - low: The lowest price of the stock.
    ///   - close: The closing price of the stock.
    ///   - volume: The trading volume of the stock.
    init(date: Date, open: Double, high: Double, low: Double, close: Double, volume: Double) {
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
}
