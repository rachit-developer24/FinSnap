//
//  ReceiptScanningService.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Vision
import UIKit

class ReceiptScanningService: ReceiptScanningServiceProtocol {
    func scanReceipt(from image: UIImage) -> ScannedReceiptData {
        guard let cgImage = image.cgImage else {
            return ScannedReceiptData(date: Date(), category: .groceries, totalAmount: 0, name: "Unknown", image: nil)
        }
        
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
        
        let lines = request.results?
            .compactMap { $0.topCandidates(1).first?.string } ?? []
        
        var total = 0.0
        let storeName = lines.first(where: {
            !$0.isEmpty && Double($0) == nil
      
        }) ?? "Unknown"
     print(lines)

        let bottomLines = Array(lines.dropFirst(lines.count / 2))
        let amounts = bottomLines.compactMap { line -> Double? in
            let cleaned = line.replacingOccurrences(of: "£", with: "")
                             .replacingOccurrences(of: "$", with: "")
                             .replacingOccurrences(of: ",", with: ".")
                             .trimmingCharacters(in: .whitespaces)
            return Double(cleaned)
        }
        total = amounts.max() ?? 0.0

        print("Store: \(storeName), Total: \(total)")
        return ScannedReceiptData(date: Date(), category: .groceries, totalAmount: total, name: storeName, image: image.jpegData(compressionQuality: 0.8))
    }

    
    
        }
        
        
