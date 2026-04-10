//
//   ReceiptStorageServiceProtocol.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation
import SwiftData
protocol  ReceiptStorageServiceProtocol{
    func  save(receipt:Receipt,context:ModelContext)
    func  delete(receipt:Receipt)
    func  fetchReceipts() ->[Receipt]
}
