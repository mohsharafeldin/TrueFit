//
//  File.swift
//  TrueFit
//
//  Created by Omar Khaled Jaafar on 27/06/2026.
//

struct CustomerDTO: Decodable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName  = "last_name"
    
    }
}
