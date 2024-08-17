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
        CachedAsyncImage(url: URL(string: imageUrlString))
            .frame(width: 100, height: 100)
            .cornerRadius(50)
    }
}
