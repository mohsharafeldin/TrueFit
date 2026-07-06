//
//  KeychainManagerProtocol.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 01/07/2026.
//

import Foundation

public protocol KeychainManagerProtocol: Sendable {
    func save<T: Codable>(_ item: T, service: String, account: String) throws
    func read<T: Codable>(service: String, account: String, type: T.Type) throws -> T
    func delete(service: String, account: String) throws
}
