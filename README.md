# finSnap

A smart iOS receipt scanner that uses OCR to extract totals, categorise spending, split bills, and track expenses — all secured with Face ID.

## Screenshots

<!-- Add your screenshots here -->
<!-- ![Home](screenshots/home.png) -->
<!-- ![Scan](screenshots/scan.png) -->
<!-- ![Insights](screenshots/insights.png) -->
<!-- ![Bill Split](screenshots/billsplit.png) -->

## Features

- **OCR Receipt Scanning** — Point your camera at any receipt and instantly extract the total using Apple Vision framework
- **Smart Categorisation** — Assign receipts to categories like Groceries, Transport, Food & Drink, Shopping, and more
- **Spending Insights** — Visual breakdown of where your money goes across all categories
- **Bill Splitting** — Split any receipt equally among friends with a clean, simple interface
- **Face ID Authentication** — Secure your financial data with biometric authentication on launch
- **Persistent Storage** — All receipts saved locally using SwiftData with full CRUD operations
- **Camera Integration** — Native camera picker for scanning receipts directly from the app

## Tech Stack

| Technology | Usage |
|------------|-------|
| **SwiftUI** | Declarative UI framework |
| **SwiftData** | Local persistence for receipts |
| **Vision (VNRecognizeTextRequest)** | OCR text recognition from camera images |
| **LocalAuthentication** | Face ID / Touch ID biometric security |
| **MVVM Architecture** | Clean separation of concerns |
| **Protocol-Oriented Design** | All services use protocol-based dependency injection for testability |

## Architecture

```
finSnap/
├── App/                  # App entry point
├── Models/               # Receipt, ScannedReceiptData
├── Views/                # AddReceiptView, ReceiptView, InsightsView, BillSplitView, CameraPickerView
├── ViewModels/           # ReceiptViewModel
├── SubView/              # Reusable components (ReceiptCardView)
├── TabView/              # MainTabView navigation
├── Services/             # Business logic layer
│   ├── ReceiptScanningService    # OCR processing
│   ├── ReceiptStorageService     # SwiftData CRUD
│   ├── AuthenticationService     # Face ID
│   └── BillSplitService         # Bill splitting logic
├── Protocols/            # Service protocols for DI
├── Enums/                # Category, FaceIdEnum
└── Errors/               # Custom error types (ScanningError, StorageError, BillSplitError)
```

## Key Concepts Demonstrated

- **Protocol-Based Dependency Injection** — Every service conforms to a protocol, making the codebase testable and modular
- **async/await** — Modern Swift concurrency for camera and OCR operations
- **@Observable ViewModel** — Reactive state management with SwiftUI
- **Custom Error Handling** — Dedicated error enums for each service layer
- **Biometric Authentication** — Secure app access using LocalAuthentication framework

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Physical device recommended (camera + Face ID)

## Author

**Rachit Sharma** — Self-taught iOS Developer

- GitHub: [@rachit-developer24](https://github.com/rachit-developer24)
