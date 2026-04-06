//
//  InsightsView.swift
//  finSnap
//
//  Created by Rachit Sharma on 06/04/2026.
//

import SwiftUI
import SwiftData

struct InsightsView: View {
    @Query(sort: \Receipt.date, order: .reverse) var receipts: [Receipt]
    @Environment(ReceiptViewModel.self) var viewModel
    
    private let icons = [
        "cart.fill",
        "fork.knife",
        "fuelpump.fill",
        "house.fill",
        "bag.fill",
        "creditcard.fill",
        "gift.fill",
        "heart.text.square.fill"
    ]
    
    var body: some View {
        NavigationStack {
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
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        
                        if receipts.isEmpty {
                            emptyStateView
                        } else {
                            summaryCard
                            categoriesCard
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension InsightsView {
    
    var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.pie.fill")
                .font(.system(size: 34))
                .foregroundStyle(.blue)
            
            Text("Spending Insights")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Track where your money goes")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }
    
    var summaryCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Overview")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text(totalSpent.formatted(.currency(code: "GBP")))
                .font(.system(size: 34, weight: .bold))
            
            HStack(spacing: 14) {
                infoPill(
                    title: "Receipts",
                    value: "\(receipts.count)",
                    icon: "doc.text.fill"
                )
                
                infoPill(
                    title: "Top Category",
                    value: topCategory?.rawValue ?? "N/A",
                    icon: "star.fill"
                )
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.45), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
    }
    
    var categoriesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.title3)
                .fontWeight(.bold)
            
            ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                categoryRow(category: category, index: index)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
    }
    
    var emptyStateView: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray.fill")
                .font(.system(size: 42))
                .foregroundStyle(.secondary)
            
            Text("No Insights Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Add some receipts and your category spending will appear here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
    
    func categoryRow(category: Category, index: Int) -> some View {
        let amount = spendingByCategory[category] ?? 0
        let progress = totalSpent == 0 ? 0 : amount / totalSpent
        let color = rowColor(for: index)
        
        return VStack(spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: icons[index % icons.count])
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.rawValue)
                        .font(.headline)
                    
                    Text("\(Int(progress * 100))% of total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(amount.formatted(.currency(code: "GBP")))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.12))
                        .frame(height: 10)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 10)
                }
            }
            .frame(height: 10)
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    func infoPill(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color.white.opacity(0.75))
        .clipShape(Capsule())
    }
    
    func rowColor(for index: Int) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .teal, .indigo, .red]
        return colors[index % colors.count]
    }
    
    var categories: [Category] {
        Array(Category.allCases)
    }
    
    var spendingByCategory: [Category: Double] {
        viewModel.spendingByCategory(receipts: receipts)
    }
    
    var totalSpent: Double {
        spendingByCategory.values.reduce(0, +)
    }
    
    var topCategory: Category? {
        spendingByCategory.max(by: { $0.value < $1.value })?.key
    }
}

#Preview {
    InsightsView()
        .environment(
            ReceiptViewModel(
                receiptStorageService: ReceiptStorageService(),
                billSplitService: BillSplitService(),
                receiptScanningService: ReceiptScanningService(), authenticationService: AuthenticationService()
            )
        )
        .modelContainer(for: Receipt.self, inMemory: true)
}
