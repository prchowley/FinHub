//
//  CachedAsyncImage.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// A view that asynchronously loads and caches an image from a given URL.
///
/// The `CachedAsyncImage` uses the `AsyncImageLoader` class to load an image from the network and cache it. The view displays the image, a placeholder if the image is loading, or an error indicator if loading fails.
struct CachedAsyncImage: View {
    /// The asynchronous image loader instance that handles image fetching and caching.
    @StateObject private var loader: AsyncImageLoader
    /// The URL of the image to be loaded.
    private let url: URL
    
    /// Initializes the `CachedAsyncImage` with a specific URL.
    /// - Parameter url: The URL of the image to load.
    init(url: URL) {
        self._loader = StateObject(wrappedValue: AsyncImageLoader(url: url))
        self.url = url
    }
    
    var body: some View {
        content
            .onAppear {
                // Trigger image loading when the view appears
                loader.loadImage()
            }
    }
    
    /// The view content based on the image loading state.
    private var content: some View {
        Group {
            // Display the image if it is successfully loaded
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            // Display a placeholder image if there is an error
            else if loader.error != nil {
                Image(systemName: "photo.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            // Display a progress view while the image is loading
            else {
                ProgressView()
            }
        }
    }
}
