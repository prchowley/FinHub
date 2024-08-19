//
//  AsyncImageLoaderTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import XCTest
import SwiftUI
@testable import FinHub

class AsyncImageLoaderTests: XCTestCase {
    private var url: URL!
    private var cache: ImageCaching!
    
    override func setUp() {
        super.setUp()
        url = URL(string: "https://example.com/image.png")!
        cache = MockImageCache()
    }
    
    func testInitializationWithCachedImage() {
        // Arrange
        let expectedImage = UIImage(systemName: "star")!
        cache.saveImage(expectedImage, forKey: url.lastPathComponent)
        
        // Act
        let loader = AsyncImageLoader(url: url, cache: cache, session: URLSession.shared)
        
        // Assert
        XCTAssertNotNil(loader.image)
        XCTAssertNil(loader.error)
        XCTAssertEqual(loader.image, expectedImage)
    }
    
    func testImageLoadingFromURL() {
        // Arrange
        let imageData = UIImage(systemName: "star")!.pngData()
        let urlSessionMock = URLSessionMock(data: imageData, response: nil, error: nil)
        let loader = AsyncImageLoader(url: url, cache: cache, session: urlSessionMock)
        
        // Act
        let expectation = self.expectation(description: "Image should be loaded")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let image = loader.image {
                XCTAssertNotNil(image)
                expectation.fulfill()
            }
        }
        
        // Assert
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testImageLoadingFailure() {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        let urlSessionMock = URLSessionMock(data: nil, response: nil, error: expectedError)
        let loader = AsyncImageLoader(url: url, cache: cache, session: urlSessionMock)
        
        // Act
        let expectation = self.expectation(description: "Error should be handled")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let error = loader.error as NSError? {
                XCTAssertEqual(error.domain, "TestError")
                XCTAssertEqual(error.code, 1)
                expectation.fulfill()
            }
        }
        
        // Assert
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
