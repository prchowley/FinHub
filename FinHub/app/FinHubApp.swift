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
        saveTokens(keyservice: KeyProvider.shared)
    }
    
    func saveTokens(keyservice: KeyService) {
        keyservice.save(token: "cqvfjb9r01qkoahg0cd0cqvfjb9r01qkoahg0cdg", for: .finnhub)
        keyservice.save(token: "244JOJQ6LBPIDBD6", for: .alpha)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
