//
//  ListAppApp.swift
//  ListApp
//
//  Created by Aditi Nath on 17/11/24.
//

import SwiftUI
import SwiftData

@main
struct ListAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ListItemModel.self)
    }
}
