//
//  StockRowViewModel.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

/// ViewModel responsible for managing and providing data for a single stock row.
///
/// The `StockRowViewModel` interacts with the Finnhub API to fetch the company profile and, optionally, the stock quote
/// for a given stock symbol. It also manages loading states and error messages for these operations.
@MainActor
class StockRowViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// The service used to interact with the Finnhub API.
    private let finnhubAPI: FinhubAPIService
    
    /// A boolean indicating whether detailed stock quote information should be fetched.
    let isDetails: Bool
    
    /// The stock symbol associated with this view model.
    let stock: StockSymbol
    
    /// A boolean value indicating whether the company profile is currently being fetched.
    @Published var loadingCompanyProfile: Bool = false
    
    /// A boolean value indicating whether the stock quote is currently being fetched.
    @Published var loadingStockQuote: Bool = false
    
    /// A string containing an error message if an error occurs while fetching the company profile.
    @Published var errorMessageCompanyProfile: String?
    
    /// A string containing an error message if an error occurs while fetching the stock quote.
    @Published var errorMessageStockQuote: String?
    
    /// The company profile for the stock symbol, if successfully fetched.
    @Published var companyProfile: CompanyProfile?
    
    /// The stock quote for the stock symbol, if successfully fetched and details are required.
    @Published var companyQuote: StockQuote?
    
    /// Graph data related to the stock symbol, if available.
    @Published var graphData: AlphaGraphData?
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `StockRowViewModel`.
    ///
    /// - Parameters:
    ///   - finnhubAPI: The service used to interact with the Finnhub API. Defaults to `FinHubAPIProvider()`.
    ///   - stock: The stock symbol associated with this view model.
    ///   - isDetails: A boolean indicating whether detailed stock quote information should be fetched. Defaults to `false`.
    init(
        finnhubAPI: FinhubAPIService = FinHubAPIProvider(httpClient: HTTPClient.shared),
        stock: StockSymbol,
        isDetails: Bool = false
    ) {
        self.finnhubAPI = finnhubAPI
        self.stock = stock
        self.isDetails = isDetails
    }
    
    // MARK: - Data Handling
    /// Fetches and processes the company profile for the given stock symbol.
    /// Updates `loadingCompanyProfile`, `companyProfile`, and error messages based on the result of the fetch request.
    @MainActor
    func fetchCompanyProfile() async {
        loadingCompanyProfile = true
        do {
            let profile = try await finnhubAPI.fetchCompanyProfile(symbol: stock.symbol)
            self.companyProfile = profile
        } catch {
            self.errorMessageCompanyProfile = "Error: Failed to fetch profile"
        }
        self.loadingCompanyProfile = false
    }

    /// Fetches and processes the stock quote for the given stock symbol if details are requested.
    /// Updates `loadingStockQuote`, `companyQuote`, and error messages based on the result of the fetch request.
    @MainActor
    func fetchStockQuote() async {
        guard isDetails else { return }
        loadingStockQuote = true
        do {
            let companyQuote = try await finnhubAPI.fetchStockQuote(symbol: stock.symbol)
            self.companyQuote = companyQuote
        } catch {
            self.errorMessageStockQuote = "Error: Failed to fetch stock quote"
        }
        self.loadingStockQuote = false
    }

    /// Prepares the data by fetching the company profile and, if requested, the stock quote for the given stock symbol.
    /// This function calls `fetchCompanyProfile` and `fetchStockQuote` to handle the data fetching.
    @MainActor
    func prepareData() async {
        await fetchCompanyProfile()
        if isDetails {
            await fetchStockQuote()
        }
    }
}
