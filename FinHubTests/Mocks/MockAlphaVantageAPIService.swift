//
//  MockAlphaVantageAPIService.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 18/08/24.
//

@testable import FinHub
import XCTest

class MockAlphaVantageAPIService: AlphaVantageAPIService {
    enum MockData {
        case success(AlphaGraphData)
        case error(Error)
    }
    
    var mockData: MockData?
    
    func graphData(of stockSymbol: String, with frequency: GraphFunction, and interval: GraphInterval, completion: @escaping (Result<AlphaGraphData, Error>) -> Void) {
        // Simulate a delay to mimic real network response time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            switch self.mockData {
            case .success(let graphData):
                completion(.success(graphData))
            case .error(let error):
                completion(.failure(error))
            case .none:
                let error = NSError(domain: "MockAlphaVantageAPIServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])
                completion(.failure(error))
            }
        }
    }
}
