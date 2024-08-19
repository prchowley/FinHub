//
//  GraphInterval.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

/// Represents different intervals for time series data.
enum GraphInterval: String {
    
    /// Represents a 60-minute interval.
    case min60 = "60min"
    
    /// Represents a 1-minute interval.
    case min1 = "1min"
    
    /// Represents a 5-minute interval.
    case min5 = "5min"
    
    /// Represents a 15-minute interval.
    case min15 = "15min"
    
    /// Represents a 30-minute interval.
    case min30 = "30min"
}

/// Makes `GraphInterval` conform to the `CaseIterable` protocol,
/// enabling the enumeration to provide a collection of all its cases.
extension GraphInterval: CaseIterable { }

/// Adds an `id` property to `GraphInterval` to conform to the `Identifiable` protocol.
/// The `id` is the enumeration case itself.
extension GraphInterval: Identifiable {
    var id: Self { self }
}

/// Adds a `description` property to `GraphInterval` to conform to the `CustomStringConvertible` protocol.
/// Provides a human-readable description for each case.
extension GraphInterval: CustomStringConvertible {
    var description: String {
        switch self {
        case .min1: return "1 Min"
        case .min5: return "5 Mins"
        case .min15: return "15 Mins"
        case .min30: return "30 Mins"
        case .min60: return "60 Mins"
        }
    }
}
