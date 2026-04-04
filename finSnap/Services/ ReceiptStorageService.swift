//
//   ReceiptStorageService.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation

class ReceiptStorageService:ReceiptStorageServiceProtocol{
    func delete(receipt: Receipt) {
        
    }
    
    func fetchReceipts() -> [Receipt] {
     return   [Receipt(date: Date(), category: .clothes, totalAmount: 66.66, name: "Primark")]
    }
    
    func save(receipt: Receipt) {
        
    }
}
