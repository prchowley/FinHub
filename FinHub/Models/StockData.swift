//
//  StockData.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation

struct StockData: Identifiable {
    let id = UUID()
    let date: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
}
