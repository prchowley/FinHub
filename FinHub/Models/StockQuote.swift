//
//  StockQuote.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import Foundation

/// Represents a stock quote with current and historical price information.
struct StockQuote: Decodable {
    
    /// The current price of the stock.
    let c: Double
    
    /// The highest price of the stock during the current trading period.
    let h: Double
    
    /// The lowest price of the stock during the current trading period.
    let l: Double
    
    /// The opening price of the stock for the current trading period.
    let o: Double
    
    /// The closing price of the stock from the previous trading period.
    let pc: Double
    
    /// Initializes a `StockQuote` instance with the provided values.
    /// - Parameters:
    ///   - c: The current price of the stock.
    ///   - h: The highest price of the stock.
    ///   - l: The lowest price of the stock.
    ///   - o: The opening price of the stock.
    ///   - pc: The previous closing price of the stock.
    init(c: Double, h: Double, l: Double, o: Double, pc: Double) {
        self.c = c
        self.h = h
        self.l = l
        self.o = o
        self.pc = pc
    }
}

extension StockQuote: Equatable { }
