//
//  AsyncImageLoader.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation
import SwiftUI

struct ImageEndpoint: EndpointProvider {
    var baseURL: String
    var path: String = ""
    var queryItems: [URLQueryItem] = []
    
    init(url: URL) {
        self.baseURL = url.absoluteString
    }
}

// MARK: - AsyncImageLoader

/// A class responsible for asynchronously loading an image from a URL and caching it.
///
/// The `AsyncImageLoader` class loads an image from a URL, caches it for future use, and handles errors during the image loading process.
/// It conforms to `ObservableObject` so that it can be used in SwiftUI views to observe changes to the image and error properties.
@MainActor
class AsyncImageLoader: ObservableObject {
    /// The loaded image, if available.
    @Published var image: UIImage? = nil
    
    /// The error encountered during image loading, if any.
    @Published var error: Error? = nil
    
    private let url: URL
    private let cache: ImageCaching
    private let session: HTTPClientProtocol
    
    /// Initializes a new `AsyncImageLoader` instance.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to be loaded.
    ///   - cache: The `ImageCaching` instance used to cache the image.
    ///   - session: The `HTTPClientProtocol` instance used for network operations.
    init(
        url: URL,
        cache: ImageCaching = ImageCache.shared,
        session: HTTPClientProtocol = HTTPClient.shared
    ) {
        self.url = url
        self.cache = cache
        self.session = session
        Task {
            await loadImage()
        }
    }
    
    /// Loads the image from the URL.
    ///
    /// If the image is already cached, it will be loaded from the cache. Otherwise, a network request will be made to download the image.
    /// The image will be cached for future use once it is successfully downloaded.
    func loadImage() async {
        // Check if the image is available in the cache
        if let cachedImage = cache.loadImage(forKey: url.lastPathComponent) {
            self.image = cachedImage
            return
        }
        
        do {
            // Create the ImageEndpoint instance
            let endpoint = ImageEndpoint(url: url)
            
            // Fetch the image data using HTTPClient
            let data: Data = try await session.request(endpoint: endpoint)
            
            // Convert data to UIImage
            guard let downloadedImage = UIImage(data: data) else {
                throw NSError(domain: "Invalid Image Data", code: 0, userInfo: nil)
            }
            
            // Cache the downloaded image
            cache.saveImage(downloadedImage, forKey: url.lastPathComponent)
            self.image = downloadedImage
        } catch {
            self.error = error
        }
    }
}
