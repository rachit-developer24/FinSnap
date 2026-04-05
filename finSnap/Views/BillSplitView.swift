//
//  BillSplitView.swift
//  finSnap
//
//  Created by Rachit Sharma on 05/04/2026.
//

import SwiftUI

struct BillSplitView: View {
    @State private var amount = ""
    @State private var person = ""
    @State private var isPresentedError:Bool = false
    @Environment(ReceiptViewModel.self) var viewModel
    
    private var parsedAmount: Double? {
        Double(amount)
    }
    
    private var parsedPersons: Int? {
        Int(person)
    }
    
    private var isValid: Bool {
        guard let amount = parsedAmount, amount > 0 else { return false }
        guard let persons = parsedPersons, persons > 0 else { return false }
        return true
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.18),
                    Color.white,
                    Color.green.opacity(0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            ScrollView{
                VStack(spacing: 28) {
                    headerSection
                    
                    resultCard
                    
                    inputSection
                    
                    calculateButton
                    
                    Spacer()
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .padding(.horizontal, 24)
            .padding(.top, 30)
            .onChange(of: viewModel.globalError) { oldValue, newValue in
                if oldValue != newValue{
                    isPresentedError = true
                }
            }
            .alert("Bill Split Error", isPresented: $isPresentedError) {
                Button("OK") { }
            } message: {
                if let error = viewModel.globalError {
                    Text(error)
                }
            }


        }
    }
}

// MARK: - Sections
private extension BillSplitView {
    
    var headerSection: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.3.sequence.fill")
                .font(.system(size: 42))
                .foregroundStyle(.blue)
            
            Text("Bill Splitter")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Split your bill quickly and clearly")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var resultCard: some View {
        VStack(spacing: 14) {
            Text("Amount Per Person")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text(viewModel.splitAmountPerPerson.formatted(.currency(code: "GBP")))
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(.primary)
            
            HStack(spacing: 16) {
                summaryPill(
                    title: "Bill",
                    value: parsedAmount?.formatted(.currency(code: "GBP")) ?? "£0.00",
                    icon: "sterlingsign.circle.fill"
                )
                
                summaryPill(
                    title: "People",
                    value: parsedPersons.map { "\($0)" } ?? "0",
                    icon: "person.2.fill"
                )
            }
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color.white.opacity(0.45), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
    }
    
    var inputSection: some View {
        VStack(spacing: 18) {
            customInputField(
                title: "Total Amount",
                placeholder: "Enter amount",
                text: $amount,
                icon: "sterlingsign.circle",
                keyboard: .decimalPad
            )
            
            customInputField(
                title: "Number of People",
                placeholder: "Enter persons",
                text: $person,
                icon: "person.2",
                keyboard: .numberPad
            )
        }
    }
    
    var calculateButton: some View {
        Button {
            guard
                let amount = parsedAmount,
                let persons = parsedPersons
            else { return }
            
            viewModel.billSplit(amount: amount, persons: persons)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "equal.circle.fill")
                Text("Calculate Split")
                    .fontWeight(.bold)
            }
            .foregroundStyle(.white)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(
                LinearGradient(
                    colors: isValid
                    ? [Color.blue, Color.indigo]
                    : [Color.gray.opacity(0.5), Color.gray.opacity(0.4)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: isValid ? .blue.opacity(0.25) : .clear, radius: 12, x: 0, y: 8)
        }
        .disabled(!isValid)
    }
}

// MARK: - Reusable Views
private extension BillSplitView {
    
    func customInputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        icon: String,
        keyboard: UIKeyboardType
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                
                TextField(placeholder, text: text)
                    .keyboardType(keyboard)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
    }
    
    func summaryPill(title: String, value: String, icon: String) -> some View {
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
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(Color.white.opacity(0.8))
        .clipShape(Capsule())
    }
}

#Preview {
    BillSplitView()
        .environment(
            ReceiptViewModel(
                receiptStorageService: ReceiptStorageService(),
                billSplitService: BillSplitService(),
                receiptScanningService: ReceiptScanningService()
            )
        )
}
