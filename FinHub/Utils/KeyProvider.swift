//
//  KeyProvider.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import Foundation
import Security

/// Enumeration representing different types of keys for storage and retrieval.
///
/// The `KeyType` enum is used to specify which key or token is being accessed or stored.
enum KeyType: String {
    case alpha
    case finnhub
}

/// Protocol defining the methods for managing keys or tokens.
///
/// The `KeyService` protocol provides methods to get and save tokens associated with different key types.
protocol KeyService {
    /// Retrieves the token for a specified key type.
    ///
    /// - Parameter type: The `KeyType` indicating which token to retrieve.
    /// - Returns: The token associated with the given `KeyType`. If not found, returns a default token.
    func get(for type: KeyType) -> String
    
    /// Saves a token for a specified key type.
    ///
    /// - Parameters:
    ///   - token: The token to save.
    ///   - type: The `KeyType` indicating which token to save.
    func save(token: String, for type: KeyType)
}

/// A singleton class for managing keychain storage and retrieval.
///
/// The `KeyProvider` class implements the `KeyService` protocol and provides methods to save and retrieve tokens
/// using the iOS keychain services. It is designed as a singleton to ensure a single instance across the app.
class KeyProvider: KeyService {
    
    /// The shared singleton instance of `KeyProvider`.
    ///
    /// Use this property to access the shared `KeyProvider` instance.
    static let shared = KeyProvider()
    
    /// Private initializer to restrict instantiation from outside.
    private init() { }
    
    /// Retrieves the token for a specified key type.
    ///
    /// This method checks the keychain for the token associated with the given `KeyType`. If the token is not found,
    /// it returns a default token.
    ///
    /// - Parameter type: The `KeyType` indicating which token to retrieve.
    /// - Returns: The token associated with the given `KeyType`, or a default token if not found.
    func get(for type: KeyType) -> String {
        return retrieveTokenFromKeychain(key: type.rawValue) ?? "default_token_if_not_found"
    }
    
    /// Saves a token for a specified key type.
    ///
    /// This method stores the provided token in the keychain associated with the given `KeyType`.
    ///
    /// - Parameters:
    ///   - token: The token to save.
    ///   - type: The `KeyType` indicating which token to save.
    func save(token: String, for type: KeyType) {
        let data = token.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: type.rawValue,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    /// Retrieves a token from the keychain.
    ///
    /// This method uses the keychain services to fetch the token associated with the given key.
    ///
    /// - Parameter key: The key for which to retrieve the token.
    /// - Returns: The token if found, otherwise `nil`.
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
