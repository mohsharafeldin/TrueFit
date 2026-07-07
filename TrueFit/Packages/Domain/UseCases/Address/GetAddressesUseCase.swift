//
//  GetAddressesUseCase.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

 struct GetAddressesUseCase {
    private let repository: AddressRepositoryProtocol

    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }

    public func callAsFunction(
        customerAccessToken: String
    ) async throws -> [Address] {
        try await repository.getAddresses(customerAccessToken: customerAccessToken)
    }
}
