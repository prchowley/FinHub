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

extension StockSymbol: Equatable { }
