//
//  APIEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

/// Protocol defining the requirements for an endpoint provider.
protocol EndpointProvider {
    /// The base URL for the endpoint.
    var baseURL: String { get }
    
    /// The API key required for authentication.
    var apiKey: String { get }
    
    /// The specific path for the endpoint.
    var path: String { get }
    
    /// The query items to be included in the URL.
    var queryItems: [URLQueryItem] { get }
}

extension EndpointProvider {
    /// Computed property that constructs and returns a URL from the endpoint's components.
    var url: URL? {
        // Create URLComponents from the base URL string.
        var components = URLComponents(string: baseURL)
        
        // Ensure the base URL is valid.
        guard var validComponents = components else {
            return nil
        }
        
        // Check if the URLComponents contains a valid scheme and host.
        guard validComponents.scheme != nil, validComponents.host != nil else {
            return nil
        }
        
        // Append the path to the URLComponents.
        validComponents.path = path
        
        // Append the query items to the URLComponents.
        validComponents.queryItems = queryItems
        
        // Return the constructed URL.
        return validComponents.url
    }
}
