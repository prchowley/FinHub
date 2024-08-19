//
//  GraphFunction.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

/// Represents different types of time series data functions that can be fetched.
enum GraphFunction: String {
    
    /// Represents daily time series data.
    case TIME_SERIES_DAILY
    
    /// Represents weekly time series data.
    case TIME_SERIES_WEEKLY
    
    /// Represents monthly time series data.
    case TIME_SERIES_MONTHLY
    
    /// Represents intraday time series data.
    case TIME_SERIES_INTRADAY
    
    /// Returns a list of valid intervals for the given time series function.
    /// - Returns: An array of `GraphInterval` values if the function is `.TIME_SERIES_INTRADAY`, otherwise `nil`.
    func getIntervals() -> [GraphInterval]? {
        switch self {
        case .TIME_SERIES_INTRADAY:
            return [.min1, .min5, .min15, .min30, .min60]
        default:
            return nil
        }
    }
}

/// Makes `GraphFunction` conform to the `CaseIterable` protocol,
/// enabling the enumeration to provide a collection of all its cases.
extension GraphFunction: CaseIterable { }

/// Adds an `id` property to `GraphFunction` to conform to the `Identifiable` protocol.
/// The `id` is the enumeration case itself.
extension GraphFunction: Identifiable {
    var id: Self { self }
}

/// Adds a `description` property to `GraphFunction` to conform to the `CustomStringConvertible` protocol.
/// Provides a human-readable description for each case.
extension GraphFunction: CustomStringConvertible {
    var description: String {
        switch self {
        case .TIME_SERIES_INTRADAY: return "Intra-Day"
        case .TIME_SERIES_DAILY: return "Daily"
        case .TIME_SERIES_WEEKLY: return "Weekly"
        case .TIME_SERIES_MONTHLY: return "Monthly"
        }
    }
}
