//
//  EndEditingModifier.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 16/08/24.
//

import SwiftUI

/// A view modifier that dismisses the keyboard when tapping outside of a text input field.
///
/// This modifier allows for the automatic dismissal of the keyboard when a user taps anywhere outside of a text field or other input controls.
struct EndEditingModifier: ViewModifier {
    /// Applies the modifier to the view, setting up a tap gesture to dismiss the keyboard.
    /// - Parameter content: The content view to which the modifier is applied.
    /// - Returns: A view with the modifier applied.
    func body(content: Content) -> some View {
        content
            .background(
                // Transparent background to detect tap gestures
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Dismiss the keyboard when tapping outside
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
    }
}

extension View {
    /// Applies the `EndEditingModifier` to the view, enabling keyboard dismissal on tap.
    ///
    /// This extension method makes it easy to use the `EndEditingModifier` on any view.
    /// - Returns: A view with the `EndEditingModifier` applied.
    func endEditingOnTap() -> some View {
        self.modifier(EndEditingModifier())
    }
}

extension UIApplication {
    /// Dismisses the keyboard if it is currently being displayed.
    ///
    /// This method programmatically triggers the resignation of the first responder, which hides the keyboard.
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
