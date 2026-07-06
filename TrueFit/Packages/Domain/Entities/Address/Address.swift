//
//  Address.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

public struct Address: Identifiable, Equatable,Hashable {
    public let id: String
    public var address1: String
    public var country: String
    public var province: String
    public var city: String
    public var zip: String

    public init(
        id: String,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) {
        self.id = id
        self.address1 = address1
        self.country = country
        self.province = province
        self.city = city
        self.zip = zip
    }
}
