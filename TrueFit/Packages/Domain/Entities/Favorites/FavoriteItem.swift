//
//  FavoriteItem.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 03/07/2026.
//

import Foundation

struct FavoriteItem: Identifiable, Equatable {
    let id: String
    let title: String
    let price: Decimal
    let vendor: String?
    let imageURL: URL?
    let addedAt: Date
}
