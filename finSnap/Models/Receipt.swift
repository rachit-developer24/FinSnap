//
//  Receipt.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation
import SwiftData

@Model
class Receipt{
    var id:UUID
    var date:Date
    var category:Category
    var totalAmount:Double
    var name:String
    var image:Data?
    
    
    init(id: UUID = UUID(), date: Date, category: Category, totalAmount: Double, name: String, image: Data? = nil) {
        self.id = id
        self.date = date
        self.category = category
        self.totalAmount = totalAmount
        self.name = name
        self.image = image
    }
}
