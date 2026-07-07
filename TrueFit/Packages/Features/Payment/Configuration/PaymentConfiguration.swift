//
//  PaymentConfiguration.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import PassKit

// MARK: - Payment Configuration

/// Merchant-specific constants used when constructing a PKPaymentRequest.
///
/// All values are configurable from a single location. In a production
/// integration, these would typically be sourced from a remote config
/// or an xcconfig file, never hardcoded.
enum PaymentConfiguration {

    // MARK: Merchant Identity

    /// Apple Pay merchant identifier registered in the Apple Developer portal.
    /// Replace with the real identifier before App Store submission.
    static let merchantIdentifier = "merchant.com.truefit.app"

    // MARK: Accepted Networks

    /// Payment networks the merchant accepts.
    static let supportedNetworks: [PKPaymentNetwork] = [
        .visa,
        .masterCard,
        .amex,
        .discover
    ]

    /// Merchant capabilities — 3DS is required; optionally add `.capabilityEMV`.
    static let merchantCapabilities: PKMerchantCapability = .capability3DS

    // MARK: Locale

    /// ISO 3166-1 alpha-2 country code for the merchant's registered location.
    static let countryCode = "US"

    /// ISO 4217 currency code for the transaction.
    static let currencyCode = "USD"

    // MARK: Display

    /// Merchant name shown as the final line item in the Apple Pay sheet.
    static let merchantDisplayName = "TrueFit"
}
