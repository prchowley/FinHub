//
//  StockDataProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation
import Combine

protocol StockDataProvider: ObservableObject {
    associatedtype SymbolType: Decodable
    func prepareData()
    func search(query: String)
    var isLoading: Bool { get }
    var stockSymbols: [SymbolType] { get }
    var errorMessage: String? { get }
}
