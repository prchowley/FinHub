//
//  StockSearchResult.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation

struct StockSearchResult: Codable {
    let count: Int
    let result: [StockSymbol]
    
    init(count: Int, result: [StockSymbol]) {
        self.count = count
        self.result = result
    }
}

extension StockSearchResult: Equatable { }
