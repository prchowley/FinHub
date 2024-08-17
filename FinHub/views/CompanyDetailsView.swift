//
//  CompanyDetailsView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

import SwiftUI

struct CompanyDetailsView: View {
    let companyProfile: CompanyProfile
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                ZStack(alignment: .topTrailing) {
                    CustomImageView(imageUrlString: companyProfile.logo)
                    if let flag = flag(for: companyProfile.country) {
                        Text(flag)
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
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.teal.opacity(0.2))
                    .cornerRadius(10)
                
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
    
    func getLabelView(title: String, subTitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption2)
                .bold()
            Text(subTitle)
                .font(.body)
        }
    }
    
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
    func currencyFormatted(with code: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: self)) ?? "N/A"
    }
}


#Preview {
    CompanyDetailsView(
        companyProfile: CompanyProfile(
            country: "US",
            currency: "USD",
            exchange: "NASDAQ NMS - GLOBAL MARKET",
            ipo: "1980-12-12",
            marketCapitalization: 3416673.621997,
            name: "Apple Inc",
            phone: "14089961010",
            shareOutstanding: 15334.08,
            ticker: "AAPL",
            weburl: "https://www.apple.com/",
            logo: "https://static2.finnhub.io/file/publicdatany/finnhubimage/stock_logo/AAPL.png",
            finnhubIndustry: "Technology"
        )
    )
}
