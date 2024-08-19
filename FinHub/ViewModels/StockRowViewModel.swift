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
    
    let stock: StockSymbol
    
    @Published var loadingCompanyProfile: Bool = false
    @Published var loadingStockQuote: Bool = false
    @Published var errorMessageCompanyProfile: String?
    @Published var errorMessageStockQuote: String?
    @Published var companyProfile: CompanyProfile?
    @Published var companyQuote: StockQuote?
    @Published var graphData: AlphaGraphData?
    
    init(
        finnhubAPI: FinhubAPIService = FinHubAPIProvider(),
        stock: StockSymbol,
        isDetails: Bool = false
    ) {
        self.finnhubAPI = finnhubAPI
        self.stock = stock
        self.isDetails = isDetails
        prepareData()
    }
    
    func prepareData() {
        loadingCompanyProfile = true;
        finnhubAPI.fetchCompanyProfile(symbol: stock.symbol) { [weak self] (result: Result<CompanyProfile, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingCompanyProfile = false
                switch result {
                case .success(let profile): self.companyProfile = profile
                case .failure: self.errorMessageCompanyProfile = "Error: Failed to fetch profile"
                }
            }
        }
        
        if isDetails {
            loadingStockQuote = true
            finnhubAPI.fetchStockQuote(symbol: stock.symbol) { [weak self] (result: Result<StockQuote, Error>) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.loadingStockQuote = false
                    switch result {
                    case .success(let companyQuote): self.companyQuote = companyQuote
                    case .failure: self.errorMessageStockQuote = "Error: Failed to fetch stock quote"
                    }
                }
            }
        }
    }
}
