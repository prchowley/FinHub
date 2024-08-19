//
//  StockChartView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import SwiftUI
import Charts

/// A view that displays stock data using a chart and allows the user to select the frequency and interval for data retrieval.
struct StockChartView: View {
    
    /// The view model that provides data and handles logic for the stock chart.
    @StateObject var viewModel: StockChartViewModel
    
    /// The body of the view.
    var body: some View {
        VStack {
            // Show a loading indicator while data is being fetched.
            if viewModel.loading {
                loadingView
            }
            // Display an error message if an error occurs or no data is available.
            else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage: errorMessage)
            } else if viewModel.stockData.isEmpty {
                errorView(errorMessage: "No data available")
            } else {
                // Display the main content when data is available.
                mainContent
            }
        }
        .padding()
    }
    
    /// A view displaying a loading indicator.
    private var loadingView: some View {
        ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
    }
    
    /// A view displaying an error message.
    /// - Parameter errorMessage: The error message to display.
    /// - Returns: A view displaying the error message in red.
    private func errorView(errorMessage: String) -> some View {
        Text(errorMessage)
            .foregroundColor(.red)
            .padding()
    }
    
    /// The main content of the view, including chart and pickers.
    private var mainContent: some View {
        VStack {
            HStack {
                // Picker for selecting the frequency of stock data.
                CustomPicker(viewModel: viewModel.vmPickerFrequency)
                // Conditionally show the interval picker if the selected frequency is intraday.
                if viewModel.vmPickerFrequency.selectedOption == .TIME_SERIES_INTRADAY {
                    CustomPicker(viewModel: viewModel.vmPickerInterval)
                }
            }
            // Chart displaying the stock data.
            Chart(viewModel.stockData) { dataPoint in
                LineMark(
                    x: .value("Time", dataPoint.time),
                    y: .value("Close", dataPoint.close)
                )
                .foregroundStyle(.blue)
            }
            .padding()
        }
    }
}
