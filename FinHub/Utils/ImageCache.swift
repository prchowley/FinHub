//
//  ImageCache.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// A protocol defining methods for caching images.
///
/// The `ImageCaching` protocol provides methods to save, load, and remove images from cache.
protocol ImageCaching {
    /// Saves an image to the cache with a specified key.
    ///
    /// - Parameters:
    ///   - image: The `UIImage` to be saved.
    ///   - key: A unique key to associate with the image.
    func saveImage(_ image: UIImage, forKey key: String)
    
    /// Loads an image from the cache using a specified key.
    ///
    /// - Parameter key: The key associated with the image to be loaded.
    /// - Returns: The `UIImage` if found, otherwise `nil`.
    func loadImage(forKey key: String) -> UIImage?
    
    /// Removes an image from the cache using a specified key.
    ///
    /// - Parameter key: The key associated with the image to be removed.
    func removeImage(forKey key: String)
}

/// A class for caching images using the file system.
///
/// The `ImageCache` class implements the `ImageCaching` protocol and uses the file system to save, load, and remove
/// images. It is designed as a singleton for easy access throughout the application.
class ImageCache: ImageCaching {
    /// The shared singleton instance of `ImageCache`.
    ///
    /// Use this property to access the shared `ImageCache` instance.
    static let shared: ImageCaching = ImageCache()
    
    private let fileManager: FileManager
    private let cacheDirectory: URL
    
    /// Initializes a new `ImageCache` instance.
    ///
    /// - Parameters:
    ///   - fileManager: The `FileManager` instance to use for file operations. Defaults to the shared file manager.
    ///   - cacheDirectory: The directory where cached images will be stored. If `nil`, the default caches directory will be used.
    init(
        fileManager: FileManager = .default,
        cacheDirectory: URL? = nil
    ) {
        self.fileManager = fileManager
        self.cacheDirectory = cacheDirectory ?? fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    /// Saves an image to the cache with a specified key.
    ///
    /// This method converts the `UIImage` to PNG data and writes it to a file in the cache directory.
    ///
    /// - Parameters:
    ///   - image: The `UIImage` to be saved.
    ///   - key: A unique key to associate with the image.
    func saveImage(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }

    /// Loads an image from the cache using a specified key.
    ///
    /// This method reads the image data from a file in the cache directory and initializes a `UIImage` from the data.
    ///
    /// - Parameter key: The key associated with the image to be loaded.
    /// - Returns: The `UIImage` if found, otherwise `nil`.
    func loadImage(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }

    /// Removes an image from the cache using a specified key.
    ///
    /// This method deletes the file associated with the given key from the cache directory.
    ///
    /// - Parameter key: The key associated with the image to be removed.
    func removeImage(forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
}
