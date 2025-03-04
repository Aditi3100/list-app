//
//  ListItemView.swift
//  ListApp
//
//  Created by Aditi Nath on 17/11/24.
//

import SwiftUI

struct ListItemView: View {
    @Binding var itemName: String
    @Binding var isComplete: Bool
    @State var isEditing: Bool = false
    @State var text: String = ""
    @FocusState private var isFocus: Bool
    
    init(_ itemName: Binding<String>, isCompleted: Binding<Bool>) {
        self._itemName = itemName
        self._isComplete = isCompleted
        self._text = State(initialValue: itemName.wrappedValue)
        self.isFocus = false
    }
    
    var body: some View {
        if !isEditing {
            HStack(spacing: 12) {
                Image(systemName: getImageName())
                Text(itemName).strikethrough(isComplete)
                    .animation(.easeIn, value: isComplete)
            }
            .accessibilityElement(children: .combine)
            .accessibilityValue(isComplete ? "Completed" : "Not completed")
            .accessibilityHint("Double tap to toggle completion status. Triple tap to open menu.")
            .onTapGesture {
                isComplete.toggle()
            }
            .contextMenu {
                Button("Edit") {
                    isEditing = true
                    isFocus = true
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel("Edit item")
                .accessibilityHint("Double tap to edit item")
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            HStack(spacing: 12) {
                Image(systemName: "circle")
                TextField(text, text: $text)
                    .focused($isFocus)
                    .onSubmit {
                        itemName = text
                        isEditing = false
                        isFocus = false
                    }
                    .accessibilityHint("Edit item name")
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func getImageName() -> String {
        return isComplete ? "smallcircle.filled.circle" : "circle"
    }
}

#Preview {
    ListItemView(.constant("Item 1"), isCompleted: .constant(false))
}
