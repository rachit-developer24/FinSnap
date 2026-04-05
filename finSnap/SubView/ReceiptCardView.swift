//
//  ReceiptSubView.swift
//  finSnap
//
//  Created by Rachit Sharma on 03/04/2026.
//

import SwiftUI
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

