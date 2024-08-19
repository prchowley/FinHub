//
//  CustomPicker.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import SwiftUI

/// A type alias for types that are both hashable and provide a description.
typealias Pickerable = Hashable & CustomStringConvertible

/// A custom picker view that displays a menu with selectable options.
///
/// This view allows users to choose from a list of options in a dropdown menu format.
/// The selected option is displayed on the picker, and the user can select different options from the menu.
///
/// - Parameter T: A generic type conforming to `Pickerable`.
struct CustomPicker<T: Pickerable>: View {
    
    @StateObject var viewModel: CustomPickerViewModel<T>
    
    /// Creates the view that displays a menu with selectable options.
    ///
    /// The view shows the currently selected option and a menu with other available options.
    /// - Returns: A `View` that represents the custom picker.
    var body: some View {
        Menu {
            ForEach(viewModel.options, id: \.self) { option in
                Button(action: {
                    viewModel.selectedOption = option
                }) {
                    Text(option.description)
                }
            }
        } label: {
            HStack {
                Text(viewModel.selectedOption.description)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
            }
            .padding()
            .frame(height: 50)
            .frame(minWidth: 100, maxWidth: 150)
            .background(Color.blue)
            .clipShape(Capsule())
            .shadow(color: .gray, radius: 10, x: 0, y: 8)
        }
    }
}

/// A view model that manages the state and options for a custom picker.
///
/// This view model holds the available options and tracks the currently selected option.
class CustomPickerViewModel<T: Pickerable>: ObservableObject {
    
    /// The list of available options for the picker.
    let options: [T]
    
    /// The currently selected option.
    @Published var selectedOption: T
    
    /// Initializes the view model with a list of options and sets the initial selected option.
    /// - Parameter options: The list of options to display in the picker.
    init(options: [T]) {
        self.options = options
        self.selectedOption = options.first!
    }
}

#Preview {
    CustomPicker(
        viewModel: .init(
            options: GraphFunction.allCases
        )
    )
}
