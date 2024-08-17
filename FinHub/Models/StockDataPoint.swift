//
//  StockDataPoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

struct StockDataPoint: Identifiable {
    let id = UUID()
    let time: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
}
