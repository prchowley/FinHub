//
//  FinHubApp.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// The main entry point of the FinHub application.
///
/// The `FinHubApp` struct conforms to the `App` protocol and initializes the application. It sets up necessary services
/// and provides the initial scene for the app.
@main
struct FinHubApp: App {
    
    @Environment(\.keyService) var keyService
    @Environment(\.httpClient) var httpClient

    /// Saves the API tokens for different services.
    ///
    /// This method saves the tokens needed for accessing external APIs, such as Finnhub and Alpha Vantage.
    ///
    /// - Parameter keyservice: The `KeyService` instance used to save the tokens.
    func saveTokens(keyservice: KeyService) {
        keyservice.save(token: "cqvfjb9r01qkoahg0cd0cqvfjb9r01qkoahg0cdg", for: .finnhub)
        keyservice.save(token: "244JOJQ6LBPIDBD6", for: .alpha)
    }
    
    /// The main scene of the application.
    ///
    /// This property defines the initial view for the app, which is presented in the window group.
    var body: some Scene {
        WindowGroup {
            ContentView(
                finnhubAPI: FinHubAPIProvider(
                    httpClient: httpClient,
                    keyService: keyService
                )
            )
        }
    }
}
