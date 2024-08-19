//
//  CustomPickerViewModelTests.swift
//  FinHubTests
//
//  Created by Priyabrata Chowley on 19/08/24.
//

import XCTest
import SwiftUI
@testable import FinHub

enum TestOption: String, Pickerable, CaseIterable {
    case optionOne = "Option 1"
    case optionTwo = "Option 2"
    
    var description: String {
        return self.rawValue
    }
}


class CustomPickerViewModelTests: XCTestCase {
    
    // Define a mock option that conforms to Pickerable
    struct TestOption: Pickerable {
        let value: String
        
        var description: String { value }
        
        static func == (lhs: TestOption, rhs: TestOption) -> Bool {
            lhs.value == rhs.value
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
    }
    
    func testInitialSelection() {
        // Given
        let options = [TestOption(value: "Option 1"), TestOption(value: "Option 2")]
        let viewModel = CustomPickerViewModel(options: options)
        
        // When
        let selectedOption = viewModel.selectedOption
        
        // Then
        XCTAssertEqual(selectedOption.value, "Option 1")
    }
    
    func testOptionSelection() {
        // Given
        let options = [TestOption(value: "Option 1"), TestOption(value: "Option 2")]
        let viewModel = CustomPickerViewModel(options: options)
        
        // When
        viewModel.selectedOption = options[1]
        
        // Then
        XCTAssertEqual(viewModel.selectedOption.value, "Option 2")
    }
}
