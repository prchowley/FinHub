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

    /// Initializes the `CachedAsyncImage` with a specific URL.
    /// - Parameters:
    ///   - url: The URL of the image to load.
    ///   - cache: The image cache to use.
    ///   - session: The HTTP client to use for downloading the image.
    init(
        url: URL,
        cache: ImageCaching,
        session: HTTPClientProtocol
    ) {
        _loader = StateObject(
            wrappedValue: AsyncImageLoader(
                url: url,
                cache: cache,
                session: session
            )
        )
    }
    
    var body: some View {
        content
            .task {
                await loader.loadImage()
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
