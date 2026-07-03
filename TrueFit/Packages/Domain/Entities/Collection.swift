//
//  Collection.swift
//  TrueFit
//
//  Domain Entity — Represents a product category / collection.
//

import Foundation

struct ProductCollection: Identifiable, Equatable {
    let id: Int64
    let title: String
    let imageURL: URL?
    let productsCount: Int
}
