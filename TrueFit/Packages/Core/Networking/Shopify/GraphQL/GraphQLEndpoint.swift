//
//  GraphQLEndpoint.swift
//  TrueFit
//

import Foundation

protocol GraphQLEndpoint {
    var query: String { get }
    var variables: [String: Any]? { get }
}
