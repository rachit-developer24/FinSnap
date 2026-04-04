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
                    // open scan / add receipt screen
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
        ScrollView {
            VStack(spacing: 16) {
                ForEach(receipts) { receipt in
                    ReceiptCardView(receipt: receipt)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .scrollIndicators(.hidden)
    }
}

struct ReceiptCardView: View {
    let receipt: Receipt
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 52, height: 52)
                
                Image(systemName: categoryIcon)
                    .foregroundStyle(categoryColor)
                    .font(.system(size: 22, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(receipt.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(receipt.category.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text("£\(receipt.totalAmount, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(receipt.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
    
    var categoryIcon: String {
        switch receipt.category {
        case .groceries:
            return "cart.fill"
        case .clothes:
            return "bag.fill"
        case .tickets:
            return "ticket.fill"
        case .restaurantFood:
            return "fork.knife"
        case .gas:
            return "fuelpump.fill"
        }
    }
    
    var categoryColor: Color {
        switch receipt.category {
        case .groceries:
            return .green
        case .clothes:
            return .pink
        case .tickets:
            return .orange
        case .restaurantFood:
            return .purple
        case .gas:
            return .black
        }
    }
}
#Preview {
    ReceiptView()
}
