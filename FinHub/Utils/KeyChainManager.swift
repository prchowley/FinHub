//
//  KeyChainManager.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation
import Security

func saveTokenToKeychain(token: String, key: String) {
    let data = token.data(using: .utf8)!
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecValueData as String: data
    ]
    SecItemAdd(query as CFDictionary, nil)
}

func retrieveTokenFromKeychain(key: String) -> String? {
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
