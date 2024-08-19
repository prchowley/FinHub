//
//  CompanyProfile.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 18/08/24.
//

import Foundation

/// A model representing a company profile with various associated details.
struct CompanyProfile: Codable {
    
    /// The country where the company is based.
    let country: String
    
    /// The currency in which the company's stocks are traded.
    let currency: String
    
    /// The stock exchange where the company's stocks are listed.
    let exchange: String
    
    /// The initial public offering (IPO) date of the company.
    let ipo: String
    
    /// The market capitalization of the company.
    let marketCapitalization: Double
    
    /// The name of the company.
    let name: String
    
    /// The contact phone number of the company.
    let phone: String
    
    /// The number of shares outstanding.
    let shareOutstanding: Double
    
    /// The ticker symbol of the company.
    let ticker: String
    
    /// The website URL of the company.
    let weburl: String
    
    /// The logo URL of the company.
    let logo: String
    
    /// The industry sector in which the company operates, according to Finnhub.
    let finnhubIndustry: String
    
    /// Initializes a new instance of `CompanyProfile`.
    /// - Parameters:
    ///   - country: The country where the company is based.
    ///   - currency: The currency in which the company's stocks are traded.
    ///   - exchange: The stock exchange where the company's stocks are listed.
    ///   - ipo: The initial public offering (IPO) date of the company.
    ///   - marketCapitalization: The market capitalization of the company.
    ///   - name: The name of the company.
    ///   - phone: The contact phone number of the company.
    ///   - shareOutstanding: The number of shares outstanding.
    ///   - ticker: The ticker symbol of the company.
    ///   - weburl: The website URL of the company.
    ///   - logo: The logo URL of the company.
    ///   - finnhubIndustry: The industry sector in which the company operates, according to Finnhub.
    init(
        country: String,
        currency: String,
        exchange: String,
        ipo: String,
        marketCapitalization: Double,
        name: String,
        phone: String,
        shareOutstanding: Double,
        ticker: String,
        weburl: String,
        logo: String,
        finnhubIndustry: String
    ) {
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

/// Conforming to `Equatable` allows comparing two `CompanyProfile` instances for equality.
extension CompanyProfile: Equatable { }
