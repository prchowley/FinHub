//
//  AlphaVantageAPIProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import Foundation

protocol AlphaVantageAPIService {
    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval, completion: @escaping (Result<AlphaGraphData, Error>) -> Void)
}

class AlphaVantageAPIProvider: AlphaVantageAPIService {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient = HTTPClient()) {
        self.httpClient = httpClient
    }

    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval, completion: @escaping (Result<AlphaGraphData, Error>) -> Void) {
        httpClient.request(endpoint: AlphaVantageEndpoint.graph(f: frequency, symbol: stockSymbol, interval: interval), completion: completion)
    }
}
