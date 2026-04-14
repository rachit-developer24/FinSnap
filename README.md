# finSnap

A smart iOS receipt scanner that uses OCR to extract totals, categorise spending, split bills, and track expenses — all secured with Face ID.

## Screenshots

<img width="645" height="1398" alt="IMG_9953 2" src="https://github.com/user-attachments/assets/d9d5bb78-93a0-4f75-b003-86e26c6fd4d7" />
<img width="645" height="1398" alt="IMG_9954 2" src="https://github.com/user-attachments/assets/bc17b407-b4a8-446c-9cea-1194aee107b8" />
<img width="645" height="1398" alt="IMG_9955 2" src="https://github.com/user-attachments/assets/bf6a0c51-5732-4490-b6df-894d8bd0f108" />
<img width="645" height="1398" alt="IMG_9956 2" src="https://github.com/user-attachments/assets/d2a4f2a0-5859-46f6-b9bc-1c2ab1e1e4bd" />
<img width="645" height="1398" alt="IMG_9957 2" src="https://github.com/user-attachments/assets/6fc7e93e-0df9-4035-9023-f112c7afd749" />
<img width="645" height="1398" alt="IMG_9958 2" src="https://github.com/user-attachments/assets/7ba17cc8-6efa-41e3-ba9b-71e6b85f7fec" />
<img width="645" height="1398" alt="IMG_9959 2" src="https://github.com/user-attachments/assets/fc2117f0-84b8-43fa-be22-2344fd280acc" />


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
