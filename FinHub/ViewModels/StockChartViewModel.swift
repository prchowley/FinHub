//
//  StockChartViewModel.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation
import Combine

class StockChartViewModel: ObservableObject {
    
    private let alphaVantageAPI: AlphaVantageAPIService
    private let stock: StockSymbol
    
    @Published var vmPickerFrequency = CustomPickerViewModel(options: GraphFunction.allCases)
    @Published var vmPickerInterval = CustomPickerViewModel(options: GraphInterval.allCases)
    
    @Published var stockData: [StockDataPoint] = []
    @Published var loading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        alphaVantageAPI: AlphaVantageAPIService = AlphaVantageAPIProvider(),
        stock: StockSymbol
    ) {
        self.alphaVantageAPI = alphaVantageAPI
        self.stock = stock
        
        Publishers.CombineLatest(vmPickerFrequency.$selectedOption, vmPickerInterval.$selectedOption)
            .sink { [weak self] newFrequency, newInterval in
                self?.prepareData(with: newFrequency, and: newInterval)
            }
            .store(in: &cancellables)
    }
    
    private func prepareData(with frequency: GraphFunction, and interval: GraphInterval) {
        loading = true
        alphaVantageAPI.graphData(
            of: stock.symbol,
            with: frequency,
            and: interval
        ) { [weak self] (result: Result<AlphaGraphData, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loading = false
                switch result {
                case .success(let graphData):
                    if let info = graphData.information {
                        self.errorMessage = info;
                    } else {
                        self.stockData = self.prepareData(graphData)
                    }
                case .failure:
                    self.errorMessage = "Something went wrong!"
                }
            }
        }
    }
    
    private func prepareData(_ alphaGraphData: AlphaGraphData) -> [StockDataPoint] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = vmPickerFrequency.selectedOption == .TIME_SERIES_INTRADAY ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd"
        let graphDataKey: AlphaGraphKeyType = vmPickerFrequency.selectedOption == .TIME_SERIES_INTRADAY ? 
            .interval(vmPickerInterval.selectedOption) :
            .function(vmPickerFrequency.selectedOption)
        
        var dataPoints: [StockDataPoint] = []
        
        for (key, value) in alphaGraphData.timeSeries[graphDataKey] ?? [:] {
            if let time = dateFormatter.date(from: key),
               let open = Double(value.open ?? "0.0"),
               let high = Double(value.high ?? "0.0"),
               let low = Double(value.low ?? "0.0"),
               let close = Double(value.close ?? "0.0"),
               let volume = Double(value.volume ?? "0.0") {
                let dataPoint = StockDataPoint(time: time, open: open, high: high, low: low, close: close, volume: volume)
                dataPoints.append(dataPoint)
            }
        }
        return dataPoints.sorted { $0.time < $1.time }
    }
}
