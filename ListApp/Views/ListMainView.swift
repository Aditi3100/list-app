//
//  ListMainView.swift
//  ListApp
//
//  Created by Aditi Nath on 12/12/24.
//

import SwiftUI
import SwiftData

struct ListMainView: View {
    @Environment(\.modelContext) var modelContext
    @State var editMode = false
    @State var deleteListItem: ListItemModel? = nil
    @State var showConfirmationDialog = false
    @Query var listArray: [ListItemModel]
    @State var path = [ListItemModel] ()
    @State var sortOption: ListMainSortingOptions = .alphabet
    let columnWidth: CGFloat = 200
    var body: some View {
        NavigationStack(path: $path) {
            if listArray.count > 0 {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: columnWidth), alignment: .top)
                    ], spacing: 20) {
                        if editMode {
                            NewCardView(width: columnWidth)
                                .onTapGesture {
                                    addNewList()
                                }
                                .accessibilityLabel("Create new list")
                                .accessibilityHint("Double tap to create a new list")
                        
                        }
                        ForEach(listArraySortByOption, id: \.id) { item in
                            NavigationLink(value: item) {
                                ZStack(alignment: .topLeading) {
                                    if editMode {
                                        trashBadgeButton(item)
                                    }
                                    ListCardView(listModel: item, width: columnWidth)
                                        .disabled(editMode)
                                }
                            }
                            .accessibilityLabel("\(item.listName)")
                            .accessibilityHint(editMode ? "Double tap to delete list." : "Double tap to view list details")
                        }
                    }
                    .padding(16)
                }
                .navigationTitle(Text("Your Lists"))
                .navigationDestination(for: ListItemModel.self, destination: ListDetailsView.init)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 5) {
                            editButton
                            sortButtonView
                        }
                    }
                }
                .confirmationDialog("",
                                    isPresented: $showConfirmationDialog,
                                    titleVisibility: .hidden,
                                    presenting: deleteListItem
                ){ item in
                    confirmDeleteButton(item)
                    cancelButton
                }
            } else {
                noListView
            }
        }
    }
    
    @ViewBuilder
    func trashBadgeButton(_ item: ListItemModel) -> some View {
        Button(action: {
            deleteListItem = item
            showConfirmationDialog = true
        }) {
            Image(systemName: "trash.square")
                .resizable()
                .scaledToFill()
                .foregroundStyle(Color.red)
                .frame(
                    width: 30,
                    height: 30
                )
        }
        .padding(5)
        .accessibilityLabel("Delete \(item.listName)")
        .accessibilityHint("Double tap to delete this list")
    }
    
    @ViewBuilder
    var editButton: some View {
        Button(action: { editMode.toggle() }) {
            if editMode {
                Text("Done")
            }
            else {
                Text("Edit")
            }
        }
        .accessibilityLabel("Edit mode")
        .accessibilityHint("Double tap to toggle edit mode")
    }
    
    @ViewBuilder
    var sortButtonView: some View {
        Menu( content: {
            SortButtonView("A-Z", isChecked: sortOption == .alphabet) {
                sortOption = .alphabet
            }
            SortButtonView("Earliest deadline", isChecked: sortOption == .dueFirst) {
                sortOption = .dueFirst
            }
            SortButtonView("Earliest created", isChecked: sortOption == .createFirst) {
                sortOption = .createFirst
            }
            SortButtonView("Latest created", isChecked: sortOption == .createLast) {
                sortOption = .createLast
            }
        }, label:  {
            Text("Sort")
        })
        .accessibilityLabel("Sort lists")
        .accessibilityHint("Double tap to show sorting options")
    }
    
    @ViewBuilder
    func confirmDeleteButton(_ item: ListItemModel) -> some View {
        Button("Delete \(deleteListItem?.listName ?? "")",
               role: .destructive) {
            deleteList(item: item)
            deleteListItem = nil
        }
        .accessibilityLabel("Delete \(deleteListItem?.listName ?? "")")
        .accessibilityHint("Double tap to confirm deletion")
    }
    
    @ViewBuilder
    var cancelButton: some View {
        Button("Cancel", role: .cancel) {
            deleteListItem = nil
        }
        .accessibilityLabel("Cancel deletion")
        .accessibilityHint("Double tap to cancel deletion")
    }
    
    @ViewBuilder
    var noListView: some View {
        VStack {
            Text("You have not created any lists yet!")
            Button("Get started!") {
                addNewList()
            }
        }
        .navigationTitle(Text("Your Lists"))
        .accessibilityLabel("No lists created")
        .accessibilityHint("Double tap to add a new list")
    }
    
    func findDefaultName() -> String {
        var num = 1
        let name = listArray.filter{ item in
            let str = item.listName
            guard str.hasPrefix("List") else {return false}
            let arr = str.split(separator: " ")
            guard arr.count == 2 else {return false}
            return arr[0] == "List" && Int(arr[1]) != nil
        }
            .map { $0.listName }
            .sorted()
            .last
        if let name = name {
            let number = Int(name.split(separator: " ")[1])
            if let number = number {
                num = number + 1
            }
        }
        return "List " + String(num)
    }
    
    func addNewList() {
        let newListName = findDefaultName()
        let listItemModel = ListItemModel(newListName)
        modelContext.insert(listItemModel)
        editMode = false
        path = [listItemModel]
    }
    func deleteList(item: ListItemModel) {
        let index = listArray.firstIndex(where: {$0.id == item.id})
        guard let offset = index else { return }
        let itemModel = listArray[offset]
        modelContext.delete(itemModel)
    }
}

struct NewCardView: View {
    var width: CGFloat
    init(width: CGFloat = 200) {
        self.width = width
    }
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                .opacity(0.1)
                .shadow(radius: 2)
                .aspectRatio(2/3, contentMode: .fit)
                .frame(width: width)
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: width/4)
        }
        .foregroundStyle(Color.blue)
    }
}

#Preview {
    ListMainView()
}
