//
//  HomeRepositoryProtocol.swift
//  TrueFit
//
//  Domain — Repository interface for Home screen data.
//

import Foundation

protocol HomeRepositoryProtocol {
    func fetchNewArrivals(limit: Int) async throws -> [Product]
    func fetchCollections() async throws -> [ProductCollection]
}
