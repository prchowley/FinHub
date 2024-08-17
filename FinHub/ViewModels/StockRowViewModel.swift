//
//  StockRowViewModel.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

class StockRowViewModel: ObservableObject {
    
    var loading: Bool = false
    private let networkManager: FinHubAPIProvider
    let stock: StockSymbol
    @Published var companyProfile: CompanyProfile?
    @Published var companyQuote: StockQuote?
    @Published var graphData: AlphaGraphData?
    
    init(networkManager: FinHubAPIProvider = FinHubStockProvider(), stock: StockSymbol) {
        self.networkManager = networkManager
        self.stock = stock
        prepareData()
    }
    
    private func prepareData() {
        loading = true;
        networkManager.companyProfile(symbol: stock.symbol) { [weak self] (result: Result<CompanyProfile, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loading = false
                switch result {
                case .success(let profile): self.companyProfile = profile
                case .failure: break
                }
            }
        }
        
        loading = true
        networkManager.companyQuote(symbol: stock.symbol) { [weak self] (result: Result<StockQuote, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loading = false
                switch result {
                case .success(let companyQuote): self.companyQuote = companyQuote
                case .failure: break
                }
            }
        }
    }
}

