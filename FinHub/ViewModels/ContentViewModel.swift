//
//  ContentViewModel.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let finnhubAPI: FinhubAPIService
    private let searchSubject = PassthroughSubject<String, Never>()
    
    @Published var stockSymbols: [StockSymbol] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var searchQuery: String = "" {
        didSet {
            searchSubject.send(searchQuery)
        }
    }
    
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
    
    func prepareData() {
        isLoading = true
        errorMessage = nil
        
        finnhubAPI.fetchStockSymbols() { [weak self] (result: Result<[StockSymbol], Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let symbols):
                    self.stockSymbols = symbols.filter { $0.type.lowercased() == "common stock" }.sorted(by: { $0.symbol < $1.symbol })
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func search(query: String) {
        isLoading = true
        errorMessage = nil
        
        finnhubAPI.searchStocks(query: query) { [weak self] (result: Result<StockSearchResult, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let symbols):
                    self?.stockSymbols = symbols.result
                case .failure(let error):
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
