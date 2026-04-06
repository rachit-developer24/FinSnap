//
//  MainTabView.swift
//  finSnap
//
//  Created by Rachit Sharma on 05/04/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView{
            ReceiptView()
            .tabItem{
                Image(systemName: "receipt")
                Text("Receipts")
            }
            BillSplitView()
            .tabItem{
                Image(systemName: "square.split.2x1.fill")
                Text("BillSplit")
            }
           InsightsView()
            .tabItem{
                Image(systemName: "chart.bar.xaxis")
                Text("Insights")
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(ReceiptViewModel(receiptStorageService: ReceiptStorageService(), billSplitService: BillSplitService(), receiptScanningService: ReceiptScanningService(), authenticationService: AuthenticationService()))
        .modelContainer(for: Receipt.self,inMemory: true)
}
