//
//  SearchBar.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// A view that displays a customizable search bar with a text field and optional clear button.
///
/// The `SearchBar` allows users to input search text and provides a clear button to reset the search field when editing. It also includes a magnifying glass icon to indicate the search functionality.
struct SearchBar: View {
    /// A binding to the text value that represents the current search query.
    @Binding var text: String
    
    /// A state variable that indicates whether the search bar is being edited.
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
                        // Magnifying glass icon for search
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        // Clear button that appears when editing
                        if isEditing {
                            Button(action: {
                                // Clear the search text and end editing
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
                    // Set editing state to true when tapped
                    self.isEditing = true
                }
                .onSubmit {
                    // End editing when the user submits input
                    self.isEditing = false
                }
                .transition(.opacity)
        }
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
