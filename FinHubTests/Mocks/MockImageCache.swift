//
//  MockImageCache.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import Foundation
import SwiftUI
@testable import FinHub

// Mock implementation of ImageCaching
class MockImageCache: ImageCaching {
    func removeImage(forKey key: String) {
        //
    }
    
    private var cache: [String: UIImage] = [:]
    
    func loadImage(forKey key: String) -> UIImage? {
        return cache[key]
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        cache[key] = image
    }
}
