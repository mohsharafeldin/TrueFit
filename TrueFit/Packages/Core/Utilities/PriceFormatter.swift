//
//  PriceFormatter.swift
//  TrueFit
//
//  Created by Mona Zarea on 02/07/2026.
//

import Foundation

enum PriceFormatter {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    static func format(_ price: Decimal) -> String {
        return formatter.string(from: price as NSDecimalNumber) ?? ""
    }
}
