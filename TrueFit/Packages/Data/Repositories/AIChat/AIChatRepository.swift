//
//  AIChatRepository.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 07/07/2026.
//

import Foundation

final class AIChatRepository: AIChatRepositoryProtocol {
    private let remoteDataSource: AIChatRemoteDataSourceProtocol
    
    init(remoteDataSource: AIChatRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func sendMessage(_ text: String, history: [ChatBootMessage], systemContext: String) async throws -> String {
        do {
            let response = try await remoteDataSource.sendMessage(text, history: history, systemPrompt: systemContext)
            return response
        } catch let error as GeminiError {
            throw GeminiErrorMapper.map(error)
        } catch {
            throw AppError.unknown(error.localizedDescription)
        }
    }
}
