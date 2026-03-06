//
//  StockDetailsView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import SwiftUI

struct StockDetailsView: View {
    
    /// The view model that provides data for the `StockDetailsView`.
    @ObservedObject var rowModel: StockRowViewModel
    
    @Environment(\.keyService) var keyService
    @Environment(\.httpClient) var httpClient

    /// The body of the view.
    var body: some View {
        VStack {
            // Displays stock information and details.
            StockRowView(
                finnhubAPI: rowModel.finnhubAPI,
                stock: rowModel.stock,
                isDetails: true,
                companyProfile: rowModel.companyProfile
            )
            // Displays a chart with stock data.
            StockChartView(
                httpClient: httpClient,
                keyService: keyService,
                stock: rowModel.stock
            )
            Spacer()
        }
        .padding()
    }
}
