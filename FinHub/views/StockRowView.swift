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
            VStack(alignment: .leading) {
                if let cp = viewModel.companyProfile {
                    CompanyDetailsView(companyProfile: cp)
                        .padding(8)
                }
                if let q = viewModel.companyQuote {
                    StockQuoteView(quote: q)
                        .padding(8)
                } 
                
                if !viewModel.isDetails {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: StockDetailsView(
                                viewModel: StockDetailsViewModel(
                                    stock: viewModel.stock
                                )
                            )
                        ) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.blue)
                                .background(Color.white)
                                .cornerRadius(15)
                        }
                    }
                    .padding()
                    .shadow(color: .gray, radius: 10, x: 0, y: 8)
                }
            }
            .background(viewModel.isDetails ? Color.clear : Color.white)
            .cornerRadius(16)
    }
}
