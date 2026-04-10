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
    
    @State private var photo: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @State private var isCameraPresented = false
    @State private var cameraImage: UIImage?
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(ReceiptViewModel.self) private var viewModel
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name
        case amount
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        formCard
                        imagePreviewCard
                        actionSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
                
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("New Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .photosPicker(isPresented: $isPhotoPickerPresented, selection: $photo)
            .sheet(isPresented: $isCameraPresented) {
                CameraPickerView(image: $cameraImage)
                    .ignoresSafeArea()
            }
            .onChange(of: photo) { _, newValue in
                guard newValue != nil else { return }
                Task {
                    await viewModel.imageUploader(item: newValue)
                }
            }
            .onChange(of: viewModel.scannedName) { _, newValue in
                name = newValue
            }
            .onChange(of: viewModel.scannedTotalAmount) { _, newValue in
                amount = newValue > 0 ? String(format: "%.2f", newValue) : ""
            }
            .onChange(of: cameraImage) { _, newValue in
                guard let image = newValue else { return }
                Task {
                    await viewModel.imageUploaderFromCamera(image: image)
                }
            }
        }
    }
}

private extension AddReceiptView {
    
    var backgroundView: some View {
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
    }
    
    var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
            
            VStack(spacing: 14) {
                ProgressView()
                    .scaleEffect(1.1)
                
                Text("Scanning receipt...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }
    
    var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 84, height: 84)
                
                Image(systemName: "receipt.fill")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.blue)
            }
            
            Text("Add a Receipt")
                .font(.system(size: 30, weight: .bold))
            
            Text("Add it manually, pick from your library, or scan it with the camera.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
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
            .submitLabel(.next)
            
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
    
    @ViewBuilder
    var imagePreviewCard: some View {
        if let image = cameraImage ?? viewModel.uiImage {
            VStack(alignment: .leading, spacing: 12) {
                Text("Selected Image")
                    .font(.headline)
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
        }
    }
    
    var actionSection: some View {
        VStack(spacing: 14) {
            primaryButton(
                title: "Save Receipt",
                systemImage: "checkmark.circle.fill",
                isDisabled: !isValid
            ) {
                addReceipt()
            }
            
            HStack(spacing: 12) {
                secondaryActionButton(
                    title: "Library",
                    systemImage: "photo.on.rectangle"
                ) {
                    isPhotoPickerPresented = true
                }
                
                secondaryActionButton(
                    title: "Camera",
                    systemImage: "camera.fill"
                ) {
                    isCameraPresented = true
                }
            }
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
                    .frame(width: 18)
                
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
    
    func primaryButton(
        title: String,
        systemImage: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                Text(title)
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
            .opacity(isDisabled ? 0.55 : 1)
        }
        .disabled(isDisabled)
    }
    
    func secondaryActionButton(
        title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.blue)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.blue.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
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
        viewModel.addReceipt(
            name: name,
            amount: value,
            category: category,
            context: context
        )
        dismiss()
    }
}

#Preview {
    AddReceiptView()
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
  



