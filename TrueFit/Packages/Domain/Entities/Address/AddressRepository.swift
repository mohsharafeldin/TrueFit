//
//  AddressRepository.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

public final class AddressRepository: AddressRepositoryProtocol {
    private let remoteDataSource: AddressRemoteDataSourceProtocol

    public init(remoteDataSource: AddressRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    public func createAddress(
        customerAccessToken: String,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) async throws -> Address {
        do {
            let dto = try await remoteDataSource.customerAddressCreate(
                customerAccessToken: customerAccessToken,
                address1: address1,
                country: country,
                province: province,
                city: city,
                zip: zip
            )

            return AddressMapper.toDomain(
                dto: dto,
                address1: address1,
                country: country,
                province: province,
                city: city,
                zip: zip
            )
        } catch {
            throw AddressMapper.mapError(error)
        }
    }
    public func deleteAddress(
        customerAccessToken: String,
        addressId: String
    ) async throws -> String {
        do {
            return try await remoteDataSource.customerAddressDelete(
                customerAccessToken: customerAccessToken,
                addressId: addressId
            )
        } catch {
            throw AddressMapper.mapError(error)
        }
    }
    public func updateAddress(
        customerAccessToken: String,
        addressId: String,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) async throws -> Address {
        do {
            let dto = try await remoteDataSource.customerAddressUpdate(
                customerAccessToken: customerAccessToken,
                addressId: addressId,
                address1: address1,
                country: country,
                province: province,
                city: city,
                zip: zip
            )

            return AddressMapper.toDomain(
                dto: dto,
                address1: address1,
                country: country,
                province: province,
                city: city,
                zip: zip
            )
        } catch {
            throw AddressMapper.mapError(error)
        }
    }
    public func getAddresses(
        customerAccessToken: String
    ) async throws -> [Address] {
        do {
            let details = try await remoteDataSource.fetchCustomerAddresses(
                customerAccessToken: customerAccessToken
            )
            return details.map { AddressMapper.toDomain(detail: $0) }
        } catch {
            throw AddressMapper.mapError(error)
        }
    }
}
