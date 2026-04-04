//
//  BillSplitService.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation

class BillSplitService:BillSplitServiceProtocol{
    func billSplit(amount: Double, people: Int)throws -> Double {
        guard amount > 0 else{throw BillSplitError.zeroAmount}
        guard people > 0 else{throw BillSplitError.zeroPerson}
        
        let convertedAmount = Double(people)
        
        let dividedAmount =  amount/convertedAmount
        
        return dividedAmount
        
    }
    
}
