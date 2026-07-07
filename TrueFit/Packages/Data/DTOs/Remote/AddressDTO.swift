//
//  AddressDTO.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation


public struct ShopifyAddressResponse: Decodable {
    public let id: String
}



public struct CustomerAddressCreateData: Decodable {
    public let customerAddressCreate: CustomerAddressCreatePayload?
}

public struct CustomerAddressCreatePayload: Decodable {
    public let customerAddress: ShopifyAddressResponse?
    public let customerUserErrors: [ShopifyUserAddressError]?
}

public struct ShopifyUserAddressError: Decodable {
    public let code: String?
    public let field: [String]?
    public let message: String
}
public struct CustomerAddressDeleteData: Decodable {
    public let customerAddressDelete: CustomerAddressDeletePayload?
}

public struct CustomerAddressDeletePayload: Decodable {
    public let deletedCustomerAddressId: String?
    public let customerUserErrors: [ShopifyUserAddressError]?
}
public struct CustomerAddressUpdateData: Decodable {
    public let customerAddressUpdate: CustomerAddressUpdatePayload?
}

public struct CustomerAddressUpdatePayload: Decodable {
    public let customerAddress: ShopifyAddressResponse?
    public let customerUserErrors: [ShopifyUserAddressError]?
}
public struct CustomerInfoData: Decodable {
    public let customer: CustomerDTO?
}

public struct CustomerDTO: Decodable {
    public let id: String
    public let email: String?
    public let firstName: String?
    public let lastName: String?
    public let defaultAddress: ShopifyAddressResponse?
    public let addresses: AddressConnection
}

public struct AddressConnection: Decodable {
    public let edges: [AddressEdge]
}

public struct AddressEdge: Decodable {
    public let node: ShopifyAddressDetail
}

public struct ShopifyAddressDetail: Decodable {
    public let id: String
    public let address1: String?
    public let city: String?
    public let country: String?
    public let province: String?
    public let zip: String?
}
