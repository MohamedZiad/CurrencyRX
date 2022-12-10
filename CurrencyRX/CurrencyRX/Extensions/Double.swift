//
//  Double.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 10/12/2022.
//
import Foundation
extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func removeZerosFromEnd() -> String {
           let formatter = NumberFormatter()
           let number = NSNumber(value: self)
           formatter.minimumFractionDigits = 0
           formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
           return String(formatter.string(from: number) ?? "")
       }
}

