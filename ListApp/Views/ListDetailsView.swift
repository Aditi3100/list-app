//
//  ListDetailsView.swift
//  ListApp
//
//  Created by Aditi Nath on 17/11/24.
//

import SwiftUI
import Foundation

struct ListDetailsView: View {
    @Bindable var listItemModel: ListItemModel
    @State var text: String = ""
    @State private var isEditing: Bool = false
    @State var presentAlert: Bool = false
    @State var name: String
    @State var endDate: Date = .now
    @State var noEndDate = true
    @FocusState private var isFocus: Bool
    @State private var isKeyboardVisible: Bool = false
    private let dateFormatter = DateFormatter()
    
    init(listItemModel: ListItemModel) {
        self._name = State(initialValue: listItemModel.listName)
        self._endDate = State(initialValue: listItemModel.endDate ?? .now)
        if let _ = listItemModel.endDate {
            self._noEndDate = State(initialValue: false)
        }
        self.listItemModel = listItemModel
        self.isFocus = false
        dateFormatter.dateStyle = .short
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            titleView
            List {
                ForEach(listItemModel.itemStatePair.indices, id: \.self) { index in
                    ListItemView($listItemModel.itemStatePair[index].itemName, isCompleted: $listItemModel.itemStatePair[index].itemState)
                        .geometryGroup()
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteItem)
                if !isEditing {
                    addItemButton
                        .listRowBackground(Color.clear)
                } else {
                    editingNewItemView
                        .listRowBackground(Color.clear)
                }
            }
            .accessibilityLabel("Items in \(listItemModel.listName)")
        }
        .onReceive(keyboardPublisher) { value in
            isKeyboardVisible = value
        }
        .navigationBarBackButtonHidden(isKeyboardVisible)
        .toolbar {
            editButtonView
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
    
    @ViewBuilder
    var titleView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(listItemModel.listName).font(.largeTitle)
                .accessibilityAddTraits(.isHeader)
            if let end = listItemModel.endDate {
                Text("Due: \(dateFormatter.string(from: end))")
                    .font(.body)
                    .opacity(0.5)
                    .accessibilityLabel("Due date \(dateFormatter.string(from: end))")
            }
        }
        .padding()
    }
    
    @ViewBuilder
    var addItemButton: some View {
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
        .accessibilityLabel("Add new item")
        .accessibilityHint("Double tap to add a new item to the list")
    }
    
    @ViewBuilder
    var editingNewItemView: some View {
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
        .accessibilityHint("Enter the name of your new item")
        .onAppear{
            isFocus = true
        }
    }
    
    @ViewBuilder
    var editButtonView: some View {
        Button(action: {presentAlert = true }) {
            Image(systemName: "pencil")
        }
        .disabled(isKeyboardVisible)
        .accessibilityLabel("Edit list details")
        .accessibilityHint("Double tap to edit list name and due date")
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

