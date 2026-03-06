//
//  Dependencies.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 06/03/26.
//

import SwiftUI

struct KeyServiceKey: EnvironmentKey {
    static let defaultValue: KeyService = KeyProvider()
}

extension EnvironmentValues {
    var keyService: KeyService {
        get { self[KeyServiceKey.self] }
        set { self[KeyServiceKey.self] = newValue }
    }
}

struct KeyHTTPClient: EnvironmentKey {
    static let defaultValue: HTTPClientProtocol = HTTPClient()
}

extension EnvironmentValues {
    var httpClient: HTTPClientProtocol {
        get { self[KeyHTTPClient.self] }
        set { self[KeyHTTPClient.self] = newValue }
    }
}

struct KeyImageCache: EnvironmentKey {
    static let defaultValue: ImageCaching = ImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCaching {
        get { self[KeyImageCache.self] }
        set { self[KeyImageCache.self] = newValue }
    }
}
