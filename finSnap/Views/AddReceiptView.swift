//
//  AddReceiptView.swift
//  finSnap
//
//  Created by Rachit Sharma on 04/04/2026.
//

import SwiftUI
import SwiftData
import PhotosUI
struct AddReceiptView: View {
    @State private var name = ""
    @State private var amount = ""
    @State private var category: Category = .groceries
    @State var photo:PhotosPickerItem?
    @State private var isPresented:Bool = false
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(ReceiptViewModel.self) var viewModel
    @State private var cameraImage: UIImage?
    @State var isCameraPresented:Bool = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name
        case amount
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.12),
                        Color.white,
                        Color.green.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        formCard
                        saveButton
                        LibraryButton
                        cameraButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
                if viewModel.isLoading{
                    ZStack{
                        Color.black.opacity(0.4)
                        ProgressView()
                    }
                    .ignoresSafeArea()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .photosPicker(isPresented:  $isPresented, selection: $photo)
            .sheet(isPresented: $isCameraPresented, content: {
                CameraPickerView(image: $cameraImage)
                    .ignoresSafeArea()
            })
            .onChange(of:photo) { oldValue, newValue in
                Task{
                    await viewModel.imageUploader(item: photo)
                }
            }
            .onChange(of: viewModel.scannedName) { oldValue, newValue in
                    self.name = newValue
            }
            .onChange(of: viewModel.scannedTotalAmount) { oldValue, newValue in
                    self.amount = String(newValue)
                }
            .onChange(of: cameraImage) { oldValue, newValue in
                guard let image = newValue else { return }
                Task {
                    await viewModel.imageUploaderFromCamera(image: image)
                        
                    
                }
            }

            
        }
    }
}

private extension AddReceiptView {
    var headerSection: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "receipt.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.blue)
            }
            
            Text("Add a Receipt")
                .font(.system(size: 30, weight: .bold))
            
            Text("Track your spending with a clean and simple entry.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
    }
    
    var formCard: some View {
        VStack(spacing: 20) {
            customTextField(
                title: "Receipt Name",
                placeholder: "Protein bars, Tesco order...",
                text: $name,
                icon: "text.alignleft"
            )
            .focused($focusedField, equals: .name)
            .textInputAutocapitalization(.words)
            
            customTextField(
                title: "Amount",
                placeholder: "12.99",
                text: $amount,
                icon: "sterlingsign.circle"
            )
            .keyboardType(.decimalPad)
            .focused($focusedField, equals: .amount)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Category")
                    .font(.headline)
                
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue.capitalized).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
    }
    
    var saveButton: some View {
        Button {
            addReceipt()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                Text("Save Receipt")
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
        .disabled(!isValid)
        .opacity(isValid ? 1 : 0.55)
    }
    var LibraryButton: some View {
        Button {
           isPresented = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "photo")
                Text("Library")
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
    }
    var cameraButton: some View {
        Button {
           isCameraPresented = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "camera")
                Text("Camera")
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
    }
    
    func customTextField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                
                TextField(placeholder, text: text)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
        }
    }
    
    var isValid: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return false }
        guard let value = Double(amount), value > 0 else { return false }
        return true
    }
    
    func addReceipt() {
        guard let value = Double(amount) else { return }
        viewModel.addReceipt(name: name, amount: value, category: category, context: context)
        dismiss()
    }
}

#Preview {
    AddReceiptView()
        .modelContainer(for: Receipt.self, inMemory: true)
        .environment(ReceiptViewModel(receiptStorageService: ReceiptStorageService(), billSplitService: BillSplitService(), receiptScanningService: ReceiptScanningService(), authenticationService: AuthenticationService()))
}

