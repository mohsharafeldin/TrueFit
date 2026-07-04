//
//  FavoritesLocalDataSource.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 04/07/2026.
//

import Foundation
import CoreData

final class FavoritesLocalDataSource: FavoritesLocalDataSourceProtocol {
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func fetchAll() async throws -> [FavoriteItemEntity] {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistenceController.container.viewContext
            context.perform {
                let request: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteItemEntity.addedAt, ascending: false)]
                
                do {
                    let results = try context.fetch(request)
                    continuation.resume(returning: results)
                } catch {
                    continuation.resume(throwing: AppError.persistenceFailure)
                }
            }
        }
    }
    
    func insert(_ item: FavoriteItem) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistenceController.container.viewContext
            context.perform {
                // Map Domain -> Entity (inserts into context)
                _ = FavoriteItemMapper.toEntity(item, context: context)
                
                do {
                    try context.save()
                    continuation.resume()
                } catch {
                    context.rollback()
                    continuation.resume(throwing: AppError.persistenceFailure)
                }
            }
        }
    }
    
    func delete(productId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistenceController.container.viewContext
            context.perform {
                let request: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
                request.predicate = NSPredicate(format: "productId == %@", productId)
                request.fetchLimit = 1
                
                do {
                    if let entity = try context.fetch(request).first {
                        context.delete(entity)
                        try context.save()
                    }
                    continuation.resume()
                } catch {
                    context.rollback()
                    continuation.resume(throwing: AppError.persistenceFailure)
                }
            }
        }
    }
    
    func exists(productId: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistenceController.container.viewContext
            context.perform {
                let request: NSFetchRequest<FavoriteItemEntity> = FavoriteItemEntity.fetchRequest()
                request.predicate = NSPredicate(format: "productId == %@", productId)
                request.fetchLimit = 1
                
                do {
                    let count = try context.count(for: request)
                    continuation.resume(returning: count > 0)
                } catch {
                    continuation.resume(throwing: AppError.persistenceFailure)
                }
            }
        }
    }
}
