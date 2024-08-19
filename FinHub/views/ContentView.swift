//
//  ContentView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// The main view of the application that displays a list of stock symbols and a search bar.
///
/// This view manages the state for loading, errors, and displaying stock symbols. It provides a search bar to filter stock symbols and displays a horizontal scrollable list of stock rows.
struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @State private var searchText: String = ""
    
    @Namespace private var namespace
    
    /// Creates the view that displays the content.
    ///
    /// The view consists of a search bar, loading indicators, error messages, and a horizontal list of stock symbols.
    /// - Returns: A `View` that represents the content of the `ContentView`.
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { _, newValue in
                        viewModel.searchQuery = newValue
                    }
                    .padding()
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.stockSymbols.isEmpty {
                    Text("No data available")
                        .padding()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(viewModel.stockSymbols) { stock in
                                ScrollView(showsIndicators: false) {
                                    StockRowView(
                                        viewModel: .init(stock: stock)
                                    )
                                    .frame(minWidth: 300, idealWidth: 300, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity, alignment: .center)
                                }
                                .shadow(color: .gray, radius: 8, x: 10, y: 5)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.horizontal, 40)
                }
                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Stocks")
            .navigationBarTitleDisplayMode(.inline)
            .endEditingOnTap()
        }
    }
}

#Preview {
    ContentView()
}
