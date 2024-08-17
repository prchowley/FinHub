//
//  ImageCache.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

class ImageCache {
    
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() { }
    
    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
