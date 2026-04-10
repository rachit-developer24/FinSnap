//
//  ContentView.swift
//  finSnap
//
//  Created by Rachit Sharma on 01/04/2026.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(ReceiptViewModel.self) private var viewModel
    
    var body: some View {
        Group {
            if viewModel.isUnlocked {
                MainTabView()
            } else {
                lockedView
            }
        }
        .task {
            await viewModel.authenticate()
        }
    }
}

private extension ContentView {
    var lockedView: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.14),
                    Color.white,
                    Color.green.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 110, height: 110)
                    
                    Image(systemName: "faceid")
                        .font(.system(size: 42, weight: .semibold))
                        .foregroundStyle(.blue)
                }
                
                VStack(spacing: 10) {
                    Text("Unlock Receipts")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Use Face ID to access your receipts and spending insights securely.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                Button {
                    Task {
                        await viewModel.authenticate()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "faceid")
                        Text("Try Face ID Again")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .blue.opacity(0.25), radius: 12, x: 0, y: 8)
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: 360)
            .padding(28)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Receipt.self, inMemory: true)
        .environment(
            ReceiptViewModel(
                receiptStorageService: ReceiptStorageService(),
                billSplitService: BillSplitService(),
                receiptScanningService: ReceiptScanningService(),
                authenticationService: AuthenticationService()
            )
        )
}
