//
//  StockChartViewModel.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

class StockChartViewModel: ObservableObject {
    @Published var stockData: [StockDataPoint] = []
    private let networkManager: FinHubAPIProvider
    private let stock: StockSymbol
    @Published var loading: Bool = false
    
    init(networkManager: FinHubAPIProvider = FinHubStockProvider(), stock: StockSymbol) {
        self.networkManager = networkManager
        self.stock = stock
        prepareData()
    }
    
    private func prepareData() {
        loading = true
        networkManager.graphData(symbol: stock.symbol) { [weak self] (result: Result<AlphaGraphData, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loading = false
                switch result {
                case .success(let graphData):
                    self.stockData = self.prepareData(graphData)
                case .failure: break
                }
            }
        }
    }
    
    private func prepareData(_ alphaGraphData: AlphaGraphData) -> [StockDataPoint] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var dataPoints: [StockDataPoint] = []
        
        for (key, value) in alphaGraphData.timeSeriesDaily ?? [:] {
            if let time = dateFormatter.date(from: key),
               let open = Double(value.the1Open ?? "0.0"),
               let high = Double(value.the2High ?? "0.0"),
               let low = Double(value.the3Low ?? "0.0"),
               let close = Double(value.the4Close ?? "0.0"),
               let volume = Double(value.the5Volume ?? "0.0") {
                let dataPoint = StockDataPoint(time: time, open: open, high: high, low: low, close: close, volume: volume)
                dataPoints.append(dataPoint)
            }
        }
        return dataPoints.sorted { $0.time < $1.time }
    }
}
