//
//  ImageCacheTests.swift
//  FinHubUITests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import XCTest
@testable import FinHub // Replace with the actual module name where your ImageCache is defined

class ImageCacheTests: XCTestCase {
    
    var imageCache: ImageCache!
    var fileManager: FileManager!
    var cacheDirectory: URL!
    
    override func setUp() {
        super.setUp()
        
        fileManager = FileManager.default
        cacheDirectory = fileManager.temporaryDirectory.appendingPathComponent("ImageCacheTests")
        
        // Create a temporary directory for testing
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        // Initialize ImageCache with the temporary directory
        imageCache = ImageCache(fileManager: fileManager, cacheDirectory: cacheDirectory)
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Clean up the temporary directory
        try? fileManager.removeItem(at: cacheDirectory)
    }
    
    func testSaveImage() {
        let image = UIImage(systemName: "star")!
        let key = "testImage"
        
        imageCache.saveImage(image, forKey: key)
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        XCTAssertTrue(fileManager.fileExists(atPath: fileURL.path))
    }
    
    func testLoadImage() {
        // Create a sample image and save it to cache
        let image = UIImage(systemName: "star")!
        let key = "testImage"
        imageCache.saveImage(image, forKey: key)
        
        // Load the image from cache
        let loadedImage = imageCache.loadImage(forKey: key)
        XCTAssertNotNil(loadedImage, "Failed to load image from cache")
        
        // Convert images to PNG data for comparison
        guard let originalImageData = image.pngData() else {
            XCTFail("Failed to get PNG data from the original image")
            return
        }
        guard let loadedImageData = loadedImage?.pngData() else {
            XCTFail("Failed to get PNG data from the loaded image")
            return
        }
        
        // Ensure the image data is exactly the same
        XCTAssertEqual(originalImageData.count, loadedImageData.count, "Image data sizes do not match")
    }
    
    func testRemoveImage() {
        let image = UIImage(systemName: "star")!
        let key = "testImage"
        imageCache.saveImage(image, forKey: key)
        
        imageCache.removeImage(forKey: key)
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        XCTAssertFalse(fileManager.fileExists(atPath: fileURL.path))
    }
}
