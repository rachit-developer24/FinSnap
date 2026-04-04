//
//  ScannedReceiptData.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation

struct ScannedReceiptData{
    let date:Date
    let category:Category
    let totalAmount:Double
    let name:String
    let image:Data?
}
