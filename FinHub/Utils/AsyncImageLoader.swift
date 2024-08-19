//
//  AsyncImageLoader.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import Foundation
import SwiftUI

class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var error: Error? = nil
    private let url: URL
    private let cache: ImageCaching
    private let session: URLSession
    
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
    
    func loadImage() {
        
        if let cachedImage = cache.loadImage(forKey: url.lastPathComponent) {
            self.image = cachedImage
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
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
            
            cache.saveImage(downloadedImage, forKey: url.lastPathComponent)
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
        task.resume()
    }
}
