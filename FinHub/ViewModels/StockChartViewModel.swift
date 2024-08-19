//
//  StockChartViewModel.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation
import Combine

/// ViewModel responsible for managing and providing stock chart data for a given stock symbol.
///
/// The `StockChartViewModel` fetches and processes stock data using the Alpha Vantage API. It provides
/// stock data points based on user-selected frequency and interval and handles loading states and error messages.
class StockChartViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// The service used to fetch graph data from the Alpha Vantage API.
    private let alphaVantageAPI: AlphaVantageAPIService
    
    /// The stock symbol for which the chart data is being fetched.
    private let stock: StockSymbol
    
    /// The view model for the frequency picker, which allows the user to select the graph function.
    @Published var vmPickerFrequency = CustomPickerViewModel(options: GraphFunction.allCases)
    
    /// The view model for the interval picker, which allows the user to select the graph interval.
    @Published var vmPickerInterval = CustomPickerViewModel(options: GraphInterval.allCases)
    
    /// The array of `StockDataPoint` objects representing the fetched and processed stock data.
    @Published var stockData: [StockDataPoint] = []
    
    /// A boolean value indicating whether data is currently being fetched.
    @Published var loading: Bool = false
    
    /// A string containing an error message if an error occurs during data fetching.
    @Published var errorMessage: String?
    
    /// A set of cancellable objects used to manage Combine subscriptions.
    private var cancellables: Set<AnyCancellable> = []
    
    /// A date formatter used to parse date strings from the API response.
    private let dateFormatter = DateFormatter()
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `StockChartViewModel`.
    ///
    /// - Parameters:
    ///   - alphaVantageAPI: The service used to fetch graph data. Defaults to `AlphaVantageAPIProvider()`.
    ///   - stock: The `StockSymbol` for which to fetch the chart data.
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
        
        // Set initial date format for the date formatter.
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    }
    
    // MARK: - Data Handling
    
    /// Fetches and processes stock data based on the selected frequency and interval.
    ///
    /// - Parameters:
    ///   - frequency: The selected graph function (e.g., TIME_SERIES_INTRADAY).
    ///   - interval: The selected graph interval (e.g., 1 minute, 5 minutes).
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
                        self.errorMessage = info
                    } else {
                        self.stockData = self.prepareData(from: graphData)
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// Converts `AlphaGraphData` to an array of `StockDataPoint` objects.
    ///
    /// - Parameter alphaGraphData: The data received from the Alpha Vantage API.
    /// - Returns: An array of `StockDataPoint` objects, sorted by date.
    private func prepareData(from alphaGraphData: AlphaGraphData) -> [StockDataPoint] {
        let dateFormat = getDateFormat()
        dateFormatter.dateFormat = dateFormat
        let graphDataKey = getGraphDataKey()
        
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
    
    /// Returns the date format string based on the selected frequency.
    ///
    /// - Returns: A string representing the date format for parsing API response dates.
    private func getDateFormat() -> String {
        return vmPickerFrequency.selectedOption == .TIME_SERIES_INTRADAY ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd"
    }
    
    /// Returns the appropriate `AlphaGraphKeyType` based on the selected frequency and interval.
    ///
    /// - Returns: An `AlphaGraphKeyType` representing the key for accessing time series data.
    private func getGraphDataKey() -> AlphaGraphKeyType {
        return vmPickerFrequency.selectedOption == .TIME_SERIES_INTRADAY ?
            .interval(vmPickerInterval.selectedOption) :
            .function(vmPickerFrequency.selectedOption)
    }
}
