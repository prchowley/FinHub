//
//  ContentViewModel.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation
import Combine

/// ViewModel responsible for managing and providing stock symbol data and search functionality.
///
/// The `ContentViewModel` interacts with the Finnhub API to fetch stock symbols and perform searches based on user input.
/// It manages the loading state, error messages, and stock symbol data.
@MainActor
class ContentViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// A set of cancellable objects used to manage Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// The service used to interact with the Finnhub API.
    private let finnhubAPI: FinhubAPIService
    
    /// An array of `StockSymbol` objects representing the fetched stock symbols.
    @Published var stockSymbols: [StockSymbol] = []
    
    /// A string containing an error message if an error occurs during data fetching or searching.
    @Published var errorMessage: String?
    
    /// A boolean value indicating whether data is currently being fetched.
    @Published var isLoading: Bool = false
    
    /// The current search query. When updated, it triggers a search or data preparation.
    @Published var searchQuery: String = "" {
        didSet {
            Task {
                await handleSearchQueryUpdate()
            }
        }
    }
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `ContentViewModel`.
    ///
    /// - Parameters:
    ///   - finnhubAPI: The service used to interact with the Finnhub API. Defaults to `FinHubAPIProvider()`.
    init(finnhubAPI: FinhubAPIService = FinHubAPIProvider(httpClient: HTTPClient.shared)) {
        self.finnhubAPI = finnhubAPI
    }
    
    // MARK: - Data Handling
    
    /// Fetches and processes stock symbols from the Finnhub API asynchronously.
    ///
    /// Updates `stockSymbols`, `isLoading`, and `errorMessage` based on the result of the fetch request.
    func prepareData() async {
        setLoadingState(to: true)
        
        do {
            let symbols = try await finnhubAPI.fetchStockSymbols()
            self.stockSymbols = symbols
                .filter { $0.type.lowercased() == "common stock" }
                .sorted(by: { $0.symbol < $1.symbol })
        } catch {
            handleError(error)
        }
        
        setLoadingState(to: false)
    }
    
    /// Searches for stock symbols based on the provided query asynchronously.
    ///
    /// - Parameter query: The search query used to filter stock symbols.
    ///
    /// Updates `stockSymbols`, `isLoading`, and `errorMessage` based on the result of the search request.
    func search(query: String) async {
        setLoadingState(to: true)
        
        do {
            let searchResult = try await finnhubAPI.searchStocks(query: query)
            self.stockSymbols = searchResult.result
        } catch {
            handleError(error)
        }
        
        setLoadingState(to: false)
    }
    
    /// Handles the search query update, triggering a search or data preparation.
    private func handleSearchQueryUpdate() async {
        if searchQuery.isEmpty {
            await prepareData()
        } else {
            await search(query: searchQuery)
        }
    }
    
    // MARK: - Private Methods
    
    /// Sets the loading state and clears error messages.
    ///
    /// - Parameter isLoading: A boolean indicating whether loading is in progress.
    private func setLoadingState(to isLoading: Bool) {
        self.isLoading = isLoading
        if !isLoading {
            self.errorMessage = nil
        }
    }
    
    /// Handles errors by setting an appropriate error message.
    ///
    /// - Parameter error: The error to handle.
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            self.errorMessage = "Error: \(networkError.localizedDescription)"
        } else {
            self.errorMessage = "Unexpected error occurred"
        }
    }
}
