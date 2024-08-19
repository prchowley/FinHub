//
//  ImageCache.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

protocol ImageCaching {
    func saveImage(_ image: UIImage, forKey key: String)
    func loadImage(forKey key: String) -> UIImage?
    func removeImage(forKey key: String)
}

class ImageCache: ImageCaching {
    static let shared: ImageCaching = ImageCache()
    private let fileManager: FileManager
    private let cacheDirectory: URL

    init(
        fileManager: FileManager = .default,
        cacheDirectory: URL? = nil
    ) {
        self.fileManager = fileManager
        self.cacheDirectory = cacheDirectory ?? fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    func saveImage(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }

    func loadImage(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }

    func removeImage(forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
}
