//
//  StockRowViewModel.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

class StockRowViewModel: ObservableObject {
    
    private let finnhubAPI: FinhubAPIService
    let isDetails: Bool
    
    var loading: Bool = false
    let stock: StockSymbol
    
    @Published var companyProfile: CompanyProfile?
    @Published var companyQuote: StockQuote?
    @Published var graphData: AlphaGraphData?
    
    init(finnhubAPI: FinhubAPIService = FinHubAPIProvider(), stock: StockSymbol, isDetails: Bool = false) {
        self.finnhubAPI = finnhubAPI
        self.stock = stock
        self.isDetails = isDetails
        prepareData()
    }
    
    private func prepareData() {
        loading = true;
        finnhubAPI.fetchCompanyProfile(symbol: stock.symbol) { [weak self] (result: Result<CompanyProfile, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loading = false
                switch result {
                case .success(let profile): self.companyProfile = profile
                case .failure: break
                }
            }
        }
        
        if isDetails {
            loading = true
            finnhubAPI.fetchStockQuote(symbol: stock.symbol) { [weak self] (result: Result<StockQuote, Error>) in
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
}

