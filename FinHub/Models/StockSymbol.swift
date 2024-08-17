//
//  StockSymbol.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

struct StockSymbol: Codable, Identifiable {
    let id = UUID()
    let symbol: String
    let description: String
    let currency: String?
    let displaySymbol: String
    let figi: String?
    let isin: String?
    let mic: String?
    let shareClassFIGI: String?
    let symbol2: String?
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case symbol, description, currency, displaySymbol, figi, isin, mic, shareClassFIGI, symbol2, type
    }
}

struct StockSearchResult: Codable {
    let count: Int
    let result: [StockSymbol]
}

struct CompanyProfile: Codable {
    let country: String
    let currency: String
    let exchange: String
    let ipo: String
    let marketCapitalization: Double
    let name: String
    let phone: String
    let shareOutstanding: Double
    let ticker: String
    let weburl: String
    let logo: String
    let finnhubIndustry: String
}

struct StockQuote: Decodable {
    let c: Double // Current price
    let h: Double // High price
    let l: Double // Low price
    let o: Double // Open price
    let pc: Double // Previous close
}

struct CandleData: Codable {
    let c: [Double] // Close prices
    let h: [Double] // High prices
    let l: [Double] // Low prices
    let o: [Double] // Open prices
    let s: String   // Status
    let t: [Int]    // Timestamps
    let v: [Double] // Volume
}

struct StockData: Identifiable {
    let id = UUID()
    let date: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
}
