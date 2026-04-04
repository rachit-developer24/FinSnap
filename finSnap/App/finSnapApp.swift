//
//  finSnapApp.swift
//  finSnap
//
//  Created by Rachit Sharma on 01/04/2026.
//

import SwiftUI
import SwiftData

@main
struct finSnapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Receipt.self)
        }
    }
}
