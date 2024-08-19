//
//  KeyProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import Foundation
import Security

enum KeyType: String {
    case alpha
    case finnhub
}

protocol KeyService {
    func get(for type: KeyType) -> String
    func save(token: String, for type: KeyType)
}

class KeyProvider: KeyService {
    
    static let shared = KeyProvider()
    
    private init() { }
    
    func get(for type: KeyType) -> String {
        return retrieveTokenFromKeychain(key: type.rawValue) ?? "default_token_if_not_found"
    }
        
    func save(token: String, for type: KeyType) {
        let data = token.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.rawValue,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func retrieveTokenFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
}
