//
//  StockChartView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import SwiftUI
import Charts

struct StockChartView: View {
    
    @StateObject var viewModel: StockChartViewModel
    
    var body: some View {
        VStack {
            if viewModel.loading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage: errorMessage)
            } else if viewModel.stockData.isEmpty {
                errorView(errorMessage: "No data available")
            } else {
                mainContent
            }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        HStack {
            CustomPicker(viewModel: viewModel.vmPickerFrequency)
            if viewModel.vmPickerFrequency.selectedOption == .TIME_SERIES_INTRADAY {
                CustomPicker(viewModel: viewModel.vmPickerInterval)
            }
        }
        Chart(viewModel.stockData) { dataPoint in
            LineMark(
                x: .value("Time", dataPoint.time),
                y: .value("Close", dataPoint.close)
            )
            .foregroundStyle(.blue)
        }
        .padding()
    }
    
    private func errorView(errorMessage: String) -> some View {
        Text(errorMessage)
            .foregroundColor(.red)
            .padding()
    }
}
