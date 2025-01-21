//
//  SortButtonView.swift
//  ListApp
//
//  Created by Aditi Nath on 21/01/25.
//
import SwiftUI

struct SortButtonView: View {
    var buttonName: String
    var isChecked: Bool
    var actions: () -> Void
    
    init(_ buttonName: String, isChecked: Bool, actions: @escaping () -> Void) {
        self.buttonName = buttonName
        self.isChecked = isChecked
        self.actions = actions
    }
    
    var body: some View {
        Button(action: actions) {
            HStack {
                Text(buttonName)
                Spacer()
                if isChecked {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
