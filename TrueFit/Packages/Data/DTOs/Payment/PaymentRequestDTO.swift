//
//  PaymentRequestDTO.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//
import PassKit


public struct PaymentRequestDTO {

    // MARK: Merchant Identity

    public let merchantIdentifier: String

    public let supportedNetworks: [PKPaymentNetwork]

    public let merchantCapabilities: PKMerchantCapability

    // MARK: Locale

    public let countryCode: String

    public let currencyCode: String

    // MARK: Order Summary

    public let paymentSummaryItems: [PKPaymentSummaryItem]

    // MARK: Init

    public init(
        merchantIdentifier: String,
        supportedNetworks: [PKPaymentNetwork],
        merchantCapabilities: PKMerchantCapability = .capability3DS,
        countryCode: String,
        currencyCode: String,
        paymentSummaryItems: [PKPaymentSummaryItem]
    ) {
        self.merchantIdentifier = merchantIdentifier
        self.supportedNetworks = supportedNetworks
        self.merchantCapabilities = merchantCapabilities
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.paymentSummaryItems = paymentSummaryItems
    }
}
