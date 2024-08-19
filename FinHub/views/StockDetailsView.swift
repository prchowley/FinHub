//
//  StockDetailsView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import SwiftUI

class StockDetailsViewModel: ObservableObject {
    let stock: StockSymbol
    
    init(stock: StockSymbol) {
        self.stock = stock
    }
}

struct StockDetailsView: View {
    
    @StateObject var viewModel: StockDetailsViewModel
    
    var body: some View {
        VStack {
            StockRowView(
                viewModel: StockRowViewModel(
                    stock: viewModel.stock,
                    isDetails: true
                )
            )
            StockChartView(
                viewModel: StockChartViewModel(
                    stock: viewModel.stock
                )
            )
            Spacer()
        }
    }
}
