//
//  StockRowView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

struct StockRowView: View {
    
    @StateObject var viewModel: StockRowViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                if let cp = viewModel.companyProfile {
                    CompanyDetailsView(companyProfile: cp)
                        .padding(8)
                }
                if let q = viewModel.companyQuote {
                    StockQuoteView(quote: q)
                        .padding(4)
                }
                StockChartView(viewModel: .init(stock: viewModel.stock))
                Spacer()
            }
            .frame(width: 300)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .gray, radius: 4, x: 2, y: 4)
            .padding(8)
        }
    }
}

#Preview {
    StockRowView(
        viewModel: .init(stock: StockSymbol(
            symbol: "AAPL",
            description: "Apple Inc",
            currency: "USD",
            displaySymbol: "AAPL",
            figi: "12",
            isin: "12",
            mic: "12",
            shareClassFIGI: "12",
            symbol2: "AAPL",
            type: "Common stock"
        ))
    )
    
}
