//
//  FinHubAPIProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

protocol FinHubAPIProvider {
    func fetchSymbols<T: Decodable>(completion: @escaping (Result<[T], Error>) -> Void)
    func searchSymbols<T: Decodable>(query: String, completion: @escaping (Result<T, Error>) -> Void)
    func companyProfile<T: Decodable>(symbol: String, completion: @escaping (Result<T, Error>) -> Void)
    func companyQuote<T: Decodable>(symbol: String, completion: @escaping (Result<T, Error>) -> Void)
    func graphData<T: Decodable>(symbol: String, completion: @escaping (Result<T, Error>) -> Void)
}
