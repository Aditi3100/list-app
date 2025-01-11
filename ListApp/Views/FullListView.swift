//
//  FullListView.swift
//  ListApp
//
//  Created by Aditi Nath on 17/11/24.
//

import SwiftUI

struct FullListView: View {
    @Bindable var listItemModel: ListItemModel
    @State var text: String = ""
    @State private var isEditing: Bool = false
    @State var presentAlert: Bool = false
    @State var name: String
    @State var endDate: Date = .now
    @State var noEndDate = true
    @FocusState private var isFocus: Bool
    
    init(listItemModel: ListItemModel) {
        self._name = State(initialValue: listItemModel.listName)
        self._endDate = State(initialValue: listItemModel.endDate ?? .now)
        if let _ = listItemModel.endDate {
            self._noEndDate = State(initialValue: false)
        }
        self.listItemModel = listItemModel
        self.isFocus = false
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(listItemModel.listName).font(.largeTitle)
                .padding()
            
            List {
                ForEach(listItemModel.itemStatePair.indices, id: \.self) { index in
                    ListItemView($listItemModel.itemStatePair[index].itemName, isCompleted: $listItemModel.itemStatePair[index].itemState)
                        .geometryGroup()
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteItem)
                if !isEditing {
                    Button {
                        withAnimation(.snappy) {
                            isEditing = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add item")
                        }
                    }
                    .listRowBackground(Color.clear)
                } else {
                    HStack {
                        Image(systemName: "circle")
                        TextField("New Item", text: $text)
                            .focused($isFocus)
                            .onSubmit {
                                addItem(itemName: text)
                                isEditing = false
                                isFocus = false
                                text = ""
                            }
                    }
                    .onAppear{
                        isFocus = true
                    }
                    .listRowBackground(Color.clear)
                }
            }
        }
        .toolbar {
            Button(action: {presentAlert = true }) {
                Image(systemName: "pencil")
            }
        }
        .customModal($presentAlert){
            UpdateView(listName: $name,
                       endDate: $endDate,
                       noEndDate: $noEndDate,
                       cancelAction: {presentAlert = false},
                       saveAction: {
                presentAlert = false
                saveChanges()
            })
        }
    }
    
    func saveChanges() {
        guard name.isEmpty == false else { return }
        listItemModel.listName = name
        guard noEndDate == false else { return }
        listItemModel.endDate = endDate
    }
    
    func addItem(itemName: String) {
        guard itemName.isEmpty == false else { return }
        listItemModel.itemStatePair.append(ListItem(itemName: itemName, itemState: false))
    }
    
    func deleteItem(at offsets: IndexSet) {
        listItemModel.itemStatePair.remove(atOffsets: offsets)
    }
}

