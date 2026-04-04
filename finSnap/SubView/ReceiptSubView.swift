//
//  ReceiptSubView.swift
//  finSnap
//
//  Created by Rachit Sharma on 03/04/2026.
//

import SwiftUI

struct ReceiptSubView: View {
    let receipt:Receipt
    var body: some View {
        VStack(spacing:24){
            HStack{
            Text(receipt.name)
                .fontWeight(.bold)
                .font(.title)
           Spacer()
                Text(receipt.date.formatted(date: .abbreviated, time: .omitted))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
            }
            HStack{
                Text(receipt.category.rawValue)
                    .fontWeight(.semibold)
                Spacer()
                Text(receipt.totalAmount.formatted(.currency(code: "GBP")))
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black, radius: 0.5,x:0.2,y: 0.2)
      
        .padding(.horizontal)
    }
}

#Preview {
    ReceiptSubView(receipt: Receipt(date: Date(), category: .clothes, totalAmount: 66.66, name: "Primark"))
}
