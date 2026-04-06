//
//  ContentView.swift
//  finSnap
//
//  Created by Rachit Sharma on 01/04/2026.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    @Environment(ReceiptViewModel.self) var viewModel
    var body: some View {
        VStack{
            if viewModel.isUnlocked{
                MainTabView()
            }else{
                VStack(spacing:13){
                    Text("Locked")
                        .font(.title2)
                        .fontWeight(.bold)
                    Image(systemName:  "lock.shield")
                    
                    Button {
                        Task{
                            await viewModel.authenticate()
                        }
                    } label: {
                        Text("Try Again")
                    }
                }
                
            }
        }.task{
            await viewModel.authenticate()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Receipt.self, inMemory: true)
        .environment(ReceiptViewModel(receiptStorageService: ReceiptStorageService(), billSplitService: BillSplitService(), receiptScanningService: ReceiptScanningService(), authenticationService: AuthenticationService()))
}
