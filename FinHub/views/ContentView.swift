//
//  ContentView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { newValue, _ in
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
                            ForEach(viewModel.stockSymbols) {
                                StockRowView(viewModel: .init(stock: $0))
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
            .onAppear {
                viewModel.prepareData()
            }
            .endEditingOnTap()
        }
    }
}

#Preview {
    ContentView()
}
