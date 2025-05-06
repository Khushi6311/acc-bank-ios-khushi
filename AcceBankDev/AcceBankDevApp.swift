//
//  AcceBankDevApp.swift
//  AcceBankDev
//
//  Created by MCT on 17/02/25.
//

import SwiftUI
import SwiftData

@main
struct AcceBankDevApp: App {
    @StateObject var languageManager = LanguageManager()
    @StateObject var appState = AppState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
                .environmentObject(languageManager)
                .environmentObject(appState)

        }
        .modelContainer(sharedModelContainer)
    }
}
