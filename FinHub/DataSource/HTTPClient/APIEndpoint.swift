//
//  APIEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

protocol EndpointProvider {
    var baseURL: String { get }
    var apiKey: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension EndpointProvider {
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
