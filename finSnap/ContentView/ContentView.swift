//
//  ContentView.swift
//  finSnap
//
//  Created by Rachit Sharma on 01/04/2026.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    var body: some View {
        ReceiptView()
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Receipt.self, inMemory: true)
}
