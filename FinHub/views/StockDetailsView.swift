//
//  StockDetailsView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import SwiftUI

/// A view model that provides data for the `StockDetailsView`.
///
/// This view model contains the information of a specific stock symbol and is used to
/// drive the content of the `StockDetailsView`.
class StockDetailsViewModel: ObservableObject {
    
    /// The stock symbol associated with this view model.
    let stock: StockSymbol
    
    /// Initializes a new instance of `StockDetailsViewModel`.
    ///
    /// - Parameter stock: The `StockSymbol` that the view model will manage.
    init(stock: StockSymbol) {
        self.stock = stock
    }
}

struct StockDetailsView: View {
    
    /// The view model that provides data for the `StockDetailsView`.
    @StateObject var viewModel: StockDetailsViewModel
    
    /// The body of the view.
    var body: some View {
        VStack {
            // Displays stock information and details.
            StockRowView(
                viewModel: StockRowViewModel(
                    stock: viewModel.stock,
                    isDetails: true
                )
            )
            // Displays a chart with stock data.
            StockChartView(
                viewModel: StockChartViewModel(
                    stock: viewModel.stock
                )
            )
            Spacer()
        }
        .padding()
    }
}
