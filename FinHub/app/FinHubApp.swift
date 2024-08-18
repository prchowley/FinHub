//
//  FinHubApp.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

@main
struct FinHubApp: App {
    init() {
        saveTokenToKeychain(token: "cqvfjb9r01qkoahg0cd0cqvfjb9r01qkoahg0cdg", key: "finnhub") // finnhub
        saveTokenToKeychain(token: "244JOJQ6LBPIDBD6", key: "alpha") // Alpha Vantage
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
