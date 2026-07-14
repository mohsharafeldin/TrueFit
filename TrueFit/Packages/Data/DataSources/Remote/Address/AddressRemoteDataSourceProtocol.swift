//
//  ShopifyAddressDataSourceProtocol.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation
public protocol AddressRemoteDataSourceProtocol {
    func customerAddressCreate(
        customerAccessToken: String,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) async throws -> ShopifyAddressResponse
    func customerAddressDelete(
           customerAccessToken: String,
           addressId: String
       ) async throws -> String
    func customerAddressUpdate(
            customerAccessToken: String,
            addressId: String,
            address1: String,
            country: String,
            province: String,
            city: String,
            zip: String
        ) async throws -> ShopifyAddressResponse
    
    func fetchCustomerAddresses(customerAccessToken: String) async throws -> [ShopifyAddressDetail]

    
}
