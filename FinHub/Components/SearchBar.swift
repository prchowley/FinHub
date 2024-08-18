//
//  SearchBar.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search stocks", text: $text)
                .padding(7)
                .padding(.horizontal, 30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 2)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        if isEditing {
                            Button(action: {
                                self.isEditing = false
                                UIApplication.shared.endEditing()
                                self.text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
                .onSubmit {
                    self.isEditing = false
                }
                .transition(.opacity)
        }
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
