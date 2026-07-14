//
//  AddressViewModel.swift
//  TrueFit
//
//  Created by AndrewMagdy on 06/07/2026.
//

import Foundation
import Combine

@MainActor
public final class AddressViewModel: ObservableObject {

    // MARK: - Published State

    @Published public private(set) var addresses: [Address] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    public let addressSelected = Combine.PassthroughSubject<Address, Never>()

    // MARK: - Dependencies (Use Cases)

    private let getAddresses: GetAddressesUseCase
    private let createAddress: CreateAddressUseCase
    private let updateAddress: UpdateAddressUseCase
    private let deleteAddress: DeleteAddressUseCase

    // MARK: - Context

    private let authManager: AuthManagerProtocol

    // MARK: - Init

     init(
        authManager: AuthManagerProtocol,
        getAddresses: GetAddressesUseCase,
        createAddress: CreateAddressUseCase,
        updateAddress: UpdateAddressUseCase,
        deleteAddress: DeleteAddressUseCase
    ) {
        self.authManager = authManager
        self.getAddresses = getAddresses
        self.createAddress = createAddress
        self.updateAddress = updateAddress
        self.deleteAddress = deleteAddress
    }

    // MARK: - Token Helper

    private func requireToken() -> String? {
        guard let token = authManager.getAccessToken() else {
            errorMessage = "Please sign in to manage your addresses."
            return nil
        }
        return token
    }

    // MARK: - Fetch

    public func loadAddresses() async {
        guard let token = requireToken() else { return }

        isLoading = true
        errorMessage = nil

        do {
            addresses = try await getAddresses(customerAccessToken: token)
        } catch {
            errorMessage = (error as? AddressError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Create

    public func addAddress(
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) async {
        guard let token = requireToken() else { return }

        isLoading = true
        errorMessage = nil

        do {
            let newAddress = try await createAddress(
                customerAccessToken: token,
                address1: address1,
                country: country,
                province: province,
                city: city,
                zip: zip
            )
            addresses.append(newAddress)
        } catch {
            errorMessage = (error as? AddressError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Update

    public func editAddress(
        addressId: String,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) async {
        guard let token = requireToken() else { return }

        isLoading = true
        errorMessage = nil

        do {
            let updated = try await updateAddress(
                customerAccessToken: token,
                addressId: addressId,
                address1: address1,
                country: country,
                province: province,
                city: city,
                zip: zip
            )

            if let index = addresses.firstIndex(where: { $0.id == addressId }) {
                addresses[index] = updated
            }
        } catch {
            errorMessage = (error as? AddressError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Delete

    public func removeAddress(addressId: String) async {
        guard let token = requireToken() else { return }

        isLoading = true
        errorMessage = nil

        do {
            let deletedId = try await deleteAddress(
                customerAccessToken: token,
                addressId: addressId
            )
            addresses.removeAll { $0.id == deletedId }
        } catch {
            errorMessage = (error as? AddressError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
    }
}
