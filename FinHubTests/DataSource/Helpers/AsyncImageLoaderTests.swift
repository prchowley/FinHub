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
    private var httpClient: MockHTTPClient!
    
    override func setUp() {
        super.setUp()
        url = URL(string: "https://example.com/image.png")!
        cache = MockImageCache()
        httpClient = MockHTTPClient()
    }
    
    @MainActor 
    func testInitializationWithCachedImage() async {
        // Arrange
        let expectedImage = UIImage(systemName: "star")!
        cache.saveImage(expectedImage, forKey: url.lastPathComponent)
        
        // Act
        let loader = AsyncImageLoader(url: url, cache: cache, session: httpClient)
        
        do {
            // Wait for the image loading to complete
            try await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 second to allow async operation to complete
            
            // Assert
            XCTAssertNotNil(loader.image, "The image should be loaded from cache.")
            XCTAssertNil(loader.error, "There should be no error.")
            XCTAssertEqual(loader.image, expectedImage, "The loaded image should match the expected cached image.")
        } catch {
            XCTFail("Unexpected error during sleep: \(error)")
        }
    }
    
    @MainActor 
    func testImageLoadingFromURL() async {
        // Arrange
        let expectedImage = UIImage(systemName: "star")!.pngData()!
        httpClient.mockData = .image(expectedImage)
        let loader = AsyncImageLoader(url: url, cache: cache, session: httpClient)
        
        do {
            // Act
            // Wait for the image loading to complete
            try await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 second to allow async operation to complete
            
            // Assert
            XCTAssertNotNil(loader.image, "The image should be loaded from the URL.")
            XCTAssertNil(loader.error, "There should be no error.")
        } catch {
            XCTFail("Unexpected error during sleep: \(error)")
        }
    }
    
    /// Tests the image loading failure scenario in `AsyncImageLoader`.
    @MainActor
    func testImageLoadingFailure() async {
        // Arrange
        let expectedError: NSError = NSError(domain: "TestError", code: 1, userInfo: nil)
        httpClient.mockData = .error(NetworkError.unknown(error: expectedError))
        let loader = AsyncImageLoader(url: url, cache: cache, session: httpClient)
        
        do {
            // Act
            // Sleep for 1 second to allow async operation to complete.
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Assert
            // Ensure no image is loaded.
            XCTAssertNil(loader.image, "There should be no image loaded.")
            
            // Verify the error returned by the loader.
            guard let error = loader.error as? NetworkError, case .unknown(let nsError as NSError) = error else {
                XCTFail("Expected an unknown error but got none.")
                return
            }
            
            // Assert the error domain and code.
            XCTAssertEqual(nsError.domain, "TestError", "The error domain should match.")
            XCTAssertEqual(nsError.code, 1, "The error code should match.")
        } catch {
            // Handle unexpected errors during sleep.
            XCTFail("Unexpected error during sleep: \(error)")
        }
    }
}
