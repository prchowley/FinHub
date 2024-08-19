//
//  GraphFunction.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

enum GraphFunction: String {
    case TIME_SERIES_DAILY
    case TIME_SERIES_WEEKLY
    case TIME_SERIES_MONTHLY
    case TIME_SERIES_INTRADAY
    
    // Valid combinations mapping
    func getIntervals() -> [GraphInterval]? {
        switch self {
        case .TIME_SERIES_INTRADAY:
            return [.min1, .min5, .min15, .min30, .min60]
        default:
            return nil
        }
    }
}

extension GraphFunction: CaseIterable { }

extension GraphFunction: Identifiable {
    var id: Self { self }
}

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
