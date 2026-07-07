//
//  AddressRemoteDataSource.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import ShopifyAPI
import Foundation

public final class AddressRemoteDataSource: AddressRemoteDataSourceProtocol {
    private let apollo: ApolloManager
    
    init(apollo: ApolloManager) {
        self.apollo = apollo
    }
    
    public func customerAddressCreate(
        customerAccessToken: String,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) async throws -> ShopifyAddressResponse {
        let addressInput = MailingAddressInput(
            address1: .some(address1),
            city: .some(city),
            country: .some(country),
            province: .some(province),
            zip: .some(zip)
        )
        
        let mutation = CreateAddressMutation(
            customerAccessToken: customerAccessToken,
            address: addressInput
        )
        
        let data = try await apollo.perform(mutation: mutation)
        
        if let userErrors = data.customerAddressCreate?.customerUserErrors, !userErrors.isEmpty {
            throw APIError.graphQLErrors(userErrors.map { $0.message })
        }
        
        guard let customerAddress = data.customerAddressCreate?.customerAddress else {
            throw APIError.noData
        }
        
        return ShopifyAddressResponse(id: customerAddress.id)
    }
}
