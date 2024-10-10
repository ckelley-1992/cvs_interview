//
//  interviewApp.swift
//  interview
//
//  Created by Connor Kelley on 10/9/24.
//

import SwiftUI
import SwiftData

@main
struct interviewApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ImageEntry.self,
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
