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
        // Create URLComponents from baseURL
        var components = URLComponents(string: baseURL)
        
        // Ensure baseURL is valid
        guard var validComponents = components else {
            return nil
        }
        
        // Check if URLComponents contains a valid scheme and host
        guard validComponents.scheme != nil, validComponents.host != nil else {
            return nil
        }
        
        // Append path
        validComponents.path = path
        
        // Append query items
        validComponents.queryItems = queryItems
        
        // Return the constructed URL
        return validComponents.url
    }
}
