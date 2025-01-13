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
        HStack {
            Image(systemName: getImageName())
            if !isEditing {
                Text(itemName).strikethrough(isComplete)
                    .animation(.easeIn, value: isComplete)
                    .onTapGesture {
                        isComplete.toggle()
                    }
                    .contextMenu {
                        Button("Edit") {
                            isEditing = true
                            isFocus = true
                        }
                    }
            } else {
                TextField(text, text: $text)
                    .focused($isFocus)
                    .onSubmit {
                        itemName = text
                        isEditing = false
                        isFocus = false
                    }
            }
        }
    }
    
    func getImageName() -> String {
        return isComplete ? "smallcircle.filled.circle" : "circle"
    }
}

#Preview {
    ListItemView(.constant("Item 1"), isCompleted: .constant(false))
}
