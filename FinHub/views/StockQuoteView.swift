//
//  StockQuoteView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

struct StockQuoteView: View {
    let quote: StockQuote
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(getColor())
                
                Text("Current Price: \(quote.c, specifier: "$%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(getColor())
                
                Image(systemName: getIcon())
                    .foregroundColor(getColor())
            }

            getItem(
                systemName: "chart.bar.xaxis",
                text: "High: $\(quote.h)"
            )
            getItem(
                systemName: "chart.bar.xaxis",
                text: "Low: $\(quote.l)"
            )
            getItem(
                systemName: "chart.bar.xaxis",
                text: "Open: $\(quote.o)"
            )
            getItem(
                systemName: "clock",
                text: "Previous Close: $\(quote.pc)"
            )
        }
    }
    
    func getColor() -> Color {
        guard quote.c != quote.pc else { return .blue }
        return quote.c > quote.pc ? .green : .red
    }
    
    func getIcon() -> String {
        guard quote.c != quote.pc else { return "equal.circle.fill" }
        return quote.c > quote.pc ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
    }
    
    func getItem(systemName: String, text: String) -> some View {
        return HStack {
            Image(systemName: systemName)
            Text(text)
                .font(.subheadline)
                .bold()
        }
    }
}
