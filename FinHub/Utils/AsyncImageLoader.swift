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
    private var url: URL?
    
    init(url: URL?) {
        self.url = url
        loadImage()
    }
    
    func loadImage() {
        guard let url = url else { return }
        
        if let cachedImage = ImageCache.shared.image(for: url) {
            self.image = cachedImage
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
            
            ImageCache.shared.setImage(downloadedImage, for: url)
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
        task.resume()
    }
}
