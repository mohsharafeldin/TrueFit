//
//  DeleteAddressUseCase.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

 struct DeleteAddressUseCase {
    private let repository: AddressRepositoryProtocol

    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }

    public func callAsFunction(
        customerAccessToken: String,
        addressId: String
    ) async throws -> String {
        try await repository.deleteAddress(
            customerAccessToken: customerAccessToken,
            addressId: addressId
        )
    }
}
