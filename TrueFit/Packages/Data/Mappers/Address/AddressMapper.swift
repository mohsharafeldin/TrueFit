//
//  AddressMapper.swift
//  TrueFit
//
//  Created by AndrewMagdy on 05/07/2026.
//

import Foundation

public final class AddressMapper {

    
    static func toDomain(
        dto: ShopifyAddressResponse,
        address1: String,
        country: String,
        province: String,
        city: String,
        zip: String
    ) -> Address {
        Address(
            id: dto.id,
            address1: address1,
            country: country,
            province: province,
            city: city,
            zip: zip
        )
    }
    
    static func toDomain(detail: ShopifyAddressDetail) -> Address {
        Address(
            id: detail.id,
            address1: detail.address1 ?? "",
            country: detail.country ?? "",
            province: detail.province ?? "",
            city: detail.city ?? "",
            zip: detail.zip ?? ""
        )
    }
    
    // MARK: - Error Mapping
    
    static func mapError(_ error: Error) -> AddressError {
        if let apiError = error as? APIError {
            switch apiError {
            case .noInternetConnection:
                return .networkError
            case .graphQLErrors(let messages):
                let joined = messages.joined(separator: ". ")
                if joined.lowercased().contains("access token") {
                    return .invalidAccessToken
                }
                if joined.lowercased().contains("country") {
                    return .invalidCountry
                }
                if joined.lowercased().contains("province") {
                    return .invalidProvince
                }
                return .unknown(joined)
            default:
                return .unknown(apiError.localizedDescription)
            }
        }
        
        return .unknown(error.localizedDescription)
    }
}
