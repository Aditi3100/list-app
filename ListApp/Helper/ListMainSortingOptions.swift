//
//  ListMainSortingOptions.swift
//  ListApp
//
//  Created by Aditi Nath on 21/01/25.
//

enum ListMainSortingOptions {
    case alphabet
    case dueFirst
    case createFirst
    case createLast
}

extension ListMainView {
    var listArraySortByOption: [ListItemModel] {
        switch sortOption {
        case .alphabet:
            sortByAlphabet()
        case .dueFirst:
            sortByDue()
        case .createFirst:
            sortByCreateFirst()
        case .createLast:
            sortByCreateLast()
        }
    }
    func sortByAlphabet() -> [ListItemModel] {
        let sortedArray = listArray.sorted(by: {$0.listName < $1.listName})
        return sortedArray
    }
    func sortByDue() -> [ListItemModel] {
        let sortedArray = listArray.sorted(by: {
            if let firstDate = $0.endDate {
                if let secondDate = $1.endDate {
                    return firstDate < secondDate
                } else {
                    return true
                }
            } else {
                if let secondDate = $1.endDate {
                    return false
                } else {
                    return $0.startDate < $1.startDate
                }
            }
        })
        return sortedArray
    }
    func sortByCreateFirst() -> [ListItemModel] {
        let sortedArray = listArray.sorted(by: {$0.startDate < $1.startDate})
        return sortedArray
    }
    func sortByCreateLast() -> [ListItemModel] {
        let sortedArray = listArray.sorted(by: {$0.startDate > $1.startDate})
        return sortedArray
    }
}
