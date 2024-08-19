//
//  CustomImageView.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

struct CustomImageView: View {
    let imageUrlString: String
    
    var body: some View {
        if let url = URL(string: imageUrlString) {
            CachedAsyncImage(url: url)
                .frame(width: 100, height: 100)
                .cornerRadius(50)
        } else {
            EmptyView() // Or use any other placeholder if desired
        }
    }
}
