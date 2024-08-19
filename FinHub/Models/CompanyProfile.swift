//
//  CompanyProfile.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation

struct CompanyProfile: Codable {
    let country: String
    let currency: String
    let exchange: String
    let ipo: String
    let marketCapitalization: Double
    let name: String
    let phone: String
    let shareOutstanding: Double
    let ticker: String
    let weburl: String
    let logo: String
    let finnhubIndustry: String
    
    init(country: String, currency: String, exchange: String, ipo: String, marketCapitalization: Double, name: String, phone: String, shareOutstanding: Double, ticker: String, weburl: String, logo: String, finnhubIndustry: String) {
        self.country = country
        self.currency = currency
        self.exchange = exchange
        self.ipo = ipo
        self.marketCapitalization = marketCapitalization
        self.name = name
        self.phone = phone
        self.shareOutstanding = shareOutstanding
        self.ticker = ticker
        self.weburl = weburl
        self.logo = logo
        self.finnhubIndustry = finnhubIndustry
    }
}

extension CompanyProfile: Equatable { }
