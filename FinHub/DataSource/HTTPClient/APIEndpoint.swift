//
//  APIEndpoint.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation

protocol APIKeyProvider {

    /// The API key required for authentication.
    var apiKey: String { get }
}

/// Protocol defining the requirements for an endpoint provider.
protocol EndpointProvider {

    /// The base URL for the endpoint.
    var baseURL: String { get }
    
    /// The specific path for the endpoint.
    var path: String { get }
    
    /// The query items to be included in the URL.
    var queryItems: [URLQueryItem] { get }
}

extension EndpointProvider {
    /// Computed property that constructs and returns a URL from the endpoint's components.
    var url: URL? {
        // Create URLComponents from the base URL string.
        guard var components = URLComponents(string: baseURL) else {
            return nil
        }
        
        // Ensure the base URL is valid.
        guard components.scheme != nil, components.host != nil else {
            return nil
        }
        
        // Append the path to the URLComponents, ensuring there is no double slashing.
        if !path.isEmpty {
            // Remove any leading slash from the path if the base URL already ends with a slash
            let trimmedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
            components.path = "\(components.path)/\(trimmedPath)"
        }
        
        // Append the query items to the URLComponents, but only if they exist.
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        } else {
            components.queryItems = nil
        }
        
        // Return the constructed URL.
        return components.url
    }
}
