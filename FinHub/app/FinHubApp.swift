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
        saveTokenToKeychain(token: "REDUCTED", key: "finnhub") // finnhub
        saveTokenToKeychain(token: "REDUCTED", key: "alpha") // Alpha Vantage
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
