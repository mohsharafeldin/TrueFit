//
//  PriceFormatter.swift
//  TrueFit
//
//  Created by Mona Zarea on 02/07/2026.
//

import Foundation

enum PriceFormatter {
    static func format(_ price: Decimal) -> String {
        let manager = CurrencyManager.shared
        let converted = manager.convert(price)
        let selectedCurrency = manager.selectedCurrency
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if let formattedStr = formatter.string(from: converted as NSDecimalNumber) {
            return "\(formattedStr) \(selectedCurrency)"
        }
        return "\(converted) \(selectedCurrency)"
    }
}
