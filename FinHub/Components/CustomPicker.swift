//
//  CustomPicker.swift
//  FinHub
//
//  Created by Priyabrata Chowley on 17/08/24.
//

import SwiftUI

typealias Pickerable = Hashable & CustomStringConvertible

struct CustomPicker<T: Pickerable>: View {
    
    @StateObject var viewModel: CustomPickerViewModel<T>
    
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


class CustomPickerViewModel<T: Pickerable>: ObservableObject {
    
    let options: [T]
    @Published var selectedOption: T
    
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
