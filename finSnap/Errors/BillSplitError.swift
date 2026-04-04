//
//  BillSplitError.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation

enum BillSplitError:LocalizedError{
    case zeroAmount
    case zeroPerson
    
    var errorDescription: String?{
        switch self {
        case .zeroAmount:
            return "Please enter an amount greater than 0"
        case .zeroPerson:
            return "Please enter an person greater than 0"
        }
    }
}
