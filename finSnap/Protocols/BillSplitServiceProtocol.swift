//
//  BillSplitServiceProtocol.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation
protocol BillSplitServiceProtocol{
    func billSplit(amount:Double,people:Int) throws -> Double
}
