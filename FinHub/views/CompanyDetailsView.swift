//
//  CompanyDetailsView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// A view that displays detailed information about a company, including its profile, logo, and additional details.
///
/// This view presents various company details such as the company’s logo, name, website, industry, ticker symbol, exchange, and market capitalization. It also includes functionality for displaying the country's flag based on a country code.
struct CompanyDetailsView: View {
    /// The company profile data to be displayed.
    let companyProfile: CompanyProfile
    
    /// Constructs the view to display the company details.
    ///
    /// The view displays the company's logo, name, website link, industry, ticker symbol, exchange, and market capitalization. If available, it also displays the country flag.
    ///
    /// - Returns: A `View` representing the content of the `CompanyDetailsView`.
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                ZStack(alignment: .topTrailing) {
                    CustomImageView(imageUrlString: companyProfile.logo)
                    if let flag = flag(for: companyProfile.country) {
                        Text(flag)
                            .shadow(color: .gray, radius: 10, x: 0, y: 8)
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(companyProfile.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                    }
                    if let url = URL(string: companyProfile.weburl) {
                        Link("Goto Website", destination: url)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                }
                
            }
            
            VStack(alignment: .leading) {
                
                Text(companyProfile.finnhubIndustry)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.7))
                    .foregroundStyle(Color.white)
                    .cornerRadius(15)
                
                getLabelView(
                    title: "Ticker: ",
                    subTitle: companyProfile.ticker
                )
                
                getLabelView(
                    title: "Exchange: ",
                    subTitle: companyProfile.exchange
                )
                
                if companyProfile.marketCapitalization > 0 {
                    getLabelView(
                        title: "Market Capitalization: ",
                        subTitle: companyProfile.marketCapitalization.currencyFormatted()
                    )
                }
            }
            .padding(.top, 4)
        }
    }
    
    /// Creates a view with a title and subtitle.
    ///
    /// - Parameters:
    ///   - title: The title to be displayed.
    ///   - subTitle: The subtitle to be displayed.
    /// - Returns: A `View` containing a `VStack` with a title and subtitle.
    func getLabelView(title: String, subTitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption2)
                .bold()
            Text(subTitle)
                .font(.body)
        }
    }
    
    /// Returns the flag emoji corresponding to the given country code.
    ///
    /// - Parameter countryCode: The two-letter country code (e.g., "US" for the United States).
    /// - Returns: A string representing the flag emoji, or `nil` if the country code is invalid.
    func flag(for countryCode: String) -> String? {
        guard countryCode.count == 2 else { return nil }
        
        let base: UInt32 = 127397
        var flag = ""
        
        for scalar in countryCode.unicodeScalars {
            guard let scalarValue = UnicodeScalar(base + scalar.value) else {
                return nil
            }
            flag.append(Character(scalarValue))
        }
        
        return flag
    }
}

// Helper function for formatting currency
extension Double {
    /// Formats the value as a currency string.
    ///
    /// - Parameter code: The currency code (default is "USD").
    /// - Returns: A string representing the formatted currency value.
    func currencyFormatted(with code: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: self)) ?? "N/A"
    }
}
