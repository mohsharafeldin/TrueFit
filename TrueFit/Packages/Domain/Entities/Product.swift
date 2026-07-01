//
//  Product.swift
//  TrueFit
//
//  Domain Entity — Pure business model, no framework dependencies.
//

import Foundation

struct Product: Identifiable, Equatable {
    let id: Int64
    let title: String
    let vendor: String
    let price: String
    let compareAtPrice: String?
    let imageURL: URL?
    let productType: String
    let createdAt: Date?
}
