//
//  ReceiptViewModel.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation
import UIKit
import Observation
@Observable

class ReceiptViewModel{
    
    let receiptStorageService:ReceiptStorageServiceProtocol
    let billSplitService:BillSplitServiceProtocol
    let receiptScanningService:ReceiptScanningServiceProtocol
   
    
    init(receiptStorageService: ReceiptStorageServiceProtocol, billSplitService: BillSplitServiceProtocol, receiptScanningService: ReceiptScanningServiceProtocol) {
        self.receiptStorageService = receiptStorageService
        self.billSplitService = billSplitService
        self.receiptScanningService = receiptScanningService
    }
    
    
    func receiptScanning(){
        let scannedReceipt = receiptScanningService.scanReceipt(from: UIImage())
        
        let receipt = Receipt(date:scannedReceipt.date , category: scannedReceipt.category, totalAmount: scannedReceipt.totalAmount, name: scannedReceipt.name)
    
        receiptStorageService.save(receipt: receipt)
    }
}
