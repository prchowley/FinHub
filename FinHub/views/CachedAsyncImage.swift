//
//  CachedAsyncImage.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

struct CachedAsyncImage: View {
    @StateObject private var loader: AsyncImageLoader
    private let url: URL?
    
    init(url: URL?) {
        self._loader = StateObject(wrappedValue: AsyncImageLoader(url: url))
        self.url = url
    }
    
    var body: some View {
        content
            .onAppear {
                loader.loadImage()
            }
    }
    
    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if loader.error != nil {
                Image(systemName: "photo.fill")
                    .resizable()
                    .foregroundColor(.gray)
            } else {
                ProgressView()
            }
        }
    }
}
