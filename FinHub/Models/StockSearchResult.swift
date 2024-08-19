//
//  StockSearchResult.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation

/// A model representing the result of a stock search query.
struct StockSearchResult: Codable {
    
    /// The number of stock symbols returned by the search.
    let count: Int
    
    /// An array of `StockSymbol` objects representing the search results.
    let result: [StockSymbol]
    
    /// Initializes a new instance of `StockSearchResult`.
    /// - Parameters:
    ///   - count: The number of stock symbols returned by the search.
    ///   - result: An array of `StockSymbol` objects representing the search results.
    init(count: Int, result: [StockSymbol]) {
        self.count = count
        self.result = result
    }
}

/// Conforming to `Equatable` allows comparing two `StockSearchResult` instances for equality.
extension StockSearchResult: Equatable { }
