//
//  AddressRepositoryProtocol.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

public protocol AddressRepositoryProtocol {

    func createAddress(
        customerAccessToken: String,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) async throws -> Address

    func deleteAddress(
        customerAccessToken: String,
        addressId: String
    ) async throws -> String
    
    func updateAddress(
            customerAccessToken: String,
            addressId: String,
            address1: String,
            country: String,
            province: String,
            city: String,
            zip: String
        ) async throws -> Address
    func getAddresses(customerAccessToken: String) async throws -> [Address]

}
