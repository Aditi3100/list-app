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
                        }
                        ForEach(listArray, id: \.id) { item in
                            NavigationLink(value: item) {
                                ZStack(alignment: .topLeading) {
                                    if editMode {
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
                                    }
                                    ListCardView(listModel: item, width: columnWidth)
                                        .disabled(editMode)
                                }
                            }
                        }
                    }
                    .padding(16)
                }
                .navigationTitle(Text("Your Lists"))
                .navigationDestination(for: ListItemModel.self, destination: FullListView.init)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { editMode.toggle() }) {
                            if editMode {
                                Text("Done")
                            }
                            else {
                                Text("Edit")
                            }
                        }
                    }
                }
                .confirmationDialog("",
                                    isPresented: $showConfirmationDialog,
                                    titleVisibility: .hidden,
                                    presenting: deleteListItem
                ){ item in
                    Button("Delete \(deleteListItem?.listName ?? "")",
                           role: .destructive) {
                        deleteList(item: item)
                        deleteListItem = nil
                    }
                    Button("Cancel", role: .cancel) {
                        deleteListItem = nil
                    }
                }
            } else {
                VStack {
                    Text("You have not created any lists yet!")
                    Button("Get started!") {
                        addNewList()
                    }
                }
                .navigationTitle(Text("Your Lists"))
            }
        }
    }
    
//    func addSamples() {
//        let list1 = ListItemModel("List 1", items: ["Item 1", "Item 2"], states: [false, false], end: .distantFuture)
//        let listModel2 = ListItemModel("List 2", items: ["Item 1", "Item 2"], states: [false, true])
//        let listModel3 = ListItemModel("List 3", items: ["Item 1", "Item 2", "Item 3"], states: [false, true, false])
//        modelContext.insert(list1)
//        modelContext.insert(listModel2)
//        modelContext.insert(listModel3)
//    }
    
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
