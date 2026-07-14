//
//  OrderStatus+UI.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 06/07/2026.
//

import SwiftUI

extension OrderStatus {
    var color: Color {
        switch self {
        case .all: return .brandPrimary
        case .processing: return .semanticWarning ?? .orange
        case .shipped: return .brandPrimary
        case .delivered: return .semanticSuccess ?? .green
        case .cancelled: return .semanticDanger ?? .red
        }
    }
}
