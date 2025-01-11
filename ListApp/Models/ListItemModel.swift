//
//  ListItemModel.swift
//  ListApp
//
//  Created by Aditi Nath on 20/11/24.
//
import Foundation
import SwiftData

@Model
class ListItem {
    var itemName: String
    var itemState: Bool
    
    init(itemName: String, itemState: Bool) {
        self.itemName = itemName
        self.itemState = itemState
    }
}

@Model
class ListItemModel {
    var id = UUID()
    var listName: String
    var startDate: Date
    var endDate: Date?
    @Relationship(deleteRule: .cascade) var itemStatePair: [ListItem]

    init(_ name: String, dict: [String: Bool], start: Date = .now, end: Date? = nil) {
        listName = name
        itemStatePair = dict.enumerated().map { (index, key_value) in
            ListItem(itemName: key_value.key, itemState: key_value.value)
        }
        self.startDate = start
        self.endDate = end
    }

    init(_ name: String, items: [String], states: [Bool], start: Date = .now, end: Date? = nil) {
        listName = name
        itemStatePair = zip(items, states).map {
            ListItem(itemName: $0, itemState: $1)
        }
        self.startDate = start
        self.endDate = end
    }

    init(_ name: String, start: Date = .now, end: Date? = nil) {
        listName = name
        itemStatePair = [ListItem] ()
        self.startDate = start
        self.endDate = end
    }

    func updateEndDate(newDate: Date) {
        self.endDate = newDate
    }
}
