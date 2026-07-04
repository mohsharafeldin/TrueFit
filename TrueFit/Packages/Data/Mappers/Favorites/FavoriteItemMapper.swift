//
//  FavoriteItemMapper.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 03/07/2026.
//

import Foundation
import CoreData

enum FavoriteItemMapper {
    static func toDomain(_ entity: FavoriteItemEntity) -> FavoriteItem {
        let imageURL: URL? = {
            if let urlString = entity.imageURL {
                return URL(string: urlString)
            }
            return nil
        }()
        
        return FavoriteItem(
            id: entity.productId ?? "",
            title: entity.title ?? "",
            price: entity.price as? Decimal ?? 0,
            vendor: entity.vendor,
            imageURL: imageURL,
            addedAt: entity.addedAt ?? Date()
        )
    }

    static func toEntity(_ item: FavoriteItem, context: NSManagedObjectContext) -> FavoriteItemEntity {
        let entity = FavoriteItemEntity(context: context)
        entity.productId = item.id
        entity.title = item.title
        entity.price = NSDecimalNumber(decimal: item.price)
        entity.vendor = item.vendor
        entity.imageURL = item.imageURL?.absoluteString
        entity.addedAt = item.addedAt
        return entity
    }
}

