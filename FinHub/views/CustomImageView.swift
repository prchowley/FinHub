//
//  CustomImageView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

import SwiftUI

/// A view that displays an image fetched from a URL with caching support.
///
/// This view attempts to load an image from the provided URL string using `CachedAsyncImage`. The image is displayed in a circular frame with a fixed size. If the URL string is invalid, an empty view is shown.
struct CustomImageView: View {
    /// The URL string of the image to be displayed.
    let imageUrlString: String
    
    /// Constructs the view that displays the image.
    ///
    /// The view will display the image fetched from the URL provided in `imageUrlString`. If the URL string is invalid, an empty view is shown. The image is displayed in a circular frame with a width and height of 100 points.
    ///
    /// - Returns: A `View` that represents the content of the `CustomImageView`.
    var body: some View {
        if let url = URL(string: imageUrlString) {
            CachedAsyncImage(url: url)
                .frame(width: 100, height: 100)
                .cornerRadius(50) // Makes the image circular
        } else {
            EmptyView() // Placeholder view when URL is invalid
        }
    }
}
