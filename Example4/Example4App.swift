//
//  Example4App.swift
//  Example4
//
//  Created by 夏能啟 on 2023/3/13.
//

import SwiftUI

@main
struct Example4App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
//          SpuDetail()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
