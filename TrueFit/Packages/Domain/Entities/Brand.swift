//
//  Brand.swift
//  TrueFit
//
//  Domain Entity — Represents a product brand / vendor.
//

import Foundation

struct Brand: Identifiable, Equatable, Hashable {
    let id: String          // vendor name serves as ID (unique per store)
    let name: String
    let productCount: Int
    
    /// Optional image URL derived from the first product image of that vendor.
    let imageURL: URL?
}
