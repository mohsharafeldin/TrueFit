//
//  CollectionMapper.swift
//  TrueFit
//
//  Data — Maps CollectionDTO → ProductCollection (domain entity).
//

import Foundation

enum CollectionMapper {

    static func map(_ dto: CollectionDTO, productsCount: Int? = nil) -> ProductCollection {
        let imageURL: URL? = {
            guard let src = dto.image?.src else { return nil }
            return URL(string: src)
        }()

        return ProductCollection(
            id: dto.id,
            title: dto.title,
            imageURL: imageURL,
            productsCount: productsCount ?? dto.productsCount ?? 0
        )
    }

    static func map(_ dtos: [CollectionDTO]) -> [ProductCollection] {
        dtos.map { map($0) }
    }
}
