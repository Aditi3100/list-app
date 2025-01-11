//
//  ListCardView.swift
//  ListApp
//
//  Created by Aditi Nath on 11/12/24.
//

import SwiftUI

struct ListCardView: View {
    var listModel: ListItemModel
    let dateFormatter = DateFormatter()
    var width: CGFloat
    
    init(listModel: ListItemModel, width: CGFloat = 200) {
        self.listModel = listModel
        dateFormatter.dateStyle = .short
        self.width = width
    }
    var body: some View {
        VStack {
            cardText
                .padding()
                .padding(.top)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .aspectRatio(2/3, contentMode: .fit)
                .frame(width: self.width)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .opacity(0.1)
                        .shadow(radius: 2)
                }
            textView
        }
    }
    var textView: some View {
        VStack {
            Text(listModel.listName)
                .bold()
                .multilineTextAlignment(.center)
            Text("Created: \(dateFormatter.string(from: listModel.startDate))")
                .multilineTextAlignment(.center)
                .lineLimit(2)
            if let endDate = listModel.endDate {
                Text("Due: \(dateFormatter.string(from: endDate))")
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
    }
    var cardText: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(listModel.itemStatePair.indices, id: \.self) { index in
                    Text(listModel.itemStatePair[index].itemName)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .strikethrough(listModel.itemStatePair[index].itemState)
                        .scaledToFit()
                }
                Spacer()
            }
            Spacer()
        }
    }
}

//#Preview {
//    let listModel = ListItemModel("List 1", items: ["Item 1", "Item 2567"], states: [false, false])
//    ListCardView(listModel: listModel)
//}
