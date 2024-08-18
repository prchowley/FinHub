//
//  FinHubWebSocket.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation
import Combine

class FinHubWebSocket: NSObject, ObservableObject {
    @Published var message: String = ""
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect(to url: URL) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
    }
    
    func send(message: String) {
        guard let webSocketTask = webSocketTask else { return }
        
        webSocketTask.send(.string(message), completionHandler: { error in
            if let error = error {
                debugPrint("Error sending message: \(error)")
            } else {
                debugPrint("Message sent successfully")
            }
        })
        
        webSocketTask.receive { result in
            guard let message = try? result.get() else { return }
            
            switch message {
            case .string(let text): debugPrint(text)
            case .data(let data):
                guard let s = String(data: data, encoding: .utf8) else { return }
                debugPrint(s)
            default: break
            }
        }
    }
    
    func close() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
