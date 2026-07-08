//
//  PaymentLocalDataSourceProtocol.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import Foundation

// MARK: - Payment Local Data Source Protocol

protocol PaymentLocalDataSourceProtocol {
    
    func present(request: PaymentRequestDTO) async throws -> PaymentResult
}
