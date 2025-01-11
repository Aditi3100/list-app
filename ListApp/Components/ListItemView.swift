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
    
    init(_ itemName: Binding<String>, isCompleted: Binding<Bool>) {
        self._itemName = itemName
        self._isComplete = isCompleted
    }
    
    var body: some View {
        HStack {
            Image(systemName: getImageName())
                Text(itemName).strikethrough(isComplete)
                    .animation(.easeIn, value: isComplete)
                    .onTapGesture {
                        isComplete.toggle()
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
