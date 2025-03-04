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
        List {
            Section {
                titleSection
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color(uiColor: .systemBackground))
            
            Section {
                ForEach(listItemModel.itemStatePair.indices, id: \.self) { index in
                    ListItemView($listItemModel.itemStatePair[index].itemName, 
                               isCompleted: $listItemModel.itemStatePair[index].itemState)
                        .listRowSeparator(.hidden)
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("List item \(listItemModel.itemStatePair[index].itemName)")
                        .accessibilityHint("Double tap to toggle completion")
                }
                .onDelete(perform: deleteItem)
            }
            
            Section {
                if !isEditing {
                    addItemButton
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 4)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                } else {
                    editingNewItemView
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 4)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.insetGrouped)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
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
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(listItemModel.listName)
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(.primary)
                .accessibilityAddTraits(.isHeader)
            
            if let end = listItemModel.endDate {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)
                    Text(dateFormatter.string(from: end))
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .accessibilityLabel("Due date \(dateFormatter.string(from: end))")
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    private var addItemButton: some View {
        Button {
            withAnimation(.snappy) {
                isEditing = true
            }
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Item")
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(.body, weight: .regular))
            .foregroundStyle(.blue)
        }
        .accessibilityLabel("Add new item")
        .accessibilityHint("Double tap to add a new item to the list")
    }
    
    private var editingNewItemView: some View {
        HStack(spacing: 12) {
            Image(systemName: "circle")
                .foregroundStyle(.secondary)
            TextField("New Item", text: $text)
                .focused($isFocus)
                .textFieldStyle(.plain)
                .submitLabel(.done)
                .onSubmit {
                    addItem(itemName: text)
                    isEditing = false
                    isFocus = false
                    text = ""
                }
                .accessibilityLabel("New item text field")
                .accessibilityHint("Enter the name of your new item")
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            isFocus = true
        }
    }
    
    private var editButtonView: some View {
        Button(action: { presentAlert = true }) {
            Image(systemName: "pencil.circle")
                .font(.system(.body, weight: .regular))
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
