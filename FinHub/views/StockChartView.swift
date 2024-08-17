//
//  StockChartView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import SwiftUI
import Charts

struct StockChartView: View {
    @StateObject var viewModel: StockChartViewModel
    
    var body: some View {
        VStack {
            Chart(viewModel.stockData) { dataPoint in
                LineMark(
                    x: .value("Time", dataPoint.time),
                    y: .value("Close", dataPoint.close)
                )
                .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    StockChartView(
        viewModel: .init(stock: StockSymbol(
            symbol: "AAPL",
            description: "Apple Inc",
            currency: "USD",
            displaySymbol: "AAPL",
            figi: "12",
            isin: "12",
            mic: "12",
            shareClassFIGI: "12",
            symbol2: "AAPL",
            type: "Common stock"
        ))
    )
}
