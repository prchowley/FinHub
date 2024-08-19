//
//  AsyncImageLoader.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation
import SwiftUI

/// A class responsible for asynchronously loading an image from a URL and caching it.
///
/// The `AsyncImageLoader` class loads an image from a URL, caches it for future use, and handles errors during the image loading process.
/// It conforms to `ObservableObject` so that it can be used in SwiftUI views to observe changes to the image and error properties.
class AsyncImageLoader: ObservableObject {
    /// The loaded image, if available.
    @Published var image: UIImage? = nil
    
    /// The error encountered during image loading, if any.
    @Published var error: Error? = nil
    
    private let url: URL
    private let cache: ImageCaching
    private let session: URLSession
    
    /// Initializes a new `AsyncImageLoader` instance.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to be loaded.
    ///   - cache: The `ImageCaching` instance used to cache the image. Defaults to `ImageCache.shared`.
    ///   - session: The `URLSession` instance used for network operations. Defaults to `.shared`.
    init(
        url: URL,
        cache: ImageCaching = ImageCache.shared,
        session: URLSession = .shared
    ) {
        self.session = session
        self.cache = cache
        self.url = url
        loadImage()
    }
    
    /// Loads the image from the URL.
    ///
    /// If the image is already cached, it will be loaded from the cache. Otherwise, a network request will be made to download the image.
    /// The image will be cached for future use once it is successfully downloaded.
    func loadImage() {
        // Check if the image is available in the cache
        if let cachedImage = cache.loadImage(forKey: url.lastPathComponent) {
            self.image = cachedImage
            return
        }
        
        // If not cached, download the image from the URL
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.error = error
                }
                return
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.error = NSError(domain: "Invalid Image Data", code: 0, userInfo: nil)
                }
                return
            }
            
            // Cache the downloaded image
            cache.saveImage(downloadedImage, forKey: self.url.lastPathComponent)
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
        task.resume()
    }
}
