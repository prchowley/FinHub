//
//  StockQuoteView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// A view that displays stock quote details, including current price, high, low, open, and previous close prices.
///
/// This view shows various metrics related to a stock's quote, such as the current price, high, low, open, and previous close prices. It also visually indicates whether the current price is higher or lower than the previous close price.
struct StockQuoteView: View {
    /// The stock quote data to be displayed.
    let quote: StockQuote
    
    /// Constructs the view that displays the stock quote details.
    ///
    /// The view displays the following metrics:
    /// - Current Price: Indicates the current price of the stock with a color and icon that reflects its change compared to the previous close price.
    /// - High: The highest price of the stock during the day.
    /// - Low: The lowest price of the stock during the day.
    /// - Open: The price of the stock when the market opened.
    /// - Previous Close: The price of the stock when the market closed on the previous trading day.
    ///
    /// - Returns: A `View` that represents the content of the `StockQuoteView`.
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
    
    /// Determines the color to use based on the current price compared to the previous close price.
    ///
    /// - Returns: A `Color` indicating whether the current price is higher, lower, or equal to the previous close price.
    func getColor() -> Color {
        guard quote.c != quote.pc else { return .blue }
        return quote.c > quote.pc ? .green : .red
    }
    
    /// Determines the icon to use based on the current price compared to the previous close price.
    ///
    /// - Returns: A `String` representing the system name of the icon to be used.
    func getIcon() -> String {
        guard quote.c != quote.pc else { return "equal.circle.fill" }
        return quote.c > quote.pc ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
    }
    
    /// Creates an item view with an icon and a text label.
    ///
    /// - Parameters:
    ///   - systemName: The system name of the icon to be displayed.
    ///   - text: The text label to be displayed next to the icon.
    /// - Returns: A `View` containing an `HStack` with an icon and a text label.
    func getItem(systemName: String, text: String) -> some View {
        return HStack {
            Image(systemName: systemName)
            Text(text)
                .font(.subheadline)
                .bold()
        }
    }
}
