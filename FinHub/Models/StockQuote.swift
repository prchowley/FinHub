//
//  StockQuote.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import Foundation

struct StockQuote: Decodable {
    let c: Double // Current price
    let h: Double // High price
    let l: Double // Low price
    let o: Double // Open price
    let pc: Double // Previous close
    
    init(c: Double, h: Double, l: Double, o: Double, pc: Double) {
        self.c = c
        self.h = h
        self.l = l
        self.o = o
        self.pc = pc
    }
}

extension StockQuote: Equatable { }
