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
class ContentViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// A set of cancellable objects used to manage Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// The service used to interact with the Finnhub API.
    private let finnhubAPI: FinhubAPIService
    
    /// A publisher that emits search queries for stock symbols.
    private let searchSubject = PassthroughSubject<String, Never>()
    
    /// An array of `StockSymbol` objects representing the fetched stock symbols.
    @Published var stockSymbols: [StockSymbol] = []
    
    /// A string containing an error message if an error occurs during data fetching or searching.
    @Published var errorMessage: String?
    
    /// A boolean value indicating whether data is currently being fetched.
    @Published var isLoading: Bool = false
    
    /// The current search query. When updated, it triggers a search or data preparation.
    @Published var searchQuery: String = "" {
        didSet {
            searchSubject.send(searchQuery)
        }
    }
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `ContentViewModel`.
    ///
    /// - Parameters:
    ///   - finnhubAPI: The service used to interact with the Finnhub API. Defaults to `FinHubAPIProvider()`.
    init(finnhubAPI: FinhubAPIService = FinHubAPIProvider()) {
        self.finnhubAPI = finnhubAPI
        prepareData()
        
        searchSubject
            .debounce(for: .seconds(4), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] query in
                !query.isEmpty ?
                self?.search(query: query) :
                self?.prepareData()
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Data Handling
    
    /// Fetches and processes stock symbols from the Finnhub API.
    ///
    /// Updates `stockSymbols`, `isLoading`, and `errorMessage` based on the result of the fetch request.
    func prepareData() {
        isLoading = true
        errorMessage = nil
        
        finnhubAPI.fetchStockSymbols() { [weak self] (result: Result<[StockSymbol], NetworkError>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let symbols):
                    self.stockSymbols = symbols.filter { $0.type.lowercased() == "common stock" }
                                                .sorted(by: { $0.symbol < $1.symbol })
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// Searches for stock symbols based on the provided query.
    ///
    /// - Parameter query: The search query used to filter stock symbols.
    ///
    /// Updates `stockSymbols`, `isLoading`, and `errorMessage` based on the result of the search request.
    func search(query: String) {
        isLoading = true
        errorMessage = nil
        
        finnhubAPI.searchStocks(query: query) { [weak self] (result: Result<StockSearchResult, NetworkError>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let searchResult):
                    self?.stockSymbols = searchResult.result
                case .failure(let error):
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
