//
//   ReceiptStorageServiceProtocol.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation

protocol  ReceiptStorageServiceProtocol{
    func  save(receipt:Receipt)
    func  delete(receipt:Receipt)
    func  fetchReceipts() ->[Receipt]
}
