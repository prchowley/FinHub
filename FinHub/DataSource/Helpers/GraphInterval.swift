//
//  GraphInterval.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

enum GraphInterval: String {
    case min1 = "1min"
    case min5 = "5min"
    case min15 = "15min"
    case min30 = "30min"
    case min60 = "60min"
}

extension GraphInterval: CaseIterable { }

extension GraphInterval: Identifiable {
    var id: Self { self }
}

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
