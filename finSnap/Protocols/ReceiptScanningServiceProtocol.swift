//
//  ReceiptScanningServiceProtocol.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation
import UIKit

protocol ReceiptScanningServiceProtocol{
    func scanReceipt(from:UIImage)-> ScannedReceiptData
}
