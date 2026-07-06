//
//  AddressRemoteDataSource.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation
import ShopifyAPI

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
    public func customerAddressDelete(
        customerAccessToken: String,
        addressId: String
    ) async throws -> String {
        let mutation = DeleteAddressMutation(
            customerAccessToken: customerAccessToken,
            id: addressId
        )

        let data = try await apollo.perform(mutation: mutation)

        if let userErrors = data.customerAddressDelete?.customerUserErrors, !userErrors.isEmpty {
            throw APIError.graphQLErrors(userErrors.map { $0.message })
        }

        guard let deletedId = data.customerAddressDelete?.deletedCustomerAddressId else {
            throw APIError.noData
        }

        return deletedId
    }
    public func customerAddressUpdate(
        customerAccessToken: String,
        addressId: String,
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

        let mutation = UpdateAddressMutation(customerAccessToken: customerAccessToken, id: addressId, address: addressInput
        )

        let data = try await apollo.perform(mutation: mutation)

        if let userErrors = data.customerAddressUpdate?.customerUserErrors, !userErrors.isEmpty {
            throw APIError.graphQLErrors(userErrors.map { $0.message })
        }

        guard let customerAddress = data.customerAddressUpdate?.customerAddress else {
            throw APIError.noData
        }

        return ShopifyAddressResponse(id: customerAddress.id)
    }
    public func fetchCustomerAddresses(
        customerAccessToken: String
    ) async throws -> [ShopifyAddressDetail] {
        let query = FetchCustomerAddressesQuery(
            customerAccessToken: customerAccessToken
        )

        let data = try await apollo.fetch(query: query)

        guard let customer = data.customer else {
            throw APIError.noData
        }

        return customer.addresses.edges.map { edge in
            ShopifyAddressDetail(
                id: edge.node.id,
                address1: edge.node.address1,
                city: edge.node.city,
                country: edge.node.country,
                province: edge.node.province,
                zip: edge.node.zip
            )
        }
    }
}
