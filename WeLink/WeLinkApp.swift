//
//  WeLinkApp.swift
//  WeLink
//
//  Created by 조영민 on 8/4/25.
//

import SwiftUI
import SwiftData

@main
struct WeLinkApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CardModel.self,
            MyUUID.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
        ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
