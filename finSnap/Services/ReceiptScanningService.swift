//
//  ReceiptScanningService.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation
import UIKit

class ReceiptScanningService:ReceiptScanningServiceProtocol{
    func scanReceipt(from: UIImage) -> ScannedReceiptData {
        return ScannedReceiptData(date: Date(), category: .clothes, totalAmount: 66.66, name: "Primark", image: Data())
    }
    
}
