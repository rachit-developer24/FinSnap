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
    
    var billSplitingError:BillSplitError?
    var globalError:String?
    let receiptStorageService:ReceiptStorageServiceProtocol
    let billSplitService:BillSplitServiceProtocol
    let receiptScanningService:ReceiptScanningServiceProtocol
   
    var splitAmountPerPerson:Double = 0
    
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
    
    func billSplit(amount:Double,persons:Int){
        do{
            let amountPerPerson = try billSplitService.billSplit(amount: amount, people: persons)
            self.splitAmountPerPerson = amountPerPerson
        }catch let error as BillSplitError {
            self.billSplitingError = error
        }catch{
            globalError = error.localizedDescription
        }
    }
    func spendingByCategory(receipts:[Receipt])->[Category:Double]{
        var spendingCategory = [Category:Double]()
        for category in Category.allCases{
            let filtered = receipts.filter{$0.category == category}
            let totalAmount = filtered.reduce(0){$0 + $1.totalAmount}
            spendingCategory[category] = totalAmount
        }
        return spendingCategory
    }

   
}
