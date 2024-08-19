//
//  StockSymbol.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

/// A model representing a stock symbol with various associated details.
struct StockSymbol: Codable, Identifiable {
    
    /// A unique identifier for each `StockSymbol` instance.
    let id = UUID()
    
    /// The stock symbol.
    let symbol: String
    
    /// A description of the stock.
    let description: String
    
    /// The currency in which the stock is traded.
    let currency: String?
    
    /// The display symbol for the stock.
    let displaySymbol: String
    
    /// The Financial Instrument Global Identifier (FIGI) for the stock.
    let figi: String?
    
    /// The International Securities Identification Number (ISIN) for the stock.
    let isin: String?
    
    /// The Market Identifier Code (MIC) for the stock.
    let mic: String?
    
    /// The share class FIGI for the stock.
    let shareClassFIGI: String?
    
    /// An alternative symbol for the stock.
    let symbol2: String?
    
    /// The type of stock.
    let type: String
    
    /// Coding keys to map the JSON keys to the properties of the struct.
    enum CodingKeys: String, CodingKey {
        case symbol
        case description
        case currency
        case displaySymbol
        case figi
        case isin
        case mic
        case shareClassFIGI
        case symbol2
        case type
    }
    
    /// Initializes a new instance of `StockSymbol`.
    /// - Parameters:
    ///   - symbol: The stock symbol.
    ///   - description: A description of the stock.
    ///   - currency: The currency in which the stock is traded.
    ///   - displaySymbol: The display symbol for the stock.
    ///   - figi: The Financial Instrument Global Identifier (FIGI) for the stock.
    ///   - isin: The International Securities Identification Number (ISIN) for the stock.
    ///   - mic: The Market Identifier Code (MIC) for the stock.
    ///   - shareClassFIGI: The share class FIGI for the stock.
    ///   - symbol2: An alternative symbol for the stock.
    ///   - type: The type of stock.
    init(symbol: String, description: String, currency: String?, displaySymbol: String, figi: String?, isin: String?, mic: String?, shareClassFIGI: String?, symbol2: String?, type: String) {
        self.symbol = symbol
        self.description = description
        self.currency = currency
        self.displaySymbol = displaySymbol
        self.figi = figi
        self.isin = isin
        self.mic = mic
        self.shareClassFIGI = shareClassFIGI
        self.symbol2 = symbol2
        self.type = type
    }
}

/// Conforming to `Equatable` allows comparing two `StockSymbol` instances for equality.
extension StockSymbol: Equatable { }
