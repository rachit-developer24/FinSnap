//
//  ScanningError.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Foundation
enum ScanningError:LocalizedError{
    case imageLoadFailed
    case unreadableReceipt
    
    var errorDescription: String?{
        switch self {
        case .imageLoadFailed:
            return"Sorry,that photo couldn't be opened. Try picking a different image."
        case .unreadableReceipt:
            return "We couldn't read this receipt. Try a clearer, well-lit photo."

        }
    }
}
