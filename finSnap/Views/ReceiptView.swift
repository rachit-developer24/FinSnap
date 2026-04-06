//
//  ReceiptView.swift
//  finSnap
//
//  Created by Rachit Sharma on 03/04/2026.
//
import SwiftUI
import SwiftData

struct ReceiptView: View {
    @Query(sort: \Receipt.date, order: .reverse) var receipts: [Receipt]
    @Environment(\.modelContext) var context
    @State var isPresented:Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.08),
                        Color.white,
                        Color.green.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if receipts.isEmpty {
                    emptyStateView
                } else {
                    receiptsListView
                }
            }
            .sheet(isPresented: $isPresented, content: {
                AddReceiptView()
            })
            .navigationTitle("Receipts")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "plus.circle.dashed")
                            .imageScale(.large)
                            .foregroundStyle(.blue)
                    }

                }
            }
        }
    }
}

private extension ReceiptView {
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 90, height: 90)
                    
                    Image(systemName: "receipt.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(.blue)
                }
                
                VStack(spacing: 8) {
                    Text("No Receipts Yet")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Scan your first receipt to get started and keep track of your spending.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                
                Button {
                    isPresented = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                        Text("Scan Receipt")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .blue.opacity(0.22), radius: 10, x: 0, y: 6)
                }
            }
            .padding(24)
            .frame(maxWidth: 370)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    var receiptsListView: some View {
        List {
            ForEach(receipts) { receipt in
                ReceiptCardView(receipt: receipt)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                    .swipeActions {
                        Button(role: .destructive) {
                            context.delete(receipt)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
}
#Preview {
    ReceiptView()
        .modelContainer(for: Receipt.self,inMemory: true)
}
