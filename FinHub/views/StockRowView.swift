//
//  StockRowView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// A view that displays details for a specific stock, including company profile and stock quote.
///
/// This view presents either a company profile or loading indicator, a stock quote or loading indicator, and a navigation link to detailed stock information if not in detail mode.
struct StockRowView: View {
    
    @StateObject var viewModel: StockRowViewModel
    
    /// Creates the view that displays stock details.
    ///
    /// The view shows company profile information, stock quote, or appropriate loading/error messages. If not in detail mode, it includes a navigation link to detailed stock information.
    ///
    /// - Returns: A `View` that represents the content of the `StockRowView`.
    var body: some View {
        VStack(alignment: .leading) {
            
            // Display company profile or loading/error state
            if let cp = viewModel.companyProfile {
                CompanyDetailsView(companyProfile: cp)
                    .padding(8)
            } else if viewModel.loadingCompanyProfile {
                Text("Loading Company Profile..")
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                Spacer()
            } else if let errorMessage = viewModel.errorMessageCompanyProfile {
                Text(errorMessage)
                Spacer()
            }
            
            // Display stock quote or loading/error state
            if let q = viewModel.companyQuote {
                StockQuoteView(quote: q)
                    .padding(8)
            } else if viewModel.loadingStockQuote {
                Text("Loading Stock Quote..")
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                Spacer()
            } else if let errorMessage = viewModel.errorMessageStockQuote {
                Text(errorMessage)
                Spacer()
            }
            
            // Navigation link to stock details view if not in detail mode
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
