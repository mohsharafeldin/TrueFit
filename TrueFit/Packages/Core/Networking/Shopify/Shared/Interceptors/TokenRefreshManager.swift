//
//  TokenRefreshManager.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

actor TokenRefreshManager {
    private var isRefreshing = false
    private let authManager: AuthManagerProtocol
    private let refreshAction: (String) async throws -> String
    
    init(authManager: AuthManagerProtocol, refreshAction: @escaping (String) async throws -> String) {
        self.authManager = authManager
        self.refreshAction = refreshAction
    }
    
    func refreshToken(currentToken: String) async throws -> String {
        let freshToken = await authManager.getAccessToken()
        if freshToken != currentToken, let fresh = freshToken {
            return fresh
        }
        
        guard !isRefreshing else {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let newestToken = await authManager.getAccessToken()
            if newestToken != currentToken, let newest = newestToken {
                return newest
            }
            throw APIError.unauthorized
        }
        
        isRefreshing = true
        defer { isRefreshing = false }
        
        let newToken = try await refreshAction(currentToken)
        return newToken
    }
}
