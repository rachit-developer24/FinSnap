//
//  ReceiptViewModel.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation
import UIKit
import Observation
import PhotosUI
import _PhotosUI_SwiftUI
import SwiftData
@Observable

class ReceiptViewModel{
    
    var billSplitingError:BillSplitError?
    var globalError:String?
    var authenticationError:String?
    let receiptStorageService:ReceiptStorageServiceProtocol
    let billSplitService:BillSplitServiceProtocol
    let receiptScanningService:ReceiptScanningServiceProtocol
    let authenticationService:AuthenticationServiceProtocol
    var isUnlocked:Bool = false
    var splitAmountPerPerson:Double = 0
    var uiImage:UIImage?
    var scannedName:String = ""
    var scannedTotalAmount = Double()
    var isLoading = false
    var receiptScanningError:String?
    

    
    init(receiptStorageService: ReceiptStorageServiceProtocol, billSplitService: BillSplitServiceProtocol, receiptScanningService: ReceiptScanningServiceProtocol, authenticationService:AuthenticationServiceProtocol) {
        self.receiptStorageService = receiptStorageService
        self.billSplitService = billSplitService
        self.receiptScanningService = receiptScanningService
        self.authenticationService = authenticationService
    }
    
    
    
    
    func receiptScanning(){
        let scannedReceipt = receiptScanningService.scanReceipt(from: UIImage())
        
        let receipt = Receipt(date:scannedReceipt.date , category: scannedReceipt.category, totalAmount: scannedReceipt.totalAmount, name: scannedReceipt.name)
    
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
    func authenticate()async{
        do{
            self.isUnlocked = try await authenticationService.authenticate()
        }catch{
            self.authenticationError = error.localizedDescription
        }
    }
    
    func addReceipt(name:String,amount:Double,category:Category,context:ModelContext){
        let receipt = Receipt(date:Date() , category: category, totalAmount: amount, name:name)
        receiptStorageService.save(receipt: receipt, context: context)
    }
    
    
    func imageUploader(item:PhotosPickerItem?) async throws{
        do{
            guard let item = item else{return}
            isLoading = true
            defer {
                isLoading = false
            }
            guard let data =  try? await item.loadTransferable(type: Data.self) else{return}
            guard let image = UIImage(data: data)else{throw ScanningError.imageLoadFailed}
            self.uiImage = image
            let scannedData = receiptScanningService.scanReceipt(from: image)
            self.scannedName = scannedData.name
            self.scannedTotalAmount = scannedData.totalAmount
        }catch let error as ScanningError{
            self.receiptScanningError = error.localizedDescription
        }catch{
            self.globalError = error.localizedDescription
        }
    }
    func imageUploaderFromCamera(image:UIImage)async{
        isLoading = true
        defer {
            isLoading = false
        }
        let scannedData = receiptScanningService.scanReceipt(from: image)
        self.scannedName = scannedData.name
        self.scannedTotalAmount = scannedData.totalAmount
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
