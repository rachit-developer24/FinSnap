//
//  ReceiptScanningService.swift
//  finSnap
//
//  Created by Rachit Sharma on 02/04/2026.
//

import Vision
import UIKit

class ReceiptScanningService: ReceiptScanningServiceProtocol {
    
    // Words that signal "the next/nearby number is the total."
    private let totalKeywords = ["TOTAL", "AMOUNT DUE", "BALANCE", "TO PAY"]
    // How close two pieces of text need to be on the Y-axis to count as
    // the same visual row. 0.02 means within 2% of the image height.
    // (Vision uses normalized coords: 0 = bottom, 1 = top.)
    private let sameRowThreshold: CGFloat = 0.02
    
    func scanReceipt(from image: UIImage) -> ScannedReceiptData {
        guard let cgImage = image.cgImage else {
            return ScannedReceiptData(date: Date(), category: .groceries, totalAmount: 0, name: "Unknown", image: nil)
        }
        
        // Run OCR. Each result has BOTH the text AND its bounding box on the image —
        // that's what lets us tell which words are on the same visual row of the receipt.
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
        let observations = request.results ?? []
        
        let storeName = findStoreName(in: observations)
        let total = findTotal(in: observations)
        
        return ScannedReceiptData(
            date: Date(),
            category: .groceries,
            totalAmount: total,
            name: storeName,
            image: image.jpegData(compressionQuality: 0.8)
        )
    }
    
    // MARK: - Store name
    
    // The first OCR line that looks like a real label, not a number/date/symbol:
    //   - at least 3 chars
    //   - doesn't start with a digit (skips "12/04/2026", "£10.00", etc.)
    //   - contains at least one letter (skips lines that are just symbols)
    private func findStoreName(in observations: [VNRecognizedTextObservation]) -> String {
        let lines = observations.compactMap { $0.topCandidates(1).first?.string }
        return lines.first(where: { line in
            line.count >= 3
            && line.first?.isNumber == false
            && line.contains(where: { $0.isLetter })
        }) ?? "Unknown"
    }
    
    // MARK: - Total
    
    private func findTotal(in observations: [VNRecognizedTextObservation]) -> Double {
        // Sort all observations bottom-first (smallest minY first in Vision's coord system).
        let bottomFirst = observations.sorted(by: { $0.boundingBox.minY < $1.boundingBox.minY })
        
        // Pass 1: walk keyword matches bottom-up. First one with a number on the same
        // row wins. This skips "Total" labels that have no number beside them (Defune case).
        for obs in bottomFirst {
            guard let text = obs.topCandidates(1).first?.string else { continue }
            guard totalKeywords.contains(where: { text.uppercased().contains($0) }) else { continue }
            
            if let amount = amountOnSameRow(as: obs, in: observations) {
                return amount
            }
        }
        
        // Pass 2 fallback: no keyword found anywhere on the receipt.
        // Take the largest currency-shaped (X.XX) number. Works because the total is
        // always >= every line item, tax, or charge below it.
        return maxCurrencyAmount(in: observations) ?? 0.0
    }

    private func amountOnSameRow(as keyword: VNRecognizedTextObservation, in observations: [VNRecognizedTextObservation]) -> Double? {
        let keywordRowY = keyword.boundingBox.midY
        let candidates: [(amount: Double, x: CGFloat)] = observations.compactMap { obs in
            guard abs(obs.boundingBox.midY - keywordRowY) < sameRowThreshold else { return nil }
            guard let text = obs.topCandidates(1).first?.string else { return nil }
            return parseAmount(from: text).map { ($0, obs.boundingBox.midX) }
        }
        return candidates.max(by: { $0.x < $1.x })?.amount
    }

    private func maxCurrencyAmount(in observations: [VNRecognizedTextObservation]) -> Double? {
        // A "currency-shaped" string has a decimal point with exactly 2 digits after.
        // That filters out integers like VAT numbers ("660 4548 36") or phone digits.
        func looksLikeCurrency(_ s: String) -> Bool {
            let parts = s.split(separator: ".")
            return parts.count == 2 && parts[1].count == 2 && parts[1].allSatisfy(\.isNumber)
        }
        
        var amounts: [Double] = []
        for obs in observations {
            guard let text = obs.topCandidates(1).first?.string else { continue }
            for part in text.components(separatedBy: .whitespaces) {
                let cleaned = part
                    .replacingOccurrences(of: "£", with: "")
                    .replacingOccurrences(of: "$", with: "")
                    .replacingOccurrences(of: ",", with: ".")
                if looksLikeCurrency(cleaned), let value = Double(cleaned) {
                    amounts.append(value)
                }
            }
        }
        return amounts.max()
    }

    // Strip currency symbols, try to parse Double. For "TOTAL £12.99" we want 12.99.
    private func parseAmount(from text: String) -> Double? {
        let parts = text.components(separatedBy: .whitespaces)
        let numbers = parts.compactMap { part -> Double? in
            let cleaned = part
                .replacingOccurrences(of: "£", with: "")
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ",", with: ".")
            return Double(cleaned)
        }
        return numbers.last
    }
}
