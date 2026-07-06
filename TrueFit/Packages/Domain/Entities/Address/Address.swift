//
//  Address.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

public struct Address: Identifiable, Equatable {
    public let id: String
    public let address1: String
    public let country: String
    public let province: String
    public let city: String
    public let zip: String

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
