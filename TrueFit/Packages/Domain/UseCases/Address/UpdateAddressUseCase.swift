//
//  UpdateAddressUseCase.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

 struct UpdateAddressUseCase {
    private let repository: AddressRepositoryProtocol

    public init(repository: AddressRepositoryProtocol) {
        self.repository = repository
    }

    public func callAsFunction(
        customerAccessToken: String,
        addressId: String,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) async throws -> Address {
        try await repository.updateAddress(
            customerAccessToken: customerAccessToken,
            addressId: addressId,
            address1: address1,
            country: country,
            province: province,
            city: city,
            zip: zip
        )
    }
}
