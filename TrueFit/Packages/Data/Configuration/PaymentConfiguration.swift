//
//  PaymentConfiguration.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import PassKit

// MARK: - Payment Configuration

enum PaymentConfiguration {

    // MARK: Merchant Identity

    static let merchantIdentifier = "merchant.com.truefit.app"

    // MARK: Accepted Networks

   
    static let supportedNetworks: [PKPaymentNetwork] = [
        .visa,
        .masterCard,
        .amex,
        .discover
    ]

    /// Merchant capabilities — 3DS is required; optionally add `.capabilityEMV`.
    static let merchantCapabilities: PKMerchantCapability = .capability3DS

    // MARK: Locale

    static let countryCode = "US"

   
    static let currencyCode = "USD"

    // MARK: Display

    static let merchantDisplayName = "TrueFit"
}
